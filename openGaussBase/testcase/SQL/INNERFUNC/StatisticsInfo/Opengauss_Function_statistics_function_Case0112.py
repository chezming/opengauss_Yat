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
Case Type   : 统计信息函数
Case Name   : pg_stat_get_stream_replications()描述：查询主备复制状态
Description : 1.查询主备复制状态
Expect      : 1.查询主备复制状态成功
History     : 
"""

import unittest
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Logger import Logger


class Tools(unittest.TestCase):
    def setUp(self):
        self.log = Logger()
        self.log.info('Opengauss_Function_statistics_function_Case0112开始')
        self.commonsh = CommonSH()

    def test_built_in_func(self):
        text = '-----步骤1.查询主备复制状态----'
        self.log.info(text)
        sql_cmd = self.commonsh.execut_db_sql(
            f'select pg_stat_get_stream_replications();')
        self.log.info(sql_cmd)
        str_info = sql_cmd.split('\n')[-2]
        self.log.info(str_info)
        num = len(str_info.split(','))
        self.log.info(f'num = {num}')
        if num == 4:
            self.log.info('查询主备复制状态成功')
        else:
            raise Exception('函数执行异常，请检查')

    def tearDown(self):
        self.log.info('Opengauss_Function_statistics_function_Case0112结束')
