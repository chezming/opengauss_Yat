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
Case Type   : 服务端工具
Case Name   : 以INSERT命令带列名（INSERT INTO表（列、…）值…）方式导出数据
Description :
    1.连接数据库：
    2.创建数据
    3.退出数据库
    4.source环境变量
    5.以INSERT命令带列名（INSERT INTO表（列、…）值…）方式导出数据
    6.连接数据库，清理环境
Expect      :
    1.数据库连接成功
    2.创建数据成功
    3.退出数据库
    4.source环境变量
    5.以INSERT命令带列名（INSERT INTO表（列、…）值…）方式导出数据成功
    6.清理环境成功
History     :
"""
import unittest
from yat.test import Node
from yat.test import macro
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

LOG = Logger()


class Tools(unittest.TestCase):
    def setUp(self):
        LOG.info('----Opengauss_Function_Tools_gs_dumpall_Case0019start----')
        self.dbuser_node = Node('dbuser')
        self.constant = Constant()

    def test_server_tools(self):
        LOG.info('-----------连接数据库创建数据-------------')
        sql_cmd1 = '''          
                    drop table if  exists t1;
                    drop table if  exists t2;
                    create table t1 (i int);
                    insert into t1 values(1),(2),(3);
                    create table t2 (id int);
                    insert into t2 values(8),(2),(5);
                                '''
        excute_cmd1 = f'''   
                    source {macro.DB_ENV_PATH} ;
                    gsql -d {self.dbuser_node.db_name}\
                    -p {self.dbuser_node.db_port} -c "{sql_cmd1}"
                                        '''
        LOG.info(excute_cmd1)
        msg1 = self.dbuser_node.sh(excute_cmd1).result()
        LOG.info(msg1)
        self.assertIn(self.constant.INSERT_SUCCESS_MSG, msg1)
        LOG.info('------以INSERT命令带列名（INSERT INTO表（列、…）值…）方式导出数据-----')
        excute_cmd2 = f'''
                source {macro.DB_ENV_PATH} ;
                gs_dumpall -p {self.dbuser_node.db_port} \
                --attribute-inserts;
                          '''
        LOG.info(excute_cmd2)
        msg2 = self.dbuser_node.sh(excute_cmd2).result()
        LOG.info(msg2)
        self.assertIn(self.constant.gs_dumpall_success_msg, msg2)
        self.assertIn('CREATE TABLE t1', msg2)
        self.assertIn('CREATE TABLE t2', msg2)
        self.assertIn('INSERT INTO t1 (i) VALUES (1);', msg2)
        self.assertIn('INSERT INTO t2 (id) VALUES (8);', msg2)

    def tearDown(self):
        LOG.info('---清理环境---')
        sql_cmd3 = '''  
            drop table if exists test1;
            drop table if exists test1;
            '''
        excute_cmd3 = f'''
            source {macro.DB_ENV_PATH} ;
            gsql -d {self.dbuser_node.db_name}\
            -p {self.dbuser_node.db_port} -c "{sql_cmd3}";
                          '''
        LOG.info(excute_cmd3)
        msg3 = self.dbuser_node.sh(excute_cmd3).result()
        LOG.info(msg3)
        LOG.info('----Opengauss_Function_Tools_gs_dumpall_Case0019finish----')
