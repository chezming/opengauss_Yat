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
Case Type   : GUC
Case Name   : 使用alter system set设置track_stmt_session_slot为边界值
Description :
    1、查询track_stmt_session_slot默认值，show track_stmt_session_slot;
       查询log_min_duration_statement默认值，show log_min_duration_statement;
    2、设置log_min_duration_statement为0;
       gs_guc reload -D {cluster/dn1} -c "log_min_duration_statement=0";
    3、使用altem system set方式修改为边界值0,校验是否生效;
       alter system set track_stmt_session_slot to 0;
    4、查询statement_history表记录;
       create table {self.tb_name}(a int,b int);
       select * from statement_history where query like '%{self.tb_name}%';
    5、使用alter system set方式设置track_stmt_session_slot为边界值2147483647;
    6、恢复默认值;
Expect      :
    1、显示默认值，1000 & 30min;
    2、参数设置成功;
    3、参数设置成功，校验参数生效;
    4、创建表成功，查询表记录，无对应执行语句信息记录;
    5、参数设置成功;
    6、恢复默认值成功;
"""

import os
import unittest

from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

logger = Logger()


class GucTestCase(unittest.TestCase):
    def setUp(self):
        logger.info(f'-----{os.path.basename(__file__)} start-----')
        self.constant = Constant()
        self.comsh = CommonSH('PrimaryDbUser')
        self.config_param1 = 'show track_stmt_session_slot;'
        self.config_param2 = 'show log_min_duration_statement;'
        status = self.comsh.get_db_cluster_status()
        self.assertTrue("Degraded" in status or "Normal" in status)
        self.tb_name = "tb_query_case0019"

    def test_guc(self):
        logger.info("======步骤一：查询track_stmt_session_slot默认为1000=====")
        show_cmd1 = self.comsh.execut_db_sql(self.config_param1)
        logger.info(show_cmd1)
        self.assertEqual('1000', show_cmd1.splitlines()[-2].strip())

        logger.info("======查询log_min_duration_statement默认为30min======")
        show_cmd2 = self.comsh.execut_db_sql(self.config_param2)
        logger.info(show_cmd2)
        self.assertEqual('30min', show_cmd2.splitlines()[-2].strip())

        logger.info("======步骤二：设置log_min_duration_statement为0======")
        set_cmd1 = self.comsh.execute_gsguc('reload',
                                            self.constant.GSGUC_SUCCESS_MSG,
                                            'log_min_duration_statement = 0')
        logger.info(set_cmd1)

        logger.info("======步骤三：使用alter system set方式修改为0======")
        set_cmd = f'''alter system set track_stmt_session_slot to 0;
            select pg_sleep(10);
            show track_stmt_session_slot;'''
        logger.info(set_cmd)
        set_res = self.comsh.execut_db_sql(set_cmd, dbname='postgres')
        logger.info(set_res)
        self.assertEqual('ALTER SYSTEM SET', set_res.splitlines()[0].strip())
        self.assertEqual('0', set_res.splitlines()[-2].strip())

        logger.info("======步骤四：创建表，查询statement_history表记录======")
        sql_cmd = f'''create table {self.tb_name}(a int,b int);
            drop table {self.tb_name} cascade;
            select * from statement_history where query like \
            '%{self.tb_name}%';'''
        logger.info(sql_cmd)
        sql_res = self.comsh.execut_db_sql(sql_cmd, dbname='postgres')
        logger.info(sql_res)
        self.assertIn('(0 rows)', sql_res)

        logger.info("======步骤五：设置track_stmt_session_slot为"
                    "2147483647======")
        set_cmd = f'''alter system set track_stmt_session_slot to 2147483647;
            select pg_sleep(10);
            show track_stmt_session_slot;'''
        logger.info(set_cmd)
        set_res = self.comsh.execut_db_sql(set_cmd, dbname='postgres')
        logger.info(set_res)
        self.assertEqual('ALTER SYSTEM SET', set_res.splitlines()[0].strip())
        self.assertEqual('2147483647', set_res.splitlines()[-2].strip())

    def tearDown(self):
        logger.info("======清理环境，恢复默认值======")
        cmd1 = self.comsh.execut_db_sql(self.config_param1)
        logger.info(cmd1)
        if '1000' != cmd1.splitlines()[-2].strip():
            self.comsh.execute_gsguc('set',
                                     self.constant.GSGUC_SUCCESS_MSG,
                                     'track_stmt_session_slot = 1000')

        cmd2 = self.comsh.execut_db_sql(self.config_param2)
        logger.info(cmd2)
        if '30min' != cmd2.splitlines()[-2].strip():
            self.comsh.execute_gsguc('set',
                                     self.constant.GSGUC_SUCCESS_MSG,
                                     'log_min_duration_statement = 30min')
        result = self.comsh.restart_db_cluster()
        logger.info(result)
        status = self.comsh.get_db_cluster_status()
        self.assertTrue("Degraded" in status or "Normal" in status)
        logger.info(f'-----{os.path.basename(__file__)} end-----')
