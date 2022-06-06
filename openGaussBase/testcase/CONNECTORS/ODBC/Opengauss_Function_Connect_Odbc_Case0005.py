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
Case Type   : c++驱动odbc
Case Name   : 普通模式连接数据库，连接信息有误
Description :
    1.创建库、用户，用户密码不含特殊字符，并赋权
    2.配置pg_hba入口
    3.配置ODBC数据源，参数项设置错误
    4.检查依赖库
    5.配置环境变量
    6.连接数据库
Expect      :
    1.执行成功
    2.执行成功
    3.数据源配置成功
    4.执行成功
    5.成功生成环境变量配置文件
    6.连接失败，提示
History     :
"""
import os
import re
import unittest
import sys

from yat.test import Node
from yat.test import macro
from testcase.utils.Common import Common
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger


class ConnODBC5(unittest.TestCase):
    def setUp(self):
        self.LOG = Logger()
        text = f'---{os.path.basename(sys.argv[4])} start---'
        self.LOG.info(text)
        self.pri_user = Node(node='PrimaryDbUser')
        self.pri_root = Node(node='PrimaryRoot')
        self.pri_sh = CommonSH('PrimaryDbUser')
        self.common = Common()
        self.constant = Constant()
        self.local_lib_path = '/usr/local/odbclib'
        self.odbc_lib_path = os.path.join(self.local_lib_path, 'odbc', 'lib')
        self.sourcefile = os.path.join(self.local_lib_path, "odbcsrc")
        self.odbc_so = 'psqlodbcw.so'
        self.db_name = 'tb_connect_odbc_case0005'
        self.db_user = 'user_connect_odbc_case0005'

    def test_conn(self):
        text = '---step1: 创建库、用户，用户密码不含特殊字符，并赋权 expect: 成功---'
        self.LOG.info(text)
        sql_cmd = f"drop database if exists {self.db_name}; " \
            f"drop user if exists {self.db_user}; " \
            f"create database {self.db_name}; " \
            f"create user {self.db_user} with password " \
            f"'{macro.PASSWD_INITIAL}'; " \
            f"grant all privileges on database {self.db_name} " \
            f"to {self.db_user};"
        sql_res = self.pri_sh.execut_db_sql(sql_cmd)
        self.LOG.info(sql_res)
        expect = f'{self.constant.DROP_DATABASE_SUCCESS}(.*)' \
            f'{self.constant.DROP_ROLE_SUCCESS_MSG}(.*)' \
            f'{self.constant.CREATE_DATABASE_SUCCESS}(.*)' \
            f'{self.constant.CREATE_ROLE_SUCCESS_MSG}(.*)' \
            f'{self.constant.GRANT_SUCCESS_MSG}'
        regex_res = re.search(expect, sql_res, re.S)
        self.assertIsNotNone(regex_res, text)

        text = '---step2:配置pg_hba入口;expect:成功---'
        self.LOG.info(text)
        cp_cmd = f"cp {os.path.join(macro.DB_INSTANCE_PATH, 'pg_hba.conf')}" \
            f" {os.path.join(macro.DB_INSTANCE_PATH, 'pg_hba_bak.conf')}"
        cp_result = self.pri_user.sh(cp_cmd).result()
        self.LOG.info(cp_result)
        self.assertEqual('', cp_result)
        gsguc_cmd = f'source {macro.DB_ENV_PATH};' \
            f'gs_guc reload -D {macro.DB_INSTANCE_PATH} -h ' \
            f'"host {self.db_name} {self.db_user} ' \
            f'{self.pri_user.db_host}/32 sha256"'
        gsguc_res = self.pri_user.sh(gsguc_cmd).result()
        self.assertIn(self.constant.GSGUC_SUCCESS_MSG, gsguc_res, text)

        text = '---step3:配置数据源odbcinst.ini;expect:成功---'
        self.LOG.info(text)
        odbcinst_ini = self.common.set_odbcinst_ini(self.pri_root,
                           self.local_lib_path, self.odbc_lib_path)
        self.assertTrue(odbcinst_ini, text)

        text = '---step4:检查依赖库;expect:成功---'
        self.LOG.info(text)
        lib_file = os.path.join(self.odbc_lib_path, self.odbc_so)
        self.common.check_libfile(self.pri_root, lib_file,
                                  os.path.join(self.local_lib_path, 'lib'))

        text = '---step5:在客户端配置环境变量,导入环境变量;expect:成功---'
        self.LOG.info(text)
        odbc_src = self.common.set_odbc_src(self.pri_root, self.local_lib_path,
                       self.odbc_lib_path, self.sourcefile)
        self.assertTrue(odbc_src, text)

        text = '---step6.1:配置错误信息数据源odbc.ini并连接; expect:连接失败---'
        self.LOG.info(text)
        ini_content_err1 = ['10.10.10.10', self.db_name, self.db_user,
                            macro.PASSWD_INITIAL, self.pri_user.db_port]
        odbc_ini = self.common.set_odbc_ini(self.pri_root, ini_content_err1,
                       self.local_lib_path)
        self.assertTrue(odbc_ini, text)
        connect_cmd = f'source {self.sourcefile};' \
            f'isql -v gaussodbc'
        connect_msg = self.pri_root.sh(connect_cmd).result()
        self.assertIn(self.constant.odbc_connect_fail_msg, connect_msg, text)
        
        ini_content_err2 = [self.pri_user.db_host, 'er_db', self.db_user,
                            macro.PASSWD_INITIAL, self.pri_user.db_port]
        odbc_ini = self.common.set_odbc_ini(self.pri_root, ini_content_err2,
                       self.local_lib_path)
        self.assertTrue(odbc_ini, text)
        connect_cmd = f'source {self.sourcefile};' \
            f'isql -v gaussodbc'
        connect_msg = self.pri_root.sh(connect_cmd).result()
        self.assertIn(self.constant.odbc_connect_fail_msg, connect_msg, text)
        
        ini_content_err3 = [self.pri_user.db_host, self.db_name, 'er_user',
                            macro.PASSWD_INITIAL, self.pri_user.db_port]
        odbc_ini = self.common.set_odbc_ini(self.pri_root, ini_content_err3,
                       self.local_lib_path)
        self.assertTrue(odbc_ini, text)
        connect_cmd = f'source {self.sourcefile};' \
            f'isql -v gaussodbc'
        connect_msg = self.pri_root.sh(connect_cmd).result()
        self.assertIn(self.constant.odbc_connect_fail_msg, connect_msg, text)
        
        ini_content_err4 = [self.pri_user.db_host, self.db_name, self.db_user,
                            'er_password', self.pri_user.db_port]
        odbc_ini = self.common.set_odbc_ini(self.pri_root, ini_content_err4,
                       self.local_lib_path)
        self.assertTrue(odbc_ini, text)
        connect_cmd = f'source {self.sourcefile};' \
            f'isql -v gaussodbc'
        connect_msg = self.pri_root.sh(connect_cmd).result()
        self.assertIn(self.constant.odbc_connect_fail_msg, connect_msg, text)
        
        er_port = str(int(self.pri_user.db_port) + 1)
        ini_content_err5 = [self.pri_user.db_host, self.db_name, self.db_user,
                            macro.PASSWD_INITIAL, er_port]
        odbc_ini = self.common.set_odbc_ini(self.pri_root, ini_content_err5,
                       self.local_lib_path)
        self.assertTrue(odbc_ini, text)
        connect_cmd = f'source {self.sourcefile};' \
            f'isql -v gaussodbc'
        connect_msg = self.pri_root.sh(connect_cmd).result()
        self.assertIn(self.constant.odbc_connect_fail_msg, connect_msg, text)

    def tearDown(self):
        text = '---step1:恢复配置文件中的信息;expect:成功---'
        self.LOG.info(text)
        restore_cmd = f'mv ' \
            f'{os.path.join(macro.DB_INSTANCE_PATH, "pg_hba_bak.conf")} ' \
            f'{os.path.join(macro.DB_INSTANCE_PATH, "pg_hba.conf")};'
        self.LOG.info(restore_cmd)
        restore_msg = self.pri_user.sh(restore_cmd).result()

        remove_cmd = f'rm -rf ' \
            f'{os.path.join(self.local_lib_path, "odbc.ini")} ' \
            f'{os.path.join(self.local_lib_path, "odbcinst.ini")} ' \
            f'{self.sourcefile} '
        self.LOG.info(remove_cmd)
        remove_msg = self.pri_root.sh(remove_cmd).result()

        text_2 = '---step2:删除库、用户，用户密码 expect: 成功---'
        self.LOG.info(text_2)
        sql_cmd = f'drop database if exists {self.db_name}; ' \
            f'drop user if exists {self.db_user};'
        sql_res = self.pri_sh.execut_db_sql(sql_cmd)
        self.LOG.info(sql_res)
        expect = f'{self.constant.DROP_DATABASE_SUCCESS}(.*)' \
            f'{self.constant.DROP_ROLE_SUCCESS_MSG}'
        regex_res = re.search(expect, sql_res, re.S)
        self.LOG.info(expect)
        self.LOG.info(regex_res)
        self.assertEqual('', restore_msg, text)
        self.assertEqual('', remove_msg, text)
        self.assertIsNotNone(regex_res, text_2)
        
        text = f'---{os.path.basename(sys.argv[4])} end---'
        self.LOG.info(text)
