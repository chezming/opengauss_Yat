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
#--  @date:2020/9/17
#--  @testpoint:修改词典所有者，语法测试
'''

import unittest
from yat.test import macro
from testcase.utils.Logger import Logger
from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH


logger = Logger()
commonsh = CommonSH('dbuser')
constant = Constant()

class Hostname(unittest.TestCase):

    def setUp(self):
        logger.info("------------------------Opengauss_BaseFunc_Full_Text_Search_dictionary_0047开始执行--------------------------")

    # 创建词典,词典定义文件全名为thesaurus_sample.ths, FILEPATH使用本地目录（/Datadir/cluster/app/share/postgresql/tsearch_data）
    def test_directoary_1(self):
        file_path = macro.DB_DictFile
        SqlMdg = commonsh.execut_db_sql('''drop TEXT SEARCH DICTIONARY if exists thesaurus_astro cascade;''')
        logger.info(SqlMdg)
        self.assertIn(constant.DROP_DICTIONARY_SUCCESS_MSG, SqlMdg)

        SqlMdg = commonsh.execut_db_sql(f'''CREATE TEXT SEARCH DICTIONARY thesaurus_astro (
                                 TEMPLATE = thesaurus,
                                 DictFile = thesaurus_sample,
                                 Dictionary = pg_catalog.english_stem,
                                 FILEPATH = 'file:{file_path}');''')
        logger.info(SqlMdg)
        self.assertIn(constant.CREATE_DICTIONARY_SUCCESS_MSG, SqlMdg)
        # 查看词典所有者
        SqlMdg = commonsh.execut_db_sql('''select dictname,dictowner,dictinitoption from PG_TS_DICT where dictname='thesaurus_astro';''')
        logger.info(SqlMdg)
        self.assertIn('thesaurus_astro', SqlMdg)
       # 创建用户user1
        SqlMdg = commonsh.execut_db_sql(f'''drop user if exists user1 cascade;
                                     create user user1 password '{macro.COMMON_PASSWD}';''')
        logger.info(SqlMdg)
        self.assertIn('CREATE ROLE', SqlMdg)

       # 修改词典所有者为user1
        SqlMdg = commonsh.execut_db_sql('''ALTER TEXT SEARCH DICTIONARY thesaurus_astro owner to user1; ''')
        logger.info(SqlMdg)
        self.assertIn('ALTER TEXT SEARCH DICTIONARY', SqlMdg)
    # 清理环境
    def tearDown(self):
        logger.info('----------this is teardown-------')
        # 删除词典
        SqlMdg = commonsh.execut_db_sql('''drop TEXT SEARCH DICTIONARY thesaurus_astro cascade;''')
        logger.info(SqlMdg)
        self.assertIn(constant.DROP_DICTIONARY_SUCCESS_MSG, SqlMdg)

        # 删除用户
        SqlMdg = commonsh.execut_db_sql('''drop user user1 cascade;''')
        logger.info(SqlMdg)
        self.assertIn('DROP ROLE', SqlMdg)
        logger.info('------------------------Opengauss_BaseFunc_Full_Text_Search_dictionary_0047执行结束--------------------------')
