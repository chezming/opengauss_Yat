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
Case Type   : 功能测试
Case Name   : overlay函数入参为特殊字符
Description :
    步骤 1.查看数据库状态，如果数据库没有启动则执行启动，如果已经启动则无操作
    步骤 2.入参是特殊字符
Expect      :
    步骤 1：数据库状态正常
    步骤 2：返回新字符串正确
History     :
"""
import unittest
import sys

sys.path.append(sys.path[0] + "/../")
from testcase.utils.Logger import Logger
from testcase.utils.CommonSH import CommonSH

logger = Logger()


class Overlay_function(unittest.TestCase):

    def setUp(self):
        logger.info("------------Opengauss_Function_Innerfunc_Overlay_Case0003开始执行--------------")
        self.commonsh = CommonSH('dbuser')

    def test_function(self):
        logger.info("-------------overlay函数采用特殊字符串作为入参---------------")

        sql_list = r"""SELECT overlay('?<+>~!%$&*;-' placing 'world' from 2 for 6 );"""

        msg = self.commonsh.execut_db_sql(sql_list)
        logger.info(msg)
        self.assertTrue(msg.splitlines()[2].strip() == '?world$&*;-')

    def tearDown(self):
        logger.info('--------------Opengauss_Function_Innerfunc_Overlay_Case0003执行结束-------------')
