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
Case Type   : security-auditing
Case Name   : 开启数据库对象PROCEDURE/FUNCTION的CREATE、DROP、ALTER操作审计功能，
                audit_system_object=255
Description :
            1.设置gs_guc reload -N all -I all -c  "audit_system_object=255"
            2.登录数据库，创建FUNCTION对象，CREATE FUNCTION func_add_sql(integer,
            integer) RETURNS integer
                AS 'select $1 + $2;'
                LANGUAGE SQL
                IMMUTABLE
                RETURNS NULL ON NULL INPUT;
            3.修改FUNCTION对象，ALTER FUNCTION func_add_sql(integer, integer)
            RENAME TO new_func_add_sql(integer, integer);
            4.删除FUNCTION对象，DROP FUNCTION new_func_add_sql(integer, integer);
            5.登录数据库，查看审计日志SELECT * FROM pg_query_audit('$start_time',
            '$end_time');时间设在最接近登录数据库的时间
Expect      :
            1.设置成功
            2.创建成功
            3.修改成功
            4.删除成功
            5.查询到创建、删除FUNCTION的信息
History     :
"""
import unittest
from yat.test import Node
from yat.test import macro
from testcase.utils.Common import Common
from testcase.utils.CommonSH import *
from testcase.utils.Logger import Logger


class Auditing(unittest.TestCase):
    def setUp(self):
        self.logger = Logger()
        self.logger.info(
            '-----Opengauss_Function_Security_Auditing_Case0047 start-----')
        self.sh_primy = CommonSH('PrimaryDbUser')
        self.userNode = Node('PrimaryDbUser')
        self.common = Common()
        self.DB_ENV_PATH = macro.DB_ENV_PATH

    def test_security(self):
        excute_cmd = f'source {self.DB_ENV_PATH};' \
                     f'gs_guc reload -N all -I all -c ' \
                     f'"audit_system_object=255"'
        msg2 = self.userNode.sh(excute_cmd).result()
        self.logger.info(msg2)
        start_time_msg = self.sh_primy.execut_db_sql('SELECT sysdate;')
        start_time = start_time_msg.splitlines()[2].strip()
        time.sleep(5)
        sql_cmd2 = 'CREATE FUNCTION func_add_sql(integer, integer) RETURNS ' \
                   'integer ' \
                   'AS \'select \$1 + \$2;\' ' \
                   'LANGUAGE SQL ' \
                   'IMMUTABLE ' \
                   'RETURNS NULL ON NULL INPUT; ' \
                   'ALTER FUNCTION func_add_sql(integer, integer) RENAME ' \
                   'TO new_func_add_sql;' \
                   'DROP FUNCTION new_func_add_sql(integer, integer);'
        msg2 = self.sh_primy.execut_db_sql(sql_cmd2)
        self.logger.info(msg2)
        time.sleep(5)
        end_time_msg = self.sh_primy.execut_db_sql('SELECT sysdate;')
        end_time = end_time_msg.splitlines()[2].strip()
        sql_cmd3 = f'select * from pg_query_audit(\'{start_time}\',\
                   \'{end_time}\');'
        excute_cmd3 = f'source {self.DB_ENV_PATH};' \
                      f'gsql -d {self.userNode.db_name} -p ' \
                      f'{self.userNode.db_port} -c "{sql_cmd3}"'
        msg3 = self.userNode.sh(excute_cmd3).result()
        self.logger.info(msg3)
        self.assertTrue(msg3.find('CREATE FUNCTION func_add_sql') > -1)
        self.assertTrue(msg3.find('ALTER FUNCTION func_add_sql') > -1)
        self.assertTrue(msg3.find('DROP FUNCTION new_func_add_sql') > -1)

    def tearDown(self):
        excute_cmd1 = f'source {self.DB_ENV_PATH};' \
                      f'gs_guc reload -N all -I all -c ' \
                      f'"audit_system_object=12295"'
        msg1 = self.userNode.sh(excute_cmd1).result()
        self.logger.info(msg1)
        self.logger.info(
            '----Opengauss_Function_Security_Auditing_Case0047 end----')
