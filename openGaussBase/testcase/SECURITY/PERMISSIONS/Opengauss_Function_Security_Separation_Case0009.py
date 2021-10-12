"""
Copyright (c) 2021 Huawei Technologies Co.,Ltd.

openGauss is licensed under Mulan PSL v2.
You can use this software according to the terms and conditions of the Mulan PSL v2.
You may obtain a copy of Mulan PSL v2 at:

          http://license.coscl.org.cn/MulanPSL2

THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
See the Mulan PSL v2 for more details.
"""
"""
Case Type   : security-Separation_rights
Case Name   : 三权分立后系统管理员对其他用户放在属于各自模式下的表无权限
Description :
    1.初始用户执行：create user sysadmin01 with sysadmin password 'Qazwsx@123';
                create schema myschema;
                create table myschema.table02(id1 int,id2 int,id3 int);
    2.sysadmin01 用户执行：SELECT * FROM myschema.table02;
Expect      :
    1.CREATE ROLE
    CREATE SCHEMA
    CREATE TABLE
    2.PERMISSION DENIED
History     :
"""
import unittest
from yat.test import Node
from yat.test import macro

from testcase.utils.Common import Common
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

logger = Logger()


class Policy(unittest.TestCase):
    def setUp(self):
        logger.info(
            '------Opengauss_Function_Security_Separation_Case0009 start-----')
        self.common = Common()
        self.sh_primy = CommonSH('PrimaryDbUser')
        self.userNode = Node('PrimaryDbUser')
        self.DB_ENV_PATH = macro.DB_ENV_PATH
        self.Constant = Constant()

    def test_policy(self):
        logger.info('-----------create user -------------')
        excute_cmd0 = f'source {self.DB_ENV_PATH};' \
                      f'gs_guc set -D {macro.DB_INSTANCE_PATH}' \
                      f' -c "enableSeparationOfDuty=on";' \
                      f'gs_om -t stop && gs_om -t start'
        msg0 = self.userNode.sh(excute_cmd0).result()
        logger.info(msg0)
        sql_cmd1 = f'create user sysadmin01 with sysadmin password ' \
                   f'\'{macro.COMMON_PASSWD}\';' \
                   f'create schema myschema;' \
                   f'create table myschema.table02(id1 int,id2 int,id3 int);'
        msg1 = self.sh_primy.execut_db_sql(sql_cmd1)
        logger.info(msg1)
        sql_cmd2 = 'SELECT * FROM myschema.table02;'
        excute_cmd2 = f'source {self.DB_ENV_PATH};' \
                      f'gsql -d {self.userNode.db_name} -p ' \
                      f'{self.userNode.db_port} -U sysadmin01 -W ' \
                      f'\'{macro.COMMON_PASSWD}\' -c "{sql_cmd2}"'
        logger.info(excute_cmd2)
        msg2 = self.userNode.sh(excute_cmd2).result()
        logger.info(msg2)
        self.assertIn(self.Constant.PERMISSION_DENIED, msg2)

    def tearDown(self):
        logger.info('-----------恢复配置，并清理环境-----------')
        excute_cmd0 = f'source {self.DB_ENV_PATH};' \
                      f'gs_guc set -D {macro.DB_INSTANCE_PATH} ' \
                      f'-c "enableSeparationOfDuty=off";' \
                      f'gs_om -t stop && gs_om -t start'
        msg0 = self.userNode.sh(excute_cmd0).result()
        logger.info(msg0)
        sql_cmd1 = 'DROP TABLE IF EXISTS myschema.table02 CASCADE;' \
                   'DROP SCHEMA IF EXISTS myschema CASCADE;' \
                   'DROP USER IF EXISTS sysadmin01 CASCADE;'
        msg1 = self.sh_primy.execut_db_sql(sql_cmd1)
        logger.info(msg1)
        logger.info(
            '-----Opengauss_Function_Security_Separation_Case0009 finish-----')
