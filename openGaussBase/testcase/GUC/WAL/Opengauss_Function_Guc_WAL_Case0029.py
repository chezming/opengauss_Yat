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
Case Name   : 修改参数enable_incremental_checkpoint为其他数据类型及超边界值，并校验其预期结果。
Description :
    1、查看enable_incremental_checkpoint默认值 期望：on；
    show enable_incremental_checkpoint;
    2、修改enable_incremental_checkpoint为'test'、12321等，期望：合理报错
    gs_guc set -D {cluster/dn1} -c "enable_incremental_checkpoint=test";
    gs_guc set -D {cluster/dn1} -c "enable_incremental_checkpoint=12321";
    3、恢复默认值 无需恢复
Expect      :
    1、查看enable_incremental_checkpoint默认值 期望：on；
    2、修改enable_incremental_checkpoint为'test'、12321等，期望：合理报错
    3、恢复默认值 无需恢复
History     :
"""

import sys
import unittest
from yat.test import macro
from yat.test import Node
sys.path.append(sys.path[0] + "/../")
from testcase.utils.Logger import Logger
from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH

logger = Logger()
commonsh = CommonSH('PrimaryDbUser')

class Guctestcase(unittest.TestCase):
    def setUp(self):
        logger.info("------------------------Opengauss_Function_Guc_WAL_Case0029开始执行-----------------------------")
        self.userNode = Node('PrimaryDbUser')
        self.DB_ENV_PATH = macro.DB_ENV_PATH
        self.DB_INSTANCE_PATH = macro.DB_INSTANCE_PATH
        self.Constant = Constant()
        self.stopstartCmd = f'source {macro.DB_ENV_PATH};gs_om -t stop && gs_om -t start'
        self.statusCmd = f'source {macro.DB_ENV_PATH};gs_om -t status --detail'

    def test_guc_wal(self):
        logger.info("------------------------查询enable_incremental_checkpoint 期望：默认值on---------------------------")
        sql_cmd = commonsh.execut_db_sql(f'''show enable_incremental_checkpoint;''')
        logger.info(sql_cmd)
        self.value = sql_cmd.splitlines()[-2].strip()

        logger.info("-----------修改enable_incremental_checkpoint为'test'、12321等，期望：合理报错-------------")
        logger.info("-----------修改enable_incremental_checkpoint为'test'，期望：修改失败，show参数为默认值-------------")
        sql_cmd = f'''source {self.DB_ENV_PATH};gs_guc reload -D {self.DB_INSTANCE_PATH} -c "enable_incremental_checkpoint='test'"'''
        logger.info(sql_cmd)
        msg = self.userNode.sh(sql_cmd).result()
        logger.info(msg)
        self.assertIn(self.Constant.SQL_WRONG_MSG[1], msg)
        sql_cmd = commonsh.execut_db_sql(f'''show enable_incremental_checkpoint;''')
        logger.info(sql_cmd)
        self.assertIn(self.Constant.OPEN_STATUS_MSG[0], sql_cmd)

        logger.info("-----------修改enable_incremental_checkpoint为12321，期望：修改失败-------------")
        sql_cmd = f'''source {self.DB_ENV_PATH};gs_guc reload -D {self.DB_INSTANCE_PATH} -c "enable_incremental_checkpoint=12321"'''
        logger.info(sql_cmd)
        msg = self.userNode.sh(sql_cmd).result()
        logger.info(msg)
        self.assertIn(self.Constant.SQL_WRONG_MSG[1], msg)
        sql_cmd = commonsh.execut_db_sql(f'''show enable_incremental_checkpoint;''')
        logger.info(sql_cmd)
        self.assertIn(self.Constant.OPEN_STATUS_MSG[0], sql_cmd)

    def tearDown(self):
        logger.info("--------------------------------恢复默认值-----------------------------------")
        commonsh.execute_gsguc('set', 
                               self.Constant.GSGUC_SUCCESS_MSG, 
                               f'enable_incremental_checkpoint={self.value}')
        commonsh.restart_db_cluster()
        is_started = commonsh.get_db_cluster_status()
        self.assertTrue("Degraded" in is_started or "Normal" in is_started)
        logger.info("-------------------------Opengauss_Function_Guc_WAL_Case0029执行结束---------------------------")