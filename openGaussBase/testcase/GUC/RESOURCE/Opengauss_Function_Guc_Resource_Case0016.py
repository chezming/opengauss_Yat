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
Case Type   : GUC
Case Name   : 使用方式四ALTER SYSTEM SET paraname 修改max_process_memory值
Description :
        1.查看默认值max_process_memory;
        2.方式四修改该参数值ALTER SYSTEM SET max_process_memory to '8GB';
        3.重启数据库gs_om -t stop&&gs_om -t start
Expect      :
        1.默认值显示正常
        2-3.重启数据库后参数修改成功
History     : 
"""
import sys
import unittest
sys.path.append(sys.path[0] + "/../")
from testcase.utils.Logger import Logger
from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH

class Deletaduit(unittest.TestCase):
    def setUp(self):
        self.log = Logger()
        self.log.info('-----------Opengauss_Function_Guc_Resource_Case00016.py start------------')
        self.Constant = Constant()
        self.commonsh = CommonSH('dbuser')
    def test_startdb(self):
        #查看默认值
        sql_cmd = self.commonsh.execut_db_sql(f'''show max_process_memory;''')
        self.log.info(sql_cmd)
        self.res = sql_cmd.splitlines()[-2].strip()
        # 使用方式四ALTER SYSTEM SET paraname 修改max_process_memory
        Sqlmdg = self.commonsh.execut_db_sql('''ALTER SYSTEM SET max_process_memory to '8GB';''')
        self.log.info(Sqlmdg)
        self.assertIn('ALTER SYSTEM SET', Sqlmdg)
        # 重启数据库
        msg = self.commonsh.restart_db_cluster()
        self.log.info(msg)
        self.assertTrue(msg)
        # 查看修改后的值
        sql_cmd = self.commonsh.execut_db_sql(f'''show max_process_memory;''')
        self.log.info(sql_cmd)
        self.assertIn('8GB', sql_cmd)
    def tearDown(self):
        self.log.info('----------------恢复默认值-----------------------')
        sql_cmd = self.commonsh.execut_db_sql(f'''show max_process_memory;''')
        self.log.info(sql_cmd)
        if self.res not in sql_cmd:
            msg = self.commonsh.execute_gsguc('set', self.Constant.GSGUC_SUCCESS_MSG, f'max_process_memory={self.res}''')
            self.log.info(msg)
            msg = self.commonsh.restart_db_cluster()
            self.log.info(msg)
        status = self.commonsh.get_db_cluster_status()
        self.assertTrue("Normal" in status)
        self.log.info('---------------------Opengauss_Function_Guc_Resource_Case0016.py执行完成-------------------------')
