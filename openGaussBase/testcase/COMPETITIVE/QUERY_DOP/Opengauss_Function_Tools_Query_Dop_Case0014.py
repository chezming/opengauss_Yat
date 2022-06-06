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
Case Type   : Query_Dop并行查询
Case Name   : 创建范围分区表,设置query_dop=2,使用group的查询执行explain，查看是否启用并行查询
Description :
    1、创建范围分区表
    2、向分区表中插入数据
    3、设置query_dop参数值为2
    4、重启数据库集群使参数生效
    5、对分区表执行analyze操作
    6、使用explain查看分区表是否启用并行查询
    7、清理环境
Expect      :
    1、创建范围分区表
    2、插入数据成功
    3、设置query_dop参数值为2成功
    4、重启数据库集群成功
    5、对分区表执行analyze操作成功
    6、使用explain查看分区表，成功启用并行查询
    7、清理环境成功
History     :
"""

import unittest

from testcase.utils.CommonSH import CommonSH
from testcase.utils.Common import Common
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger


class QueryDopCase(unittest.TestCase):

    def setUp(self):
        self.logger = Logger()
        self.logger.info(
            "---Opengauss_Function_Tools_Query_Dop_Case0014开始执行---")
        self.constant = Constant()
        self.commonsh = CommonSH("PrimaryDbUser")
        self.common = Common()
        self.initial_query_dop = self.common.show_param("query_dop")
        self.t_name = "t_score_0014"

    def test_query_dop(self):
        step1_text = "---step1:创建范围分区表;expect:建表成功---"
        self.logger.info(step1_text)
        sql_cmd1 = f'''drop table if exists {self.t_name};
            create table {self.t_name}(
            col_id int,
            col_name char(30),
            col_score int,
            col_course char(30))
            partition by range (col_score)
            (partition t_score_0014_p1
            values less than (60),
            partition t_score_0014_p2
            values less than (80),
            partition t_score_0014_p3
            values less than (1000001));'''
        self.logger.info(sql_cmd1)
        sql_res1 = self.commonsh.execut_db_sql(sql_cmd1)
        self.logger.info(sql_res1)
        self.assertIn("CREATE TABLE", sql_res1, "执行失败" + step1_text)

        step2_text = "---step2:为范围分区表插入数据;expect:插入数据成功---"
        sql_cmd2 = f'''insert into {self.t_name} values(
            generate_series(1, 1000000), 
            'name',
            generate_series(1, 1000000),
            'course');'''
        self.logger.info(sql_cmd2)
        sql_res2 = self.commonsh.execut_db_sql(sql_cmd2)
        self.logger.info(sql_res2)
        self.assertIn("INSERT", sql_res2, "执行失败:" + step2_text)

        step3_text = "---step3:设置query_dop参数值为2;expect:设置成功---"
        self.logger.info(step3_text)
        guc_cmd = self.commonsh.execute_gsguc("set",
                                              self.constant.GSGUC_SUCCESS_MSG,
                                              "query_dop =2")
        self.logger.info(guc_cmd)
        self.assertTrue(guc_cmd, "执行失败:" + step3_text)

        step4_text = "---step4:重启数据库集群;expect:重启成功---"
        self.logger.info(step4_text)
        gs_cmd = self.commonsh.restart_db_cluster()
        self.logger.info(gs_cmd)
        self.logger.info("---检查数据库状态是否正常---")
        status = self.commonsh.get_db_cluster_status()
        self.assertTrue("Degraded" in status or "Normal" in status)

        step5_text = "---step5:对分区表执行analyze操作;expect:操作成功---"
        self.logger.info(step5_text)
        analyse_res = self.commonsh.execut_db_sql(f'analyze {self.t_name}')
        self.logger.info(analyse_res)
        self.assertIn("ANALYZE", analyse_res, "执行失败:" + step5_text)

        step6_text = "---step6:explain查看分区表是否启用并行查询;expect:并行查询启用成功---"
        self.logger.info(step6_text)
        explain_res = self.commonsh.execut_db_sql(
            f'explain select count(*) from {self.t_name} b group by b.col_id;')
        self.logger.info(explain_res)
        assert_info = "Streaming(type: LOCAL GATHER dop: 1/2)"
        self.assertIn(assert_info, explain_res, "执行失败:" + step6_text)

    def tearDown(self):
        self.logger.info("---清理环境---")

        drop_text = "---删除分区表---"
        self.logger.info(drop_text)
        drop_cmd = f'drop table if exists {self.t_name};'
        self.logger.info(drop_cmd)
        drop_res = self.commonsh.execut_db_sql(drop_cmd)
        self.logger.info(drop_res)

        reset_text = "---重置query_dop参数值---"
        self.logger.info(reset_text)
        re_cmd = self.commonsh.execute_gsguc("set",
                                             self.constant.GSGUC_SUCCESS_MSG,
                                             f"query_dop = "
                                             f"{self.initial_query_dop}")
        self.logger.info(re_cmd)

        restart_text = "---重启数据库集群---"
        self.logger.info(restart_text)
        restart_cmd = self.commonsh.restart_db_cluster()
        self.logger.info(restart_cmd)
        self.logger.info("---检查数据库状态是否正常---")
        status_res = self.commonsh.get_db_cluster_status()

        self.assertIn("DROP TABLE", drop_res, "执行失败" + drop_text)
        self.assertTrue(re_cmd, "执行失败:" + reset_text)
        self.assertTrue("Degraded" in status_res or "Normal" in status_res)
        self.logger.info(
            "---Opengauss_Function_Tools_Query_Dop_Case0014执行结束---")
