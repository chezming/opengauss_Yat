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
Case Type   : analyze--System catalog
Case Name   : analyze收集系统表的多列统计信息，合理报错
Description :
    1.收集系统表PG_PROC多列信息
    2.收集系统表pg_authid多列信息
Expect      :
    1.合理报错
    2.合理报错
History     :
"""
import sys
import unittest

sys.path.append(sys.path[0] + "/../")
from testcase.utils.Logger import Logger
from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH

logger = Logger()
commonsh = CommonSH('dbuser')
constant = Constant()


class SYSOPERATION(unittest.TestCase):
    def setUp(self):
        logger.info('------------------------Opengauss_Function_DML_Set_Case0100开始执行-----------------------------')

    def test_analyze(self):
        sql_cmd1 = commonsh.execut_db_sql('''analyze PG_PROC((proname,proowner,prokind,proretset,proargnames,provariadic));
        analyze verbose pg_authid((rolname,rolsuper,rolinherit,rolsystemadmin));''')
        logger.info(sql_cmd1)
        self.assertIn('ERROR:  System catalog is not supported by extended statistic', sql_cmd1)

    # 清理环境:no need to clean
    def tearDown(self):
        logger.info('----------this is teardown-------')
        logger.info('------------------------Opengauss_Function_DML_Set_Case0100执行结束--------------------------')
