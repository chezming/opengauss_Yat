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
Case Name   : authentication_timeout参数使用gs_guc reload设置为超边界值
Description : 
              1、查看authentication_timeout默认值；
              show authentication_timeout;
              2、使用设置gs_guc reload设置authentication_timeout为超边界值
              gs_guc reload -D {cluster/dn1}
              -c "authentication_timeout='11min'"
Expect      :
              1、显示默认值；
              2、参数修改失败；
"""

import unittest

from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

COMMONSH = CommonSH('PrimaryDbUser')


class GucTest(unittest.TestCase):

    def setUp(self):
        self.log = Logger()
        self.constant = Constant()
        self.log.info('==Guc_Connectionauthentication_Case0138开始==')
        status = COMMONSH.get_db_cluster_status()
        self.assertTrue("Normal" in status or "Degraded" in status)

    def test_startdb(self):
        self.log.info("查询该参数默认值")
        sql_cmd = COMMONSH.execut_db_sql('''show authentication_timeout;''')
        self.log.info(sql_cmd)
        self.assertEqual("1min", sql_cmd.split("\n")[-2].strip())
        self.log.info("设置authentication_timeout为超边界值")
        result = COMMONSH.execute_gsguc('reload',
                                        self.constant.GSGUC_SUCCESS_MSG,
                                        f'authentication_timeout=\'11min\'')
        self.log.info(result)
        self.assertFalse(result)

    def tearDown(self):
        self.log.info("恢复默认值")
        sql_cmd = COMMONSH.execut_db_sql('''show authentication_timeout;''')
        self.log.info(sql_cmd)
        if '1min' != sql_cmd.split('\n')[2].strip():
            result = COMMONSH.execute_gsguc('reload',
                                            self.constant.GSGUC_SUCCESS_MSG,
                                            f"authentication_timeout=1min")
            self.assertTrue(result)
        status = COMMONSH.get_db_cluster_status()
        self.assertTrue("Normal" in status or "Degraded" in status)
        self.log.info('==Guc_Connectionauthentication_Case0138完成==')
