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
'''
--  @date:2020/11/9
--  @testpoint:使用analyze收集多列统计信息,参数default_statistics_target为正数
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
        logger.info('------------------------Opengauss_Function_DML_Set_Case0098开始执行-----------------------------')

    def test_analyze(self):
        # 创建表并插入数据
        sql_cmd1 = commonsh.execut_db_sql('''drop table if exists customer_info;
        CREATE TABLE customer_info(WR_RETURNED_DATE_SK INTEGER ,WR_RETURNED_TIME_name varchar(200) );
        insert into customer_info values(generate_series(1,200),'a');''')
        logger.info(sql_cmd1)
        self.assertIn(constant.TABLE_CREATE_SUCCESS, sql_cmd1)
        self.assertIn(constant.INSERT_SUCCESS_MSG, sql_cmd1)
        # 使用ANALYZE语句并查看上次更新时间；查询系统表PG_STATS，只显示WR_RETURNED_DATE_SK列的数据
        sql_cmd2 = commonsh.execut_db_sql('''ANALYZE customer_info(WR_RETURNED_DATE_SK,WR_RETURNED_TIME_name);
       select attname,null_frac,n_distinct,n_dndistinct from PG_STATS where tablename='customer_info';
        select relname,last_autovacuum,last_analyze from pg_stat_user_tables where relname='customer_par';
        ANALYZE verbose customer_info(WR_RETURNED_DATE_SK,WR_RETURNED_TIME_name);
        select attname,null_frac,n_distinct,n_dndistinct from PG_STATS where tablename='customer_info';
        ''')
        logger.info(sql_cmd2)
        self.assertIn(constant.ANALYZE_SUCCESS_MSG, sql_cmd2)

    # 清理环境
    def tearDown(self):
        logger.info('----------this is teardown-------')
        # 删除表
        sql_cmd3 = commonsh.execut_db_sql('''drop table customer_info''')
        logger.info(sql_cmd3)
        logger.info('------------------------Opengauss_Function_DML_Set_Case0098执行结束--------------------------')
