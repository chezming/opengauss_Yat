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
Case Type   : 修改参数bgwriter_lru_maxpages为其他数据类型，观察预期结果；
Case Name   : Opengauss_Function_Guc_Resource_Case0072.py
Description :
         1、查询bgwriter_lru_maxpages默认值；
         2、修改bgwriter_lru_maxpages为false，"test",1001、空值等，并校验其预期结果；
Expect      :
        1、显示默认值；
        2、参数修改失败；
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
        self.log.info('-----------Opengauss_Function_Guc_Resource_Case0072.py start------------')
        self.Constant = Constant()
        self.commonsh = CommonSH('dbuser')

    def test_startdb(self):
        # 查询该参数默认值;
        sql_cmd = self.commonsh.execut_db_sql(f'''show bgwriter_lru_maxpages;''')
        self.log.info(sql_cmd)
        self.res = sql_cmd.splitlines()[-2].strip()
        # 使用设置gs_guc set设置bgwriter_lru_maxpages为false
        msg = self.commonsh.execute_gsguc('set', self.Constant.GSGUC_SUCCESS_MSG, 'bgwriter_lru_maxpages=false')
        self.log.info(msg)
        self.assertFalse(msg)
        # 修改失败重启后查询默认值
        msg = self.commonsh.restart_db_cluster()
        self.log.info(msg)
        self.assertTrue(msg)
        status = self.commonsh.get_db_cluster_status()
        self.assertTrue("Normal" in status)
        sql_cmd = self.commonsh.execut_db_sql(f'''show bgwriter_lru_maxpages;''')
        self.log.info(sql_cmd)
        self.assertIn(self.res, sql_cmd)
        # 使用设置gs_guc set设置bgwriter_lru_maxpages为test
        msg = self.commonsh.execute_gsguc('set', self.Constant.GSGUC_SUCCESS_MSG, 'bgwriter_lru_maxpages=test')
        self.log.info(msg)
        self.assertFalse(msg)
        # 修改失败重启后查询默认值
        msg = self.commonsh.restart_db_cluster()
        self.log.info(msg)
        self.assertTrue(msg)
        status = self.commonsh.get_db_cluster_status()
        self.assertTrue("Normal" in status)
        sql_cmd = self.commonsh.execut_db_sql(f'''show bgwriter_lru_maxpages;''')
        self.log.info(sql_cmd)
        self.assertIn(self.res, sql_cmd)
        # 使用设置gs_guc set设置bgwriter_lru_maxpages为10001
        msg = self.commonsh.execute_gsguc('set', self.Constant.GSGUC_SUCCESS_MSG, 'bgwriter_lru_maxpages=10001')
        self.log.info(msg)
        self.assertFalse(msg)
        # 修改失败重启后查询默认值
        msg = self.commonsh.restart_db_cluster()
        self.log.info(msg)
        self.assertTrue(msg)
        status = self.commonsh.get_db_cluster_status()
        self.assertTrue("Normal" in status)
        sql_cmd = self.commonsh.execut_db_sql(f'''show bgwriter_lru_maxpages;''')
        self.log.info(sql_cmd)
        self.assertIn(self.res, sql_cmd)
        # 使用设置gs_guc set设置bgwriter_lru_maxpages为空值
        msg = self.commonsh.execute_gsguc('set', self.Constant.GSGUC_SUCCESS_MSG, 'bgwriter_lru_maxpages=null')
        self.log.info(msg)
        self.assertFalse(msg)
        # 修改失败重启后查询默认值
        msg = self.commonsh.restart_db_cluster()
        self.log.info(msg)
        self.assertTrue(msg)
        status = self.commonsh.get_db_cluster_status()
        self.assertTrue("Normal" in status)
        sql_cmd = self.commonsh.execut_db_sql(f'''show bgwriter_lru_maxpages;''')
        self.log.info(sql_cmd)
        self.assertIn(self.res, sql_cmd)

    def tearDown(self):
        self.log.info('----------------恢复默认值----------------')
        sql_cmd = self.commonsh.execut_db_sql(f'''show bgwriter_lru_maxpages;''')
        self.log.info(sql_cmd)
        if self.res not in sql_cmd:
            msg = self.commonsh.execute_gsguc('set', self.Constant.GSGUC_SUCCESS_MSG,
                                              f'''show bgwriter_lru_maxpages={self.res}''')
            self.log.info(msg)
            msg = self.commonsh.restart_db_cluster()
            self.log.info(msg)
        status = self.commonsh.get_db_cluster_status()
        self.assertTrue("Normal" in status)
        self.log.info('--------------Opengauss_Function_Guc_Resource_Case0072.py执行完成---------------')
