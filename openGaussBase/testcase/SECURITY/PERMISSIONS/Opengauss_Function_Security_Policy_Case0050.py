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
Case Type   : policy
Case Name   : 密码少于最小长度要求password_min_length=8
Description :
    1.在postgres.conf中设置password_min_length=8，重启数据库生效
    2.初始用户执行：create user wf with password 'Gaus@123';
    create user user001 with password 'Gaus@12';
Expect      :
    1.设置成功，数据库重启成功
    CREATE ROLE
    2.提示密码至少包含8位
History     :
"""
import random
import string
import unittest
from yat.test import macro
from testcase.utils.Common import Common
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

logger = Logger()


class Policy(unittest.TestCase):
    def setUp(self):
        logger.info('==Opengauss_Function_Security_Policy_Case0050 start==')
        self.common = Common()
        self.sh_primy = CommonSH('PrimaryDbUser')
        str_lst = []
        for j in range(10):
            str_lst.append(random.choice(string.ascii_lowercase))
        part_lst = str_lst[:4]
        str_passwd = "".join(part_lst)
        self.new_password1 = str_passwd.capitalize() + "@" + "156"
        self.new_password2 = str_passwd.capitalize() + "@" + "15"
        self.DB_ENV_PATH = macro.DB_ENV_PATH
        self.Constant = Constant()
        self.configure = 'password_min_length=8'
        msg0 = self.common.config_set_modify(self.configure)
        logger.info(msg0)
        status_msg = self.sh_primy.get_db_cluster_status()
        logger.info(status_msg)
        self.assertTrue("Degraded" in status_msg or "Normal" in status_msg)

    def test_policy(self):
        logger.info('---------查看password_min_length默认值----------')
        sql_cmd0 = 'show password_min_length;'
        msg0 = self.sh_primy.execut_db_sql(sql_cmd0)
        logger.info(msg0)
        self.common.equal_sql_mdg(msg0, 'password_min_length', '8', '(1 row)',
                                  flag='1')
        logger.info('-----------创建用户--------------')
        sql_cmd1 = f'create user wf with password \'{self.new_password1}\';'
        sql_cmd2 = f'create user user001 with password' \
                   f' \'{self.new_password2}\';'
        msg1 = self.sh_primy.execut_db_sql(sql_cmd1)
        logger.info(msg1)
        self.assertIn(self.Constant.CREATE_ROLE_SUCCESS_MSG, msg1)
        msg2 = self.sh_primy.execut_db_sql(sql_cmd2)
        logger.info(msg2)
        self.assertTrue(
            msg2.find('Password must contain at least 8 characters') > -1)

    def tearDown(self):
        logger.info('-----------清理环境-----------')
        sql_cmd1 = 'drop user if exists wf cascade;' \
                   'drop user if exists user001 cascade;'
        msg1 = self.sh_primy.execut_db_sql(sql_cmd1)
        logger.info(msg1)
        logger.info('==Opengauss_Function_Security_Policy_Case0050 finish==')