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
Case Type   : 服务端工具
Case Name   : 就地升级前巡检场景下执行，设置超时时间为1300S
Description :
     就地升级前巡检场景下执行，设置超时时间为1300S：gs_check -e binary_upgrade --time-out=1300
Expect      :
     检查失败
History     :
"""

import unittest
from yat.test import Node
from yat.test import macro
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

LOG = Logger()


class Tools(unittest.TestCase):
    def setUp(self):
        LOG.info('---Opengauss_Function_Tools_gs_check_Case0370 start---')
        self.dbuserNode = Node('dbuser')
        self.rootNode = Node('default')
        self.Constant = Constant()
        self.error_msg = f'The timeout parameter must be ' \
            f'set larger than default value 1500 seconds'

    def test_server_tools1(self):
        LOG.info('-------------就地升级前巡检场景下检查-------------')
        check_cmd1 = f'''source {macro.DB_ENV_PATH};
            gs_check -e binary_upgrade --time-out=1300;
            '''
        LOG.info(check_cmd1)
        msg1 = self.dbuserNode.sh(check_cmd1).result()
        LOG.info(msg1)
        self.assertIn(self.error_msg, msg1)

    def tearDown(self):
        LOG.info('--------------需清理环境-------------------')
        clear_cmd = f'rm -rf /tmp/check*;' \
            f'rm -rf {macro.DB_INSTANCE_PATH}/../tool/script/gspylib' \
            f'/inspection/output/CheckReport*;'
        LOG.info(clear_cmd)
        clear_msg = self.rootNode.sh(clear_cmd).result()
        LOG.info(clear_msg)
        LOG.info('-----------------产生的文件清理完成------------------')
        LOG.info('---Opengauss_Function_Tools_gs_check_Case0370 finish---')
