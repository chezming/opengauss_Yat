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
Case Name   : 使用gs_guc set方法设置参数nls_timestamp_format为YYYY-Mon-DD,
              观察预期结果
Description :
        1.查询nls_timestamp_format默认值
        2.修改参数值为YYYY-Mon-DD并重启数据库
        3.恢复参数默认值
Expect      :
        1.显示默认值为DD-Mon-YYYY HH:MI:SS.FF AM
        2.设置成功
        3.默认值恢复成功
History     :
"""
import unittest

from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

LOG = Logger()
commonsh = CommonSH('dbuser')


class DeveloperOptions(unittest.TestCase):
    def setUp(self):
        LOG.info(
            '------Opengauss_Function_DeveloperOptions_Case0048start----')
        self.constant = Constant()

    def test_nls_timestamp_format(self):
        LOG.info('--步骤1:查看默认值--')
        sql_cmd = commonsh.execut_db_sql('show nls_timestamp_format;')
        LOG.info(sql_cmd)
        self.res = sql_cmd.splitlines()[-2].strip()
        LOG.info('--步骤2:设置参数为YYYY-Mon-DD并重启数据库--')
        msg = commonsh.execute_gsguc('set',
                                     self.constant.GSGUC_SUCCESS_MSG,
                                     "nls_timestamp_format = 'YYYY-Mon-DD'")
        LOG.info(msg)
        self.assertTrue(msg)
        msg = commonsh.restart_db_cluster()
        LOG.info(msg)
        status = commonsh.get_db_cluster_status()
        self.assertTrue("Degraded" in status or "Normal" in status)
        LOG.info('--步骤3:查询该参数修改后的值--')
        sql_cmd = commonsh.execut_db_sql('show nls_timestamp_format;')
        LOG.info(sql_cmd)
        self.assertIn('YYYY-Mon-DD', sql_cmd)
        LOG.info('--步骤4:建表并插入时间类型--')
        sql_cmd = commonsh.execut_db_sql('''drop table if exists time_type_tab;
            create table time_type_tab (dfgh timestamp without time zone);
            insert into time_type_tab values ('2021-01-14');
            ''')
        LOG.info(sql_cmd)
        self.assertIn(self.constant.TABLE_CREATE_SUCCESS, sql_cmd)
        self.assertIn(self.constant.INSERT_SUCCESS_MSG, sql_cmd)
        LOG.info('--步骤5:查询，格式显示年月日--')
        sql_cmd = commonsh.execut_db_sql('select * from time_type_tab;')
        LOG.info(sql_cmd)
        self.assertIn('2021-01-14 00:00:00', sql_cmd)

    def tearDown(self):
        LOG.info('--步骤6:清理环境--')
        sql_cmd = commonsh.execut_db_sql('drop table if exists time_type_tab;')
        LOG.info(sql_cmd)
        sql_cmd = commonsh.execut_db_sql('show nls_timestamp_format;')
        LOG.info(sql_cmd)
        if self.res != sql_cmd.split('\n')[-2].strip():
            msg = commonsh.execute_gsguc('set',
                                         self.constant.GSGUC_SUCCESS_MSG,
                                         f"nls_timestamp_format='{self.res}'")
            LOG.info(msg)
            msg = commonsh.restart_db_cluster()
            LOG.info(msg)
        status = commonsh.get_db_cluster_status()
        self.assertTrue("Degraded" in status or "Normal" in status)
        sql_cmd = commonsh.execut_db_sql('show nls_timestamp_format;')
        LOG.info(sql_cmd)
        LOG.info(
            '------Opengauss_Function_DeveloperOptions_Case0048finish-----')
