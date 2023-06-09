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
'''

Case Type： 功能测试
Case Name： set_bit入参异常报错校验
Descption:set_bit(string,offset, newvalue)设置字符串中的位。

步骤 1.查看数据库状态，如果数据库没有启动则执行启动，如果已经启动则无操作
步骤 2.清理环境，设置参数
步骤 3.set_bit的入参异常进行报错校验
'''
import os
import unittest
from yat.test import Node
from yat.test import macro
import sys

sys.path.append(sys.path[0] + "/../")
from testcase.utils.Logger import Logger
from testcase.utils.Constant import Constant
from testcase.utils.Common import Common
from testcase.utils.CommonSH import CommonSH

logger = Logger()

class Bit_string_function(unittest.TestCase):

    def setUp(self):
        logger.info("------------------------Opengauss_Function_Binarystring_Set_Bit_Case0002开始执行--------------------------")
        logger.info("-----------查询数据库状态-----------")
        self.commonsh =  CommonSH('dbuser')
        self.common = Common()
        SqlMdg1 = self.commonsh.execut_db_sql('''set bytea_output to 'hex';''')
        logger.info(SqlMdg1)

    def test_set_bit(self):

        logger.info("-----------string不支持-----------")
        Normal_SqlMdg2 = self.commonsh.execut_db_sql("""SELECT set_bit('中国', 45, 0) AS RESULT;""")
        logger.info(Normal_SqlMdg2)
        self.assertTrue('ERROR:  function set_bit(unknown, integer, integer) is not unique' in Normal_SqlMdg2)

        logger.info("-----------offset超范围-----------")
        Normal_SqlMdg4 = self.commonsh.execut_db_sql("""SELECT set_bit(E'Th\\\\\\000omas'::bytea, 99, 0) AS RESULT;""")
        logger.info(Normal_SqlMdg4)
        self.assertTrue('ERROR:  index 99 out of valid range, 0..55' in Normal_SqlMdg4)

        logger.info("-----------newvalue非01-----------")
        Normal_SqlMdg5 = self.commonsh.execut_db_sql("""SELECT set_bit(E'Th\\\\\\000omas'::bytea, 45, 5) AS RESULT;""")
        logger.info(Normal_SqlMdg5)
        self.assertTrue('ERROR:  new bit must be 0 or 1' in Normal_SqlMdg5)

        logger.info("-----------多参、少参、空值-----------")
        Normal_SqlMdg6 = self.commonsh.execut_db_sql("""SELECT set_bit(E'Th\\\\\\000omas'::bytea, 45,1,1) AS RESULT;""")
        logger.info(Normal_SqlMdg6)
        self.assertTrue('does not exist' in Normal_SqlMdg6)
        Normal_SqlMdg7 = self.commonsh.execut_db_sql("""SELECT set_bit( 45, 0) AS RESULT;""")
        logger.info(Normal_SqlMdg7)
        self.assertTrue('does not exist' in Normal_SqlMdg7)
        Normal_SqlMdg8 = self.commonsh.execut_db_sql("""SELECT set_bit(E'Th\\\\\\000omas'::bytea, , 0) AS RESULT;""")
        logger.info(Normal_SqlMdg8)
        self.assertTrue('ERROR:  syntax error' in Normal_SqlMdg8)
        Normal_SqlMdg9 = self.commonsh.execut_db_sql("""SELECT set_bit(E'Th\\\\\\000omas'::bytea, 45, ) AS RESULT;""")
        logger.info(Normal_SqlMdg9)
        self.assertTrue('ERROR:  syntax error' in Normal_SqlMdg9)
        Normal_SqlMdg1 = self.commonsh.execut_db_sql("""SELECT set_bit(E''::bytea, 45, 0) AS RESULT;""")
        logger.info(Normal_SqlMdg1)
        self.assertTrue(Normal_SqlMdg1.splitlines()[2].strip(' ') == '')

    def tearDown(self):

        logger.info('------------------------Opengauss_Function_Binarystring_Set_Bit_Case0002执行结束--------------------------')