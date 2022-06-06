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
Case Name   : 只导入已列举的index的定义（多个）
Description :
        1.创建表并插入数据：
        2.创建索引
        3.导出数据
        4..导入之前导出的数据
        5.清理环境
Expect      :
        1.创建表并插入数据成功
        2.创建索引成功
        3.导出数据成功
        4.导入索引失败
        5.清理环境成功
History     :
"""

import unittest
from yat.test import Node
from yat.test import macro
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

Log = Logger()


class Tools(unittest.TestCase):
    def setUp(self):
        Log.info("--Opengauss_Function_Tools_gs_restore_Case0029开始执行--")
        self.constant = Constant()
        self.dbuser_node = Node('dbuser')
        self.root_user = Node('default')
        self.expect_msg = 'ERROR:  relation "index" already exists'

    def test_server_tools1(self):
        Log.info("--------------------创建表并插入数据--------------------")
        sql_cmd = f'''create table test1 (id  int,name char(20));
            insert into test1 values(1,'xixi'),(2,'haha'),(3,'hehe');
            create table test2 (id  int,name char(20));
            insert into test2 values(12,'xixi'),(22,'haha'),(33,'hehe');
            create table test3(id  int,name char(20));
            insert into test3 values(123,'xiyxi'),(212,'hayha'),(313,'heyhe');
            create table test4(id  int,name char(20));
            insert into test4 values(33,'xiao'),(296,'bai'),(783,'cai');
            create table test5(id  int,name char(20));
            insert into test5 values(7,'yang'),(29886,'bai'),(9,'lao');
             '''
        excute_cmd = f'''source {macro.DB_ENV_PATH} ;
            gsql -d {self.dbuser_node.db_name} \
            -p {self.dbuser_node.db_port} -c "{sql_cmd}"
            '''
        Log.info(excute_cmd)
        msg = self.dbuser_node.sh(excute_cmd).result()
        Log.info(msg)
        self.assertIn(self.constant.INSERT_SUCCESS_MSG, msg)

        Log.info("----------------------创建索引-----------------------")
        sql_cmd = f'''create index  index1 on test1(id);
            create index  index2 on test2(id);
            create index  index3 on test3(id);
            create index  index4 on test4(id);
            create index  index5 on test5(id);
            '''
        excute_cmd = f"source {macro.DB_ENV_PATH} ;" \
            f"gsql -d {self.dbuser_node.db_name} -p " \
            f"{self.dbuser_node.db_port} -c '{sql_cmd}'"
        Log.info(excute_cmd)
        msg = self.dbuser_node.sh(excute_cmd).result()
        Log.info(msg)
        self.assertIn(self.constant.CREATE_INDEX_SUCCESS_MSG, msg)

        Log.info("------------------------导出数据-------------------------")
        mkdir_cmd = f"mkdir /home/test_restore/ ;" \
            f"chmod -R 777 /home/test_restore/"
        Log.info(mkdir_cmd)
        msg = self.root_user.sh(mkdir_cmd).result()
        Log.info(msg)

        dump_cmd = f"source {macro.DB_ENV_PATH};" \
            f"gs_dump -p {self.dbuser_node.db_port} " \
            f"{self.dbuser_node.db_name} " \
            f"-f /home/test_restore/test2.tar -F t"
        Log.info(dump_cmd)
        msg = self.dbuser_node.sh(dump_cmd).result()
        Log.info(msg)
        self.assertIn(self.constant.GS_DUMP_SUCCESS_MSG, msg)

        Log.info("--------------导入之前导出的数据----------------")
        restore_cmd = f"source {macro.DB_ENV_PATH};" \
            f"gs_restore -p {self.dbuser_node.db_port} " \
            f"-d {self.dbuser_node.db_name} " \
            f"/home/test_restore/test2.tar --index=index1 " \
            f"--index=index2 --index=index3"
        Log.info(restore_cmd)
        msg = self.dbuser_node.sh(restore_cmd).result()
        Log.info(msg)
        self.assertIn(self.expect_msg.replace('index', 'index1'), msg)
        self.assertIn(self.expect_msg.replace('index', 'index2'), msg)
        self.assertIn(self.expect_msg.replace('index', 'index3'), msg)

    def tearDown(self):
        Log.info("------------------------清理环境-------------------------")
        sql_cmd = f'''drop table test1  cascade;
            drop table test2  cascade;
            drop table test3  cascade;
            drop table test4  cascade;
            drop table test5  cascade;
            '''
        excute_cmd = f"source {macro.DB_ENV_PATH} ;" \
            f"gsql -d {self.dbuser_node.db_name} -p " \
            f"{self.dbuser_node.db_port} -c '{sql_cmd}'"
        Log.info(excute_cmd)
        msg = self.dbuser_node.sh(excute_cmd).result()
        Log.info(msg)
        rm_cmd = f"rm -rf /home/test_restore"
        Log.info(rm_cmd)
        msg = self.root_user.sh(rm_cmd).result()
        Log.info(msg)
        Log.info("---Opengauss_Function_Tools_gs_restore_Case0029执行结束---")
