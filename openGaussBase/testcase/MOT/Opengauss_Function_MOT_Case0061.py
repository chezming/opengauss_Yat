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
Case Type： MOT
Case Name： 结合MOT表，存储过程相关DDL
Descption:  1.创建MOT表 2.创建存储过程，结合MOT表的使用 3. 清理数据
'''

import unittest
import sys
sys.path.append(sys.path[0] + "/../")
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

logger = Logger()

class MOT_PROCEDURE_DDL_TEST(unittest.TestCase):

    def setUp(self):
        logger.info('----------------------------Opengauss_Function_MOT_Case0061开始执行-----------------------------')
        self.sh_primysh = CommonSH('PrimaryDbUser')
        self.constant = Constant()
        # logger.info('------------修改配置，并重启数据库------------')
        # self.configitem = "enable_incremental_checkpoint=off"
        # mod_msg = self.sh_primysh.execute_gsguc('set', self.constant.GSGUC_SUCCESS_MSG, self.configitem)
        # stopmsg = str(self.sh_primysh.stop_db_cluster())
        # startmsg = str(self.sh_primysh.start_db_cluster())
        # self.assertTrue(stopmsg)
        # self.assertTrue(startmsg)

    def test_MOT_procedure_DDL(self):
        logger.info('----------------------------开始测试存储过程相关SQL，创建MOT表，创建约束，清理数据-----------------------------')
        self.sql_cmd1 = f'''
                        --创建MOT表
                        drop foreign table if exists mot_table_test;
                        create foreign table mot_table_test(id int,name varchar(10));
                        '''
        self.sql_cmd2 = f'''
                        --创建存储过程，结合MOT表的使用
                        create or replace procedure transaction_mot()
                        as
                        begin
                            for i in 0..100 loop
                                insert into mot_table_test values(i,i||'a');
                            end loop;
                        end;
                        '''
        self.sql_cmd3 = f'''
                        call transaction_mot();
                        select * from mot_table_test limit 10;
                        --清理环境
                        drop procedure transaction_mot;
                        drop foreign table mot_table_test;
                        '''

        msg1 = self.sh_primysh.execut_db_sql(self.sql_cmd1)
        msg2 = self.sh_primysh.execut_db_sql(self.sql_cmd2)
        msg3 = self.sh_primysh.execut_db_sql(self.sql_cmd3)
        logger.info(msg1)
        logger.info(msg2)
        logger.info(msg3)
        self.assertIn(self.constant.CREATE_FOREIGN_SUCCESS_MSG, msg1)
        self.assertIn(self.constant.CREATE_PROCEDURE_SUCCESS_MSG, msg2)
        self.assertIn(self.constant.DROP_PROCEDURE_SUCCESS_MSG, msg3)

    def tearDown(self):
        # logger.info('----------------------------后置处理-----------------------------')
        # self.configitem = "enable_incremental_checkpoint=on"
        # mod_msg = self.sh_primysh.execute_gsguc('set', self.constant.GSGUC_SUCCESS_MSG, self.configitem)
        # stopmsg = str(self.sh_primysh.stop_db_cluster())
        # startmsg = str(self.sh_primysh.start_db_cluster())
        # self.assertTrue(stopmsg)
        # self.assertTrue(startmsg)
        logger.info('----------------------------Opengauss_Function_MOT_Case0061执行完成-----------------------------')
