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
--  @testpoint:使用vacuum命令，依次按语法添加full，freeze参数
'''
import sys
import unittest
sys.path.append(sys.path[0]+"/../")
from testcase.utils.Logger import Logger
from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH


logger = Logger()
commonsh = CommonSH('dbuser')
constant = Constant()

class SYS_Operation(unittest.TestCase):
    def setUp(self):
        logger.info('------------------------Opengauss_Function_DML_Set_Case0069开始执行-----------------------------')

    def test_vacuum(self):
        # 建表并插入数据
        sql_cmd1 = commonsh.execut_db_sql('''drop table if exists customer_info;
      CREATE TABLE customer_info(WR_RETURNED_DATE_SK INTEGER,WR_RETURNED_TIME_name varchar(200));
      insert into customer_info values (generate_series(1,10),'a');''')
        logger.info(sql_cmd1)
        self.assertIn(constant.TABLE_CREATE_SUCCESS, sql_cmd1)
        self.assertIn(constant.INSERT_SUCCESS_MSG, sql_cmd1)
        # 查询表的xmin,xmax,age(xmin),txid_current()信息;执行vacuum机制后查询表的xmin,xmax,age(xmin),txid_current()信息，将元组xmin设为2
        sql_cmd2 = commonsh.execut_db_sql('''select WR_RETURNED_DATE_SK,xmin,xmax,age(xmin),txid_current() from customer_info;
        vacuum full freeze customer_info;
        select WR_RETURNED_DATE_SK,xmin,xmax,age(xmin),txid_current() from customer_info;''')
        logger.info(sql_cmd2)
        self.assertIn(constant.VACUUM_SUCCESS_MSG, sql_cmd2)
        self.assertIn('2', sql_cmd2)

    # 清理环境
    def tearDown(self):
        logger.info('----------this is teardown-------')
        # 删除表
        sql_cmd4 = commonsh.execut_db_sql('''drop table customer_info;''')
        logger.info(sql_cmd4)
        logger.info('------------------------Opengauss_Function_DML_Set_Case0069执行结束--------------------------')
