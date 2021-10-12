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
Case Name   : 修改参数session_respool为错误值，并校验其预期结果。
Description :
    1、查看session_respool默认值 期望：invalid_pool；
    show session_respool;
    2、修改session_respool为123等，期望：合理报错
    set session_respool to default_pool;
    3、恢复默认值 无需恢复
Expect      :
    1、查看session_respool默认值 期望：invalid_pool；
    2、修改session_respool为123等，期望：合理报错
    3、恢复默认值 无需恢复
History     :
"""

import unittest

from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

LOGGER = Logger()
COMMONSH = CommonSH('PrimaryDbUser')


class GucTestCase(unittest.TestCase):
    def setUp(self):
        LOGGER.info('==Guc_Load_Management_Case0044开始执行==')
        self.constant = Constant()
        status = COMMONSH.get_db_cluster_status()
        self.assertTrue('Degraded' in status or 'Normal' in status)

    def test_guc(self):
        LOGGER.info('==查询session_respool 期望：默认值InvalidGroup==')
        sql_cmd = COMMONSH.execut_db_sql('show session_respool;')
        LOGGER.info(sql_cmd)
        self.assertEqual('invalid_pool', sql_cmd.split('\n')[-2].strip())

        LOGGER.info('==修改session_respool为123，期望：合理报错==')
        LOGGER.info('==修改session_respool为123，'
                    '期望：修改失败，show参数为默认值==')
        sql_cmd = COMMONSH.execut_db_sql('''set session_respool to 123;
            show session_respool;''')
        LOGGER.info(sql_cmd)
        self.assertIn(self.constant.SQL_WRONG_MSG[1], sql_cmd)
        self.assertIn('invalid_pool', sql_cmd)

    def tearDown(self):
        LOGGER.info('==恢复默认值==')
        LOGGER.info('恢复默认值')
        sql_cmd = COMMONSH.execut_db_sql('show session_respool;')
        if 'invalid_pool' != sql_cmd.split('\n')[-2].strip():
            COMMONSH.execute_gsguc('set',
                                   self.constant.GSGUC_SUCCESS_MSG,
                                  'session_respool=invalid_pool')
            COMMONSH.restart_db_cluster()
        status = COMMONSH.get_db_cluster_status()
        self.assertTrue('Degraded' in status or 'Normal' in status)
        LOGGER.info('==-Guc_Load_Management_Case0044执行结束==')
