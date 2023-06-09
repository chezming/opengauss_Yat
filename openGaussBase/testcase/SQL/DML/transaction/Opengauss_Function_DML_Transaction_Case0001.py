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
Case Type   : 事务控制
Case Name   : 匿名块中直接执行DML是否成功
Description :
    1.新建测试表
    2.开启事务并执行只含有DML语句的匿名块后进行commit提交
    3.查看备机数据是否同步
Expect      :
    1.新建测试表成功
    2.执行只含有DML语句的匿名块成功
    3.查看备机数据同步成功
History     :
"""

import unittest
from yat.test import Node
from yat.test import macro
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Common import Common
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

logger = Logger()
primary_sh = CommonSH('PrimaryDbUser')


class TransactionFile(unittest.TestCase):
    def setUp(self):
        logger.info('----Opengauss_Function_DML_Transaction_Case0001开始执行----')
        self.PrimaryNode = Node('PrimaryDbUser')
        self.DB_ENV_PATH = macro.DB_ENV_PATH
        self.Constant = Constant()
        self.Common = Common()
        self.DB_INSTANCE_PATH = macro.DB_INSTANCE_PATH

    def test_transaction_file(self):
        logger.info('------若为单机环境，后续不执行，直接通过------')
        excute_cmd = f''' source {self.DB_ENV_PATH}
            gs_om -t status --detail'''
        logger.info(excute_cmd)
        msg = self.PrimaryNode.sh(excute_cmd).result()
        logger.info(msg)
        if 'Standby' not in msg:
            return '单机环境，后续不执行，直接通过'
        else:
            self.StandbyNode = Node('Standby1DbUser')
            logger.info('------新建测试表------')
            sql_cmd = '''drop table if exists testzl;
                create table testzl (SK INTEGER,ID CHAR(16),\
                NAME VARCHAR(20),SQ_FT INTEGER);'''
            excute_cmd = f'''source {self.DB_ENV_PATH} ;
                gsql -d {self.PrimaryNode.db_name} \
                -p {self.PrimaryNode.db_port} \
                -c "{sql_cmd}"'''
            logger.info(excute_cmd)
            msg = self.PrimaryNode.sh(excute_cmd).result()
            logger.info(msg)
            self.assertIn(self.Constant.TABLE_CREATE_SUCCESS, msg)

            logger.info('------开启事务并执行只含有DML语句的匿名块------')
            sql_cmd = f'''start transaction;
                        declare 
                        begin
                          insert into testzl values (008,'sk1','tt',3332);
                        end;
                        commit;'''
            excute_cmd = f'''source {self.DB_ENV_PATH} ;
                gsql -d {self.PrimaryNode.db_name} \
                -p {self.PrimaryNode.db_port} \
                -c "{sql_cmd}"'''
            logger.info(excute_cmd)
            msg = self.PrimaryNode.sh(excute_cmd).result()
            logger.info(msg)
            self.assertIn(self.Constant.COMMIT_SUCCESS_MSG, msg)

            logger.info('----等待备机完成数据同步----')
            node_num = self.Common.get_node_num(self.PrimaryNode)
            logger.info(node_num)
            consistency_flag = primary_sh.check_location_consistency('primary',
                                                                     node_num,
                                                                     300)
            self.assertTrue(consistency_flag)

            logger.info('------查看备机数据是否同步------')
            sql_cmd = f'''select count(*) from testzl;'''
            excute_cmd = f'''source {self.DB_ENV_PATH} ;
                gsql -d {self.StandbyNode.db_name} \
                -p {self.StandbyNode.db_port} \
                -c "{sql_cmd}"'''
            logger.info(excute_cmd)
            msg = self.StandbyNode.sh(excute_cmd).result()
            logger.info(msg)
            res = msg.splitlines()[-2].strip()
            self.assertIn('1', res)

    def tearDown(self):
        logger.info('------清理环境------')
        sql_cmd = 'drop table if exists testzl;'
        excute_cmd = f'''source {self.DB_ENV_PATH} ;
            gsql -d {self.PrimaryNode.db_name} \
            -p {self.PrimaryNode.db_port} \
            -c "{sql_cmd}"'''
        logger.info(excute_cmd)
        msg = self.PrimaryNode.sh(excute_cmd).result()
        logger.info(msg)
        self.assertIn(self.Constant.TABLE_DROP_SUCCESS, msg)
        logger.info('----Opengauss_Function_DML_Transaction_Case0001执行完成----')
