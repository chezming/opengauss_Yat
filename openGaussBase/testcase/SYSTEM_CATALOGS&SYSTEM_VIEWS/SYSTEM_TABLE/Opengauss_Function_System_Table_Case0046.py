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
Case Type   : 系统表
Case Name   : 测试系统表PG_PARTITION字段与数据类型
Description :
    1.查看系统表PG_PARTITION的表结构
    2.该表字段与对应字段数据类型是否正确
Expect      :
    1.查看系统表PG_PARTITION的表结构成功
    2.该表字段与字段数据类型对应正确
History     :
"""

import sys
import unittest

from yat.test import Node
from yat.test import macro

sys.path.append(sys.path[0] + "/../")
from testcase.utils.Logger import Logger
from testcase.utils.Common import Common
from testcase.utils.CommonSH import CommonSH


class IndexFileDamaged(unittest.TestCase):
    def setUp(self):
        self.log = Logger()
        self.log.info(
            '-------Opengauss_Function_System_Table_Case0046开始执行--------')
        self.userNode = Node('dbuser')
        self.DB_ENV_PATH = macro.DB_ENV_PATH
        self.com = Common()
        self.comsh = CommonSH('dbuser')
        self.expect_result_dict = {
            'Column': ['relname', 'parttype', 'parentid', 'rangenum',
                       'intervalnum', 'partstrategy', 'relfilenode',
                       'reltablespace', 'relpages', 'reltuples',
                       'relallvisible', 'reltoastrelid', 'reltoastidxid',
                       'indextblid', 'indisusable', 'reldeltarelid',
                       'reldeltaidx', 'relcudescrelid', 'relcudescidx',
                       'relfrozenxid', 'intspnum', 'partkey',
                       'intervaltablespace', 'interval', 'boundaries',
                       'transit', 'reloptions', 'relfrozenxid64',
                       'relminmxid'],
            'Type': ['name', '"char"', 'oid', 'integer', 'integer', '"char"',
                     'oid', 'oid', 'double precision',
                     'double precision', 'integer', 'oid', 'oid', 'oid',
                     'boolean', 'oid', 'oid', 'oid', 'oid', 'xid32',
                     'integer', 'int2vector', 'oidvector', 'text[]', 'text[]',
                     'text[]', 'text[]', 'xid', 'xid']}

    def test_Index_file_damaged(self):
        text = '------step1:查看系统表PG_PARTITION的表结构;' \
               'expect:PG_PARTITION的表结构正常显示------'
        self.log.info(text)
        msg = self.comsh.execut_db_sql('\d PG_PARTITION')
        self.log.info(msg)
        text = '-------step2:表字段与对应字段数据类型是否正确;expect:对应正确-------'
        self.log.info(text)
        result_dict = self.com.format_sql_result(msg)
        self.log.info(result_dict)
        del result_dict['Modifiers']
        self.assertDictEqual(self.expect_result_dict, result_dict,
                             '执行失败:' + text)

    def tearDown(self):
        self.log.info('-------------无须清理环境---------------')
        self.log.info('----Opengauss_Function_System_Table_Case0046执行完成----')
