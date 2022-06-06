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
Case Name   : 修改参数max_redo_log_size为其他数据类型及超边界值，并校验其预期结果。
Description :
    1、查看max_redo_log_size默认值 期望：1GB；
    show max_redo_log_size;
    2、修改max_redo_log_size为test,'test'、9999999999等，期望：合理报错
    gs_guc set -D {cluster/dn1} -c "max_redo_log_size=test";
    gs_guc set -D {cluster/dn1} -c "max_redo_log_size='test'";
    gs_guc set -D {cluster/dn1} -c "max_redo_log_size=9999999999";
    3、恢复默认值 无需恢复
Expect      :
    1、查看max_redo_log_size默认值 期望：1GB；
    2、修改max_redo_log_size为test,'test'、9999999999等，期望：合理报错
    3、恢复默认值 无需恢复
History     :
"""

import sys
import unittest
sys.path.append(sys.path[0] + "/../")
from testcase.utils.Logger import Logger
from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH

logger = Logger()
commonsh = CommonSH('PrimaryDbUser')

class Guctestcase(unittest.TestCase):
    def setUp(self):
        logger.info("------------------------Opengauss_Function_Guc_WAL_Case0059开始执行-----------------------------")
        self.Constant = Constant()

    def test_guc_wal(self):
        logger.info("------------------------查询max_redo_log_size 期望：默认值1GB---------------------------")
        sql_cmd = commonsh.execut_db_sql(f'''show max_redo_log_size;''')
        logger.info(sql_cmd)
        self.assertIn("1GB", sql_cmd)

        logger.info("-----------修改max_redo_log_size为test,'test'、9999999999等，期望：合理报错-------------")
        logger.info("-----------修改max_redo_log_size为test，期望：修改失败，show参数为默认值-------------")
        result = commonsh.execute_gsguc('set', self.Constant.GSGUC_SUCCESS_MSG, "max_redo_log_size=test")
        self.assertFalse(result)
        sql_cmd = commonsh.execut_db_sql(f'''show max_redo_log_size;''')
        logger.info(sql_cmd)
        self.assertIn("1GB", sql_cmd)

        logger.info("-----------修改max_redo_log_size为'test'，期望：修改失败，show参数为默认值-------------")
        result = commonsh.execute_gsguc('set', self.Constant.GSGUC_SUCCESS_MSG, "max_redo_log_size='test'")
        self.assertFalse(result)
        sql_cmd = commonsh.execut_db_sql(f'''show max_redo_log_size;''')
        logger.info(sql_cmd)
        self.assertIn("1GB", sql_cmd)

        logger.info("-----------修改max_redo_log_size为9999999999，期望：修改失败-------------")
        result = commonsh.execute_gsguc('set', self.Constant.GSGUC_SUCCESS_MSG, 'max_redo_log_size=9999999999')
        self.assertFalse(result)
        sql_cmd = commonsh.execut_db_sql(f'''show max_redo_log_size;''')
        logger.info(sql_cmd)
        self.assertIn("1GB", sql_cmd)

    def tearDown(self):
        logger.info("--------------------------------恢复默认值-----------------------------------")
        logger.info("恢复默认值")
        sql_cmd = commonsh.execut_db_sql(f'''show max_redo_log_size;''')
        if "1GB" not in sql_cmd:
            commonsh.execute_gsguc('set', self.Constant.GSGUC_SUCCESS_MSG, 'max_redo_log_size=1GB')
            commonsh.restart_db_cluster()
            is_started = commonsh.get_db_cluster_status()
            self.assertTrue("Degraded" in is_started or "Normal" in is_started)
        logger.info("-------------------------Opengauss_Function_Guc_WAL_Case0059执行结束---------------------------")