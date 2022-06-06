"""
Copyright (c) 2022 Huawei Technologies Co.,Ltd.

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
Case Type   : 用户-权限测试
Case Name   : 非初始用户（sysadmin用户）创建目录对象，合理报错
Description :
    1.创建系统管理员用户
    2.系统管理员创建目录对象
    3.删除用户
Expect      :
    1.创建成功
    2.合理报错
    3.删除成功
History     :
"""
import unittest

from yat.test import Node
from yat.test import macro

from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

logger = Logger()
commonsh = CommonSH('dbuser')
constant = Constant()


class DIRECTORY(unittest.TestCase):
    def setUp(self):
        logger.info(
            '---Opengauss_Function_DDL_Create_Directory_Case0002开始执行-----')
        self.user_node = Node('dbuser')
        self.DB_ENV_PATH = macro.DB_ENV_PATH
        self.sh_primy = CommonSH('dbuser')

    def test_common_user_permission(self):
        # 创建系统管理员用户
        sql_cmd1 = commonsh.execut_db_sql(f'''
        drop user if exists sys_test cascade;
        create user sys_test with sysadmin password '{macro.COMMON_PASSWD}';''')
        logger.info(sql_cmd1)
        self.assertIn(constant.CREATE_ROLE_SUCCESS_MSG, sql_cmd1)
        # 系统管理员创建目录对象，合理报错
        sql_cmd2 = ('''DROP DIRECTORY if exists test_dir;
                     create DIRECTORY test_dir as '/tmp/';''')
        excute_cmd1 = f'''
                source {self.DB_ENV_PATH};
                gsql -d {self.user_node.db_name} -p {self.user_node.db_port} \
-U sys_test -W '{macro.COMMON_PASSWD}' -c "{sql_cmd2}"
                            '''
        msg1 = self.user_node.sh(excute_cmd1).result()
        logger.info(msg1)
        self.assertTrue(
            msg1.find('ERROR:  permission denied to create directory') > -1)

    def tearDown(self):
        logger.info('----------this is teardown-------')
        sql_cmd3 = commonsh.execut_db_sql('''drop user sys_test cascade;''')
        logger.info(sql_cmd3)
        logger.info(
            '----Opengauss_Function_DDL_Create_Directory_Case0002执行结束---')
