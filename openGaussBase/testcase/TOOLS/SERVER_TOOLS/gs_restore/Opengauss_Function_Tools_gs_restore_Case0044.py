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
Case Name   : 参数-S, --sysadmin=NAME（添加name）
Description :
    1.创建数据
    2.导出数据
    3.导入数据
    4.清理环境
Expect      :
    1.创建数据成功
    2.导出数据成功
    3.导入数据成功
    4.清理环境成功
History     :
"""

import unittest
from yat.test import Node
from yat.test import macro
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger
from testcase.utils.CommonSH import CommonSH


class Tools(unittest.TestCase):
    def setUp(self):
        self.log = Logger()
        self.constant = Constant()
        self.dbuser_node = Node('dbuser')
        self.root_user = Node('default')
        self.commonsh = CommonSH('dbuser')

    def test_server_tools1(self):
        self.log.info("--Opengauss_Function_Tools_gs_restore_Case0044开始执行--")
        self.log.info("----------------------创建数据-----------------------")
        sql_cmd = self.commonsh.execut_db_sql(f'''create table test\
            (id  int,name char(20));
            insert into test values(1,'xixi'),(2,'haha'),(3,'hehe');
            create tablespace ds_location1 relative location \
            'tablespace/tablespace_1';
            alter tablespace ds_location1 rename to ds_location3;
            alter tablespace ds_location3 owner to manager;
            create database  test;
            create schema schema1;
            create or replace function func_increment_sql(i integer)
            returns integer
            as \$$
            begin
                    return i+1;
            end;
                    \$$ language plpgsql;
            ''')
        self.log.info(sql_cmd)
        self.assertIn(self.constant.CREATE_FUNCTION_SUCCESS_MSG, sql_cmd)

        self.log.info("----------------导出tar格式文件-----------------")
        mkdir_cmd = f"mkdir /home/test_restore/ ;" \
            f"chmod -R 777 /home/test_restore/"
        self.log.info(mkdir_cmd)
        msg = self.root_user.sh(mkdir_cmd).result()
        self.log.info(msg)
        dump_cmd = f"source {macro.DB_ENV_PATH};" \
            f"gs_dump -p {self.dbuser_node.db_port} " \
            f"{self.dbuser_node.db_name} -f " \
            f"/home/test_restore/test2.tar -F t"
        self.log.info(dump_cmd)
        msg = self.dbuser_node.sh(dump_cmd).result()
        self.log.info(msg)
        self.assertIn(self.constant.GS_DUMP_SUCCESS_MSG, msg)

        self.log.info("--------------导入之前导出的数据----------------")
        restore_cmd = f"source {macro.DB_ENV_PATH};" \
            f"gs_restore  -p {self.dbuser_node.db_port} " \
            f" -d test /home/test_restore/test2.tar -S=hsl_0145"
        self.log.info(restore_cmd)
        msg = self.dbuser_node.sh(restore_cmd).result()
        self.log.info(msg)
        self.assertIn(self.constant.RESTORE_SUCCESS_MSG, msg)

    def tearDown(self):
        self.log.info("----------------------清理环境-----------------------")
        sql_cmd = self.commonsh.execut_db_sql(f'''drop table test  cascade;
            drop tablespace ds_location3;
            drop database test ;
            drop schema schema1 cascade;
            drop function  func_increment_sql;''')
        self.log.info(sql_cmd)
        rm_cmd = f"rm -rf /home/test_restore"
        self.log.info(rm_cmd)
        msg = self.root_user.sh(rm_cmd).result()
        self.log.info(msg)
        self.log.info("--Opengauss_Function_Tools_gs_restore_Case0044执行结束--")
