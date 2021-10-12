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
Case Type   : 服务端工具
Case Name   : 指定导出的表数选项大于100，使用通配符
Description :
    1.连接数据库
    2.创建数据库test
    3.切换到数据库test
    4.创建105个表
    5.退出数据库
    6.source环境变
    7.指定导出的表数选项大于100，使用通配符
    8.连接数据库，清理环境
Expect      :
    1.数据库连接成功
    2.创建数据库test成功
    3.切换到数据库test
    4.创建表成功
    5.创建视图成功
    6.source环境变量
    7.导出成功
    8.清理环境成功
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
        LOG.info('-----Opengauss_Function_Tools_gs_dump_Case0049start-----')
        self.dbuser_node = Node('dbuser')
        self.constant = Constant()

    def test_server_tools(self):
        LOG.info('------------------连接数据库并创建数据库-----------------')
        sql_cmd1 = '''          drop database if exists test;
                                create database test;
                                '''
        excute_cmd1 = f'''      source {macro.DB_ENV_PATH} ;
                                gsql -d {self.dbuser_node.db_name}\
                                -p {self.dbuser_node.db_port} -c "{sql_cmd1}"
                                        '''
        LOG.info(excute_cmd1)
        msg1 = self.dbuser_node.sh(excute_cmd1).result()
        LOG.info(msg1)
        self.assertIn(self.constant.CREATE_DATABASE_SUCCESS, msg1)
        LOG.info('--------------在创建好的数据库中创建表--------------')
        sql_cmd2 = ''' 
                    declare
                    sql_str  varchar;
                    begin
                        for i in 1..105 loop
                            sql_str := 'create table t_' || i ||'(id int);';
                            execute immediate sql_str;
                        end loop;
                    end;
                '''
        excute_cmd2 = f'''source {macro.DB_ENV_PATH} ;
        gsql -d test -p {self.dbuser_node.db_port} -c "{sql_cmd2}"
                                        '''
        LOG.info(excute_cmd2)
        msg2 = self.dbuser_node.sh(excute_cmd2).result()
        LOG.info(msg2)
        self.assertIn(self.constant.CREATE_ANONYMOUS_BLOCK_SUCCESS_MSG, msg2)
        LOG.info('-----指定导出的表个数大于100(表个数105)，使用通配符------')
        excute_cmd3 = f'''source {macro.DB_ENV_PATH} ;
        gs_dump -p {self.dbuser_node.db_port} test -F p\
        -f {macro.DB_INSTANCE_PATH}/dump_qm -t 't*';
                      '''
        LOG.info(excute_cmd3)
        msg3 = self.dbuser_node.sh(excute_cmd3).result()
        LOG.info(msg3)
        self.assertIn(self.constant.GS_DUMP_SUCCESS_MSG, msg3)
        excute_cmd4 = f'''cat  {macro.DB_INSTANCE_PATH}/dump_qm||grep\
'CREATE TABLE t_'|wc -l'''
        msg4 = self.dbuser_node.sh(excute_cmd4).result()
        LOG.info(msg4)
        self.assertIn('105', msg4)
        excute_cmd5 = f'''cat  {macro.DB_INSTANCE_PATH}/dump_qm||grep\
'COPY t_'|wc -l'''
        msg5 = self.dbuser_node.sh(excute_cmd5).result()
        LOG.info(msg5)
        self.assertIn('105', msg5)

    def tearDown(self):
        LOG.info('-----------------清理环境：删除数据库-----------------')
        sql_cmd6 = '''  drop database if exists test; '''
        excute_cmd6 = f'''source {macro.DB_ENV_PATH} ;
                        gsql -d {self.dbuser_node.db_name}\
                        -p {self.dbuser_node.db_port} -c "{sql_cmd6}";
                        rm -rf {macro.DB_INSTANCE_PATH}/dump_qm;
                                       '''
        LOG.info(excute_cmd6)
        msg6 = self.dbuser_node.sh(excute_cmd6).result()
        LOG.info(msg6)
        LOG.info('----Opengauss_Function_Tools_gs_dump_Case0049finish----')
