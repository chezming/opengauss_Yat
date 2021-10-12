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
--  @date:2020/8/14
--  @testpoint:opengauss关键字Exception(非保留)，作为视图名
'''

import unittest


from testcase.utils.Logger import Logger
from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH


logger = Logger()
commonsh = CommonSH('dbuser')
constant = Constant()

class Hostname(unittest.TestCase):


    def setUp(self):
         logger.info("------------------------ Opengauss_Function_Keyword_Exception_Case0033 开始执行--------------------------")

    # 关键字explain作为视图名，不带引号，创建成功
    def test_text_1(self):
        logger.info("------------------------关键字explain作为视图名，不带引号，创建成功--------------------------")
        SqlMdg = commonsh.execut_db_sql('''CREATE or replace VIEW public.Exception AS
                                        SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';
                                        drop view public.Exception;''')
        logger.info(SqlMdg)
        self.assertIn(constant.CREATE_VIEW_SUCCESS_MSG, SqlMdg)
        self.assertIn(constant.DROP_VIEW_SUCCESS_MSG, SqlMdg)

    # 关键字explain作为视图名，加双引号，创建成功
    def test_text_2(self):
        logger.info("------------------------关键字explain作为视图名，加双引号，创建成功--------------------------")
        SqlMdg = commonsh.execut_db_sql('''CREATE  or replace VIEW public."Exception" AS
                                        SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';
                                        drop VIEW public."Exception";''')
        logger.info(SqlMdg)
        self.assertIn(constant.CREATE_VIEW_SUCCESS_MSG, SqlMdg)
        self.assertIn(constant.DROP_VIEW_SUCCESS_MSG, SqlMdg)

    # 关键字explain作为视图名，加单引号，合理报错
    def test_text_3(self):
        logger.info("------------------------关键字explain作为视图名，加单引号，合理报错--------------------------")
        SqlMdg = commonsh.execut_db_sql('''CREATE or replace VIEW public.'Exception' AS
                                        SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';''')
        logger.info(SqlMdg)
        self.assertIn(constant.SYNTAX_ERROR_MSG, SqlMdg)

    #关键字explain作为视图名，加反引号，合理报错
    def test_text_4(self):
        logger.info("------------------------关键字explain作为视图名，加反引号，合理报错--------------------------")
        SqlMdg = commonsh.execut_db_sql('''CREATE or replace VIEW public.`Exception` AS
                                        SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';''')
        logger.info(SqlMdg)
        self.assertIn(constant.SYNTAX_ERROR_MSG, SqlMdg)

    def tearDown(self):
         logger.info('------------------------ Opengauss_Function_Keyword_Exception_Case0033 执行结束--------------------------')