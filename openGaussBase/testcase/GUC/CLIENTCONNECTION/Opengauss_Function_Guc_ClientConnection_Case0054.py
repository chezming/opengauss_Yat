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
Case Name   : 使用gs_guc set方法设置参数default_transaction_isolation为
             repeatable read,观察预期结果
Description :
        1.查询default_transaction_isolation默认值
        2.修改参数值为repeatable read
        3.恢复参数默认值
Expect      :
        1.显示默认值为read committed
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


class ClientConnection(unittest.TestCase):
    def setUp(self):
        LOG.info(
            '------Opengauss_Function_Guc_ClientConnection_Case0054start---')
        self.constant = Constant()

    def test_default_transaction_isolation(self):
        LOG.info('--步骤1:查看默认值--')
        sql_cmd = commonsh.execut_db_sql('show default_transaction_isolation;')
        LOG.info(sql_cmd)
        self.res = sql_cmd.splitlines()[-2].strip()
        LOG.info('--步骤2:gs_guc set方法设置参数值并重启数据库--')
        msg = commonsh.execute_gsguc('set',
                                     self.constant.GSGUC_SUCCESS_MSG,
                                     "default_transaction_isolation"
                                     " = 'repeatable read'")
        LOG.info(msg)
        self.assertTrue(msg)
        msg = commonsh.restart_db_cluster()
        LOG.info(msg)
        status = commonsh.get_db_cluster_status()
        self.assertTrue("Degraded" in status or "Normal" in status)
        LOG.info('--步骤3:查看修改后的值--')
        sql_cmd = commonsh.execut_db_sql('show default_transaction_isolation;')
        LOG.info(sql_cmd)
        self.assertIn('repeatable read', sql_cmd)

    def tearDown(self):
        LOG.info('--步骤4:恢复默认值--')
        sql_cmd = commonsh.execut_db_sql('show default_transaction_isolation;')
        LOG.info(sql_cmd)
        if self.res != sql_cmd.split('\n')[2].strip():
            msg = commonsh.execute_gsguc('reload',
                                         self.constant.GSGUC_SUCCESS_MSG,
                                         f"default_transaction_isolation"
                                         f" = '{self.res}'")
            LOG.info(msg)
        sql_cmd = commonsh.execut_db_sql('show default_transaction_isolation;')
        LOG.info(sql_cmd)
        LOG.info(
            '--Opengauss_Function_Guc_ClientConnection_Case0054执行完成--')
