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
Case Name   : 备份结果包含依赖于指定对象的对象信息（--include-depend-objs）
Description :
    1.创建数据库testdump
    2.创建模式，创建表并插入数据，设置表的所属模式
    3.创建表文件
    4.备份结果包含依赖于指定对象的对象信息（--include-depend-objs）
    5.连接数据库，清理环境
Expect      :
    1.创建数据库testdump成功
    2.创建模式成功,创建表并插入数据成功
    3.创建表文件
    4.导出成功
    5.清理环境成功
History     :
"""

import os
import unittest
from yat.test import Node
from yat.test import macro
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

LOG = Logger()


class Tools(unittest.TestCase):
    def setUp(self):
        LOG.info('-----Opengauss_Function_Tools_gs_dump_Case0066start-----')
        self.dbusernode = Node('dbuser')
        self.constant = Constant()
        self.path = os.path.join(macro.DB_INSTANCE_PATH, 'dump_config')

    def test_server_tools(self):
        LOG.info('------------------1.连接数据库并创建数据库-----------------')
        sql_cmd1 = '''drop database if exists testdump;
            create database testdump;
            '''
        excute_cmd1 = f'''source {macro.DB_ENV_PATH} ;
            gsql -d {self.dbusernode.db_name}\
            -p {self.dbusernode.db_port} -c "{sql_cmd1}";
            '''
        LOG.info(excute_cmd1)
        msg1 = self.dbusernode.sh(excute_cmd1).result()
        LOG.info(msg1)
        self.assertIn(self.constant.CREATE_DATABASE_SUCCESS, msg1)
        LOG.info('-------2.在创建好的数据库中创建模式，创建表\
        并插入数据并设置表的所属模式-------')
        sql_cmd2 = ''' drop schema if exists schema1;
            drop schema if exists schema2;
            drop schema if exists schema3;
            create schema  schema1;
            create schema  schema2;
            create schema  schema3;
            drop table if  exists t1;
            drop table if  exists t2;
            drop table if  exists t3;
            create table t1 (id int);
            insert into t1 values(1),(2),(3);
            create table t2 (id int);
            insert into t2 values(8),(2),(5);
            create table t3 (id int);
            insert into t3 values(9),(6),(3);
            alter table t1 set schema schema1;
            alter table t2 set schema schema2;
            alter table t3 set schema schema3;
            drop view if exists view_t1;
            create view view_t1 as select * from schema1.t1 ;
            drop index if exists index67 cascade;
            create unique index index67 on schema2.t2 (id);
            '''
        excute_cmd2 = f'''source {macro.DB_ENV_PATH} ;
            gsql -d testdump -p {self.dbusernode.db_port} -c "{sql_cmd2}";
            '''
        LOG.info(excute_cmd2)
        msg2 = self.dbusernode.sh(excute_cmd2).result()
        LOG.info(msg2)
        self.assertIn(self.constant.INSERT_SUCCESS_MSG, msg2)
        LOG.info('-----------------3.创建表文件----------------')
        shell_cmd = f'''echo 'schema1.t1' >> {self.path};
            echo 'schema2.t2' >> {self.path};
            echo 'schema3.t3' >> {self.path};
            '''
        LOG.info(shell_cmd)
        shell_msg = self.dbusernode.sh(shell_cmd).result()
        LOG.info(shell_msg)
        cat_cmd = f'cat {self.path};'
        LOG.info(cat_cmd)
        cat_msg = self.dbusernode.sh(cat_cmd).result()
        LOG.info(cat_msg)
        self.assertIn('schema1.t1', cat_msg)
        self.assertIn('schema2.t2', cat_msg)
        self.assertIn('schema3.t3', cat_msg)

        LOG.info('-------------4.备份结果包含依赖于指定对象的对象信息------------')
        excute_cmd3 = f'source {macro.DB_ENV_PATH} ;' \
            f'gs_dump ' \
            f'-p {self.dbusernode.db_port} testdump  ' \
            f'-F p  ' \
            f'--include-depend-objs ' \
            f'--include-table-file={self.path} ;'
        LOG.info(excute_cmd3)
        msg3 = self.dbusernode.sh(excute_cmd3).result()
        LOG.info(msg3)
        self.assertIn('CREATE TABLE t1', msg3)
        self.assertIn('CREATE TABLE t2', msg3)
        self.assertIn('COPY t1', msg3)
        self.assertIn('COPY t2', msg3)
        self.assertIn('CREATE UNIQUE INDEX index67 ON t2', msg3)
        self.assertIn('CREATE VIEW view_t1(id) AS', msg3)


    def tearDown(self):
        LOG.info('-----------------5.清理环境：删除数据库-----------------')
        sql_cmd4 = ''' drop database if exists testdump; '''
        excute_cmd4 = f'''source {macro.DB_ENV_PATH} ;
            gsql -d {self.dbusernode.db_name}\
            -p {self.dbusernode.db_port} -c "{sql_cmd4}";
            rm -rf {macro.DB_INSTANCE_PATH}/dump_config;
            '''
        LOG.info(excute_cmd4)
        msg4 = self.dbusernode.sh(excute_cmd4).result()
        LOG.info(msg4)
        LOG.info('----Opengauss_Function_Tools_gs_dump_Case0066finish----')
