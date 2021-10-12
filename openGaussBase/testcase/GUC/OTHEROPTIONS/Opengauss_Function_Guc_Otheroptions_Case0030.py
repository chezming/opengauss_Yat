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
Case Name   : 修改ngram_grapsymbol_ignore为on，观察预期结果；
Description :
    1、创建UTF8格式数据库，查询ngram_grapsymbol_ignore默认值，查询带有图形化字符的解析;
    2、gs_guc set方式修改ngram_grapsymbol_ignore为on;
    3、查看带有图形化字符的解析;
    4、恢复默认值；
Expect      :
    1、创建UTF8格式数据库成功，显示默认值off，可以解析出图形化字符；
    2、参数修改成功；
    3、图形化字符未被解析出;
    4、恢复默认值成功；
History     :
"""

import unittest
from yat.test import Node
from yat.test import macro
from testcase.utils.Logger import Logger
from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH

logger = Logger()


class GucTestCase(unittest.TestCase):
    def setUp(self):
        logger.info("===Opengauss_Function_Guc_Otheroptions_Case0030开始执行===")
        self.constant = Constant()
        self.commonsh = CommonSH('PrimaryDbUser')
        self.user_node = Node('PrimaryDbUser')
        status = self.commonsh.get_db_cluster_status()
        self.assertTrue("Degraded" in status or "Normal" in status)

    def test_guc(self):
        logger.info("创建UTF8格式数据库，查询ngram_grapsymbol_ignore默认值，查询带有图形化字符的解析")
        sql_cmd1 = f'''drop database if exists ngram_test;
            create database ngram_test encoding='UTF8';'''
        sql_cmd2 = f'''show ngram_grapsymbol_ignore;
            select token from ts_debug('ngram','as$%&df');'''
        res1 = self.commonsh.execut_db_sql(sql_cmd1)
        logger.info(res1)
        self.assertIn(self.constant.CREATE_DATABASE_SUCCESS, res1)

        con_cmd = f'''source {macro.DB_ENV_PATH}
            gsql -d ngram_test -p {self.user_node.db_port} -c "{sql_cmd2}"'''
        res2 = self.user_node.sh(con_cmd).result()
        self.assertEqual('off', res2.split('\n')[2].strip())
        self.assertTrue('$' in res2 and '%' in res2 and '&' in res2)

        logger.info("======修改ngram_grapsymbol_ignore为on，重启期望：设置成功======")
        result = self.commonsh.execute_gsguc('set',
                                             self.constant.GSGUC_SUCCESS_MSG,
                                            'ngram_grapsymbol_ignore = on')
        self.assertTrue(result)
        self.commonsh.restart_db_cluster()
        result = self.commonsh.get_db_cluster_status()
        self.assertTrue("Degraded" in result or "Normal" in result)

        logger.info("======查询结果为修改值on，查看带有图形化字符的解析======")
        sql_cmd3 = f'''show ngram_grapsymbol_ignore;
            select token from ts_debug('ngram','as$%&df');'''
        con_cmd = f'''source {macro.DB_ENV_PATH}
            gsql -d ngram_test -p {self.user_node.db_port} -c "{sql_cmd3}"'''
        logger.info(sql_cmd3)
        res3 = self.user_node.sh(con_cmd).result()
        self.assertEqual('on', res3.split('\n')[2].strip())
        self.assertTrue('$' not in res3 and
                        '%' not in res3 and
                        '&' not in res3)

        logger.info("======删除数据库======")
        result_set = self.commonsh.execut_db_sql('''drop database ngram_test''')
        self.assertIn(self.constant.DROP_DATABASE_SUCCESS, result_set)

    def tearDown(self):
        logger.info("======清理环境，恢复配置======")
        rec = self.commonsh.execut_db_sql('''show ngram_grapsymbol_ignore; ''')
        logger.info(rec)
        if "off" not in rec.split('\n')[-2].strip():
            self.commonsh.execute_gsguc('set',
                                        self.constant.GSGUC_SUCCESS_MSG,
                                       "ngram_grapsymbol_ignore = off")
        result = self.commonsh.restart_db_cluster()
        logger.info(result)
        status = self.commonsh.get_db_cluster_status()
        self.assertTrue("Degraded" in status or "Normal" in status)
        logger.info("===Opengauss_Function_Guc_Otheroptions_Case0030执行结束===")
