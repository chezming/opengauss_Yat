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
Case Type   : GUC
Case Name   : 使用alter database方法设置参数gin_fuzzy_search_limit为1000,
              观察预期结果
Description :
        1.查询gin_fuzzy_search_limit默认值
        2.创建数据库
        3.修改参数值为1000
        4.删除数据库
Expect      :
        1.显示默认值0
        2.数据库创建成功
        3.设置成功
        4.删除成功
History     :
"""
import unittest
import time
from yat.test import Node
from yat.test import macro

from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger


class ClientConnection(unittest.TestCase):
    def setUp(self):
        self.log = Logger()
        self.log.info(
            '--Opengauss_Function_Guc_ClientConnection_Case0164start--')
        self.constant = Constant()
        self.commonsh = CommonSH('dbuser')
        self.user_node = Node('dbuser')
        self.DB_ENV_PATH = macro.DB_ENV_PATH

    def test_gin_fuzzy_search_limit(self):
        # 查询默认值
        sql_cmd = self.commonsh.execut_db_sql('''show gin_fuzzy_search_limit;''')
        self.log.info(sql_cmd)
        self.assertEqual('0', sql_cmd.split('\n')[-2].strip())
        # 创建数据库
        sql_cmd = self.commonsh.execut_db_sql('''drop database if 
            exists test_spdb164;
            create database test_spdb164;
            ''')
        self.log.info(sql_cmd)
        self.assertIn(self.constant.CREATE_DATABASE_SUCCESS, sql_cmd)
        # 修改数据库级别参数
        sql_cmd = self.commonsh.execut_db_sql('''alter database test_spdb164 
            set gin_fuzzy_search_limit to 1000;
            ''')
        self.log.info(sql_cmd)
        self.assertIn(self.constant.ALTER_DATABASE_SUCCESS_MSG, sql_cmd)
        time.sleep(3)
        # 查询
        sql_cmd = '''show gin_fuzzy_search_limit;'''
        excute_cmd1 = f'''source {self.DB_ENV_PATH};
            gsql -d test_spdb164\
            -p {self.user_node.db_port}\
            -c "{sql_cmd}"\
            '''
        self.log.info(sql_cmd)
        msg1 = self.user_node.sh(excute_cmd1).result()
        self.log.info(msg1)
        self.assertEqual('1000', msg1.split('\n')[-2].strip())

    def tearDown(self):
        self.log.info('----------------恢复默认值-----------------------')
        sql_cmd = self.commonsh.execut_db_sql('''drop database if exists 
            test_spdb164;
            ''')
        self.log.info(sql_cmd)
        self.log.info(
            '---Opengauss_Function_Guc_ClientConnection_Case0164finish----')
