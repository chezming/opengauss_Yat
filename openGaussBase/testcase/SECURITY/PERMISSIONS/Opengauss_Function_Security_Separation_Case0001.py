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
Case Name   : 三权分立后系统管理员失去CREATEROLE属性
Description :
    1.已经安装好数据库
    2.三全分离开关打开，设置enableSeparationOfDuty=on，重启数据库生效
Expect      :
    1.CREATE ROLE
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
            '------Opengauss_Function_Security_Separation_Case0001 start----')
        self.common = Common()
        self.sh_primy = CommonSH('PrimaryDbUser')
        self.userNode = Node('PrimaryDbUser')
        self.DB_ENV_PATH = macro.DB_ENV_PATH
        self.Constant = Constant()

    def test_policy(self):
        logger.info('--------create user -----------')
        excute_cmd0 = f'source {self.DB_ENV_PATH};' \
                      f'gs_guc set -D {macro.DB_INSTANCE_PATH} -c ' \
                      f'"enableSeparationOfDuty=on";' \
                      f'gs_om -t stop && gs_om -t start'
        msg0 = self.userNode.sh(excute_cmd0).result()
        logger.info(msg0)
        sql_cmd1 = f'CREATE USER sysadmin01 WITH SYSADMIN password ' \
                   f'\'{macro.COMMON_PASSWD}\';'
        msg1 = self.sh_primy.execut_db_sql(sql_cmd1)
        logger.info(msg1)
        sql_cmd2 = f'CREATE ROLE manager IDENTIFIED BY ' \
                   f'\'{macro.COMMON_PASSWD}\';'
        excute_cmd2 = f'source {self.DB_ENV_PATH};' \
                      f'gsql -d {self.userNode.db_name} -p ' \
                      f'{self.userNode.db_port} -U sysadmin01 -W ' \
                      f'\'{macro.COMMON_PASSWD}\' -c "{sql_cmd2}"'
        logger.info(excute_cmd2)
        msg2 = self.userNode.sh(excute_cmd2).result()
        logger.info(msg2)
        self.assertIn(self.Constant.PERMISSION_DENY_MSG, msg2)

    def tearDown(self):
        logger.info('-----------恢复配置-----------')
        excute_cmd0 = f'source {self.DB_ENV_PATH};' \
                      f'gs_guc set -D {macro.DB_INSTANCE_PATH} ' \
                      f'-c "enableSeparationOfDuty=off";' \
                      f'gs_om -t stop && gs_om -t start'
        msg0 = self.userNode.sh(excute_cmd0).result()
        logger.info(msg0)
        sql_cmd1 = 'DROP ROLE IF EXISTS manager;' \
                   'DROP USER sysadmin01;'
        msg1 = self.sh_primy.execut_db_sql(sql_cmd1)
        logger.info(msg1)
        logger.info(
            '----Opengauss_Function_Security_Separation_Case0001 finish----')
