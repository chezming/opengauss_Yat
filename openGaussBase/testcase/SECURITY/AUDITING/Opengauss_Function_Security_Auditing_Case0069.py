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
Case Type   : Separation_Auditing
Case Name   : 开启数据库对象DIRECTORY的CREATE、DROP、ALTER操作审计功能，
                audit_system_object=262143
Description :
    1.设置gs_guc reload -N all -I all -c "audit_system_object=262143"
    2.登录数据库，创建DIRECTORY对象
    3.修改DIRECTORY对象
    4.删除DIRECTORY对象
    5.登录数据库，查看审计日志SELECT * FROM pg_query_audit('$start_time',
    '$end_time');时间设在最接近登录数据库的时间
Expect      :
    1.设置成功
    2.创建成功
    3.修改成功
    4.删除成功
    5.查询到创建、删除DIRECTORY信息
History     :
"""
import time
import unittest
from yat.test import Node
from yat.test import macro
from testcase.utils.Common import Common
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Logger import Logger


class Security(unittest.TestCase):
    def setUp(self):
        self.logger = Logger()
        self.logger.info(
            '====Opengauss_Function_Security_Auditing_Case0069 start====')
        self.common = Common()
        self.sh_primy = CommonSH('PrimaryDbUser')
        self.userNode = Node('PrimaryDbUser')
        self.DB_ENV_PATH = macro.DB_ENV_PATH

    def test_policy(self):
        self.logger.info('--------设置参数audit_system_object=262143-------')
        sql_cmd0 = f'CREATE USER user068 WITH SYSADMIN password ' \
                   f'\'{macro.COMMON_PASSWD}\';'
        excute_cmd0 = f'''
            source {self.DB_ENV_PATH}
            gs_guc reload -N all -I all -c "enable_access_server_directory=on"
            gs_guc reload -N all -I all -c "audit_system_object=262143"
            gsql -d {self.userNode.db_name} -p {self.userNode.db_port} \
            -c "{sql_cmd0}"'''
        msg0 = self.userNode.sh(excute_cmd0).result()
        self.logger.info(msg0)
        self.logger.info('--------------创建TEXT SEARCH对象---------------')
        start_time_msg = self.sh_primy.execut_db_sql("SELECT sysdate;")
        start_time = start_time_msg.splitlines()[2].strip()
        time.sleep(3)
        sql_cmd1 = f'''
            CREATE OR REPLACE DIRECTORY dir as '{macro.DB_INSTANCE_PATH}';
            ALTER DIRECTORY dir OWNER TO user068;
            DROP DIRECTORY dir;
            DROP USER user068;
            '''
        msg2 = self.sh_primy.execut_db_sql(sql_cmd1)
        self.logger.info(msg2)
        self.common.equal_sql_mdg(msg2, 'CREATE DIRECTORY', 'ALTER DIRECTORY',
                                'DROP DIRECTORY', 'DROP ROLE')
        time.sleep(3)
        end_time_msg = self.sh_primy.execut_db_sql('SELECT sysdate;')
        end_time = end_time_msg.splitlines()[2].strip()
        sql_cmd2 = f'''select * from pg_query_audit('{start_time}',
'{end_time}');'''
        msg2 = self.sh_primy.execut_db_sql(sql_cmd2)
        self.logger.info(msg2)
        self.assertTrue(msg2.find('CREATE OR REPLACE DIRECTORY dir') > -1)
        self.assertTrue(msg2.find('ALTER DIRECTORY dir OWNER TO user068') > -1)
        self.assertTrue(msg2.find('DROP DIRECTORY dir') > -1)

    def tearDown(self):
        self.logger.info('-----------恢复配置-----------')
        excute_cmd1 = f'''
            source {self.DB_ENV_PATH};
            gs_guc reload -N all -I all -c "audit_system_object=12295"
            gs_guc reload -N all -I all -c "enable_access_server_directory=off"
            '''
        msg1 = self.userNode.sh(excute_cmd1).result()
        self.logger.info(msg1)
        self.logger.info(
            '====Opengauss_Function_Security_Auditing_Case0069 finish====')
