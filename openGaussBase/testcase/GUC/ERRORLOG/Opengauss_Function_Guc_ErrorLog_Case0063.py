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
Case Name   : 修改参数client_min_messages的值为非法值
Description :
    1.修改参数client_min_messages的值为数值类型：gs_guc set -N all -I all -c
    "client_min_messages=5"
    2.修改参数client_min_messages的值为其他字符串类型：gs_guc set -N all -I all -c
    "client_min_messages='tyyu'"
Expect      :
    1.返回报错信息：ERROR: The value "5" is outside the valid range(debug,debug5,
    debug4,debug3,debug2,
    debug1,log,info,notice,warning,error,fatal,panic) for parameter
    "client_min_messages"
    2.返回报错信息：ERROR: The value "tyyu" is outside the valid range(debug,
    debug5,debug4,debug3,
    debug2,debug1,log,info,notice,warning,error,fatal,panic) for parameter
    "client_min_messages"
History     :
"""
import unittest
from yat.test import Node
from yat.test import macro

from testcase.utils.Common import Common
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Logger import Logger


class Errorlog(unittest.TestCase):
    def setUp(self):
        self.logger = Logger()
        self.logger.info('--Opengauss_Function_Guc_ErrorLog_Case0063 start--')
        self.userNode = Node('PrimaryDbUser')
        self.primaryRoot = Node('PrimaryRoot')
        self.DB_ENV_PATH = macro.DB_ENV_PATH
        self.sh_primy = CommonSH('PrimaryDbUser')
        self.common = Common()

    def test_errorlog(self):
        self.logger.info('-------修改参数client_min_messages值为5---------')
        excute_cmd1 = f'source {self.DB_ENV_PATH};gs_guc set -N all -I all' \
                      f' -c "client_min_messages=5"'
        self.logger.info(excute_cmd1)
        msg1 = self.userNode.sh(excute_cmd1).result()
        self.logger.info(msg1)
        self.assertTrue(msg1.find("The value \"5\" for parameter "
                                  "\"client_min_messages\" is incorrect") > -1)
        self.logger.info('-------修改参数client_min_messages值为tyuu-----')
        excute_cmd2 = f'source {self.DB_ENV_PATH};' \
                      f'gs_guc reload -N all -I all -c ' \
                      f'"client_min_messages=\'tyuu\'"'
        self.logger.info(excute_cmd2)
        msg2 = self.userNode.sh(excute_cmd2).result()
        self.logger.info(msg2)
        self.assertTrue(msg2.find("") > -1)

    def tearDown(self):
        self.logger.info('--Opengauss_Function_Guc_ErrorLog_Case0063 finish--')
