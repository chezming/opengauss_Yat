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
Case Type   : GUC参数
Case Name   : skew_option参数使用gs_guc set设置并验证其预期结果
Description :
    1.查询skew_option默认值
    2.修改skew_option为off
    3.重启使其生效
    4.校验其预期结果
    5.恢复默认值
Expect      :
    1.查询skew_option默认值成功
    2.修改skew_option为off成功
    3.重启集群成功
    4.该参数值为off，达到预期效果
    5.恢复默认值成功
History     :
"""

import sys
import unittest

from testcase.utils.Logger import Logger
from testcase.utils.Common import Common
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant

LOG = Logger()


class GucQueryplan(unittest.TestCase):
    def setUp(self):
        LOG.info('----this is setup------')
        LOG.info('---Opengauss_Function_Guc_Queryplan_Case0047开始执行----')
        self.com = Common()
        self.comsh = CommonSH('PrimaryDbUser')
        self.constant = Constant()
        self.pv = ''

    def test_Guc_queryplan(self):
        LOG.info('--------查看skew_option默认值------')
        msg = self.comsh.execut_db_sql('show skew_option;')
        LOG.info(msg)
        self.pv = msg.splitlines()[-2].strip()

        LOG.info('-------修改skew_option为optimal---------')
        msg = self.comsh.execute_gsguc('set', self.constant.GSGUC_SUCCESS_MSG,
                                      "skew_option='off'")
        LOG.info(msg)

        LOG.info('-------重启数据库------')
        self.comsh.restart_db_cluster()
        status = self.comsh.get_db_cluster_status()
        self.assertTrue("Normal" in status or 'Degraded' in status)

        LOG.info('-------校验其预期结果-------')
        msg = self.comsh.execut_db_sql('show skew_option;')
        LOG.info(msg)
        res = msg.splitlines()[-2].strip()
        self.assertIn('off', res)

    def tearDown(self):
        LOG.info('--------this is tearDown--------')
        LOG.info('-------恢复默认值------')
        msg = self.comsh.execute_gsguc('set', self.constant.GSGUC_SUCCESS_MSG,
                                       f"skew_option='{self.pv}'")
        LOG.info(msg)
        stopmsg = self.comsh.stop_db_cluster()
        LOG.info(stopmsg)
        startmsg = self.comsh.start_db_cluster()
        LOG.info(startmsg)
        LOG.info('----Opengauss_Function_Guc_Queryplan_Case0047执行完成---')
