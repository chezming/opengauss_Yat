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
Case Type   : 数据库系统
Case Name   : 数据库兼容A模式，localDate类型setObject插入Date类型数据，并使用getObject获取结果
Description :
    1.写配置文件
    2.编译java工具
    3.运行java工具
Expect      :
History     :
"""
import unittest
import os
from datetime import date, timedelta
import time
from yat.test import Node
from yat.test import macro
from testcase.utils.Logger import Logger
from testcase.utils.Common import Common


class Jdbcisreadonly(unittest.TestCase):

    def setUp(self):
        self.log = Logger()
        self.db_primary_user_node = Node(node='PrimaryDbUser')
        self.db_primary_root_node = Node(node='PrimaryRoot')
        self.log.info("-----------this is setup-----------")
        self.log.info("Opengauss_Function_JDBC_Set_Get_Object_Case0008 start")
        self.targetpath = "/home/jdbc_test"
        self.properties = os.path.join(self.targetpath,
                                       "jdbc_case0001.properties")
        self.sql_path = os.path.join(self.targetpath, "jdbc_set_get_object")
        self.java_name = "jdbc_set_get_object_case0008"
        self.common = Common()

    def test_index(self):
        self.log.info('--------1.写配置文件-------')
        self.common.scp_file(self.db_primary_root_node,
                             f"{self.java_name}.java", self.targetpath)
        result = self.db_primary_root_node.sh(
            f"touch {self.properties}").result()
        self.log.info(result)
        config = f'echo "password=' \
            f'{self.db_primary_user_node.db_password}"> {self.properties}'
        self.db_primary_root_node.sh(config)
        config = f'echo "port={self.db_primary_user_node.db_port}">> ' \
            f'{self.properties}'
        self.db_primary_root_node.sh(config)
        config = f'echo "hostname={self.db_primary_user_node.db_host}">> ' \
            f'{self.properties}'
        self.db_primary_root_node.sh(config)
        config = f'echo "user={self.db_primary_user_node.db_user}">> ' \
            f'{self.properties}'
        self.db_primary_root_node.sh(config)
        config = f'echo "dbname={self.db_primary_user_node.db_name}">> ' \
            f'{self.properties}'
        self.db_primary_root_node.sh(config)
        config = f'echo "stringtype=unspecified">> {self.properties}'
        self.db_primary_root_node.sh(config)
        config = f'cat {self.properties}'
        result = self.db_primary_root_node.sh(config).result()
        self.assertTrue("password=" in result and "port=" in result
                        and "hostname=" in result and "user=" in result
                        and "dbname=" in result)

        self.log.info('--------------2. 编译java工具------------------')
        self.db_primary_root_node.scp_put(macro.JDBC_PATH,
                                          f"{self.targetpath}/postgresql.jar")
        cmd = f"javac -encoding utf-8 -cp " \
            f"{os.path.join(self.targetpath, 'postgresql.jar')} " \
            f"{os.path.join(self.targetpath, f'{self.java_name}.java')}"
        self.log.info(cmd)
        result = self.db_primary_root_node.sh(cmd).result()
        self.log.info(result)

        self.log.info("-------------3.运行java工具---------------------")
        cmd = f" java -cp {os.path.join(self.targetpath, 'postgresql.jar')}" \
            f":{self.targetpath} " \
            f"{self.java_name} -F {self.properties}"
        self.log.info(cmd)
        result = self.db_primary_root_node.sh(cmd).result()
        self.log.info(result)
        self.assertIn('第1行结果：+999999999-12-31T23:59:59.999999999', result)
        self.assertIn('第2行结果：-999999999-01-01T00:00', result)
        self.assertIn('第3行结果：null', result)

        today = time.strftime("%Y-%m-%dT%H", time.localtime())
        self.assertIn(f'第4行结果：{today}', result)
        self.assertIn(f'第5行结果：{today}', result)
        self.assertIn(f'第11行结果：{today}', result)
        self.assertIn(f'第12行结果：{time.strftime("%Y-%m-%d", time.localtime())}'
                      f'T00:00', result)

        self.assertIn(f'第6行结果：2020-02-29T23:59:59', result)
        self.assertIn(f'第7行结果：2020-02-29T23:59:59', result)
        self.assertIn('第8行结果：+999999999-12-31T23:59:59.999999999', result)
        self.assertIn('第9行结果：-999999999-01-01T00:00', result)
        self.assertIn('第10行结果：1970-01-01T00:00', result)

        tomorrow = (date.today() + timedelta(days=+1)).strftime("%Y-%m-%d")
        self.assertIn(f'第13行结果：{tomorrow}', result)
        yesterday = (date.today() + timedelta(days=-1)).strftime("%Y-%m-%d")
        self.assertIn(f'第14行结果：{yesterday}', result)

    def tearDown(self):
        self.log.info('------------this is tearDown-------------')
        self.log.info('------------------清理环境-------------')
        cmd = f"rm -rf {self.targetpath}"
        self.log.info(cmd)
        self.db_primary_root_node.sh(cmd)
        self.log.info("Opengauss_Function_JDBC_Set_Get_Object_Case0008 end")