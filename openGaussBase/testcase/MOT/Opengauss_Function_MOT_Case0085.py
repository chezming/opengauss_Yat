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
Case Type:  mot不支持的索引
Case Name:  MOT表不支持在总列宽>256的表上创建索引，数据类型为float8
key size explains: 1.键大小包括以字节为单位的列大小+列附加大小，其是维护索引所需的开销(详见表格不同类型对应的列附加大小);
                   2.如果索引不是唯一的，需要额外的8字节;
Modified At:  2020/10/13
'''

import unittest
import sys
sys.path.append(sys.path[0] + "/../")
from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Logger import Logger

logger = Logger()


class Mot_index_test(unittest.TestCase):

    def setUp(self):
        self.sh_primysh = CommonSH('PrimaryDbUser')
        self.constant = Constant()
        # logger.info('------------修改配置，并重启数据库------------')
        # self.configitem = "enable_incremental_checkpoint=off"
        # mod_msg = self.sh_primysh.execute_gsguc('set', self.constant.GSGUC_SUCCESS_MSG, self.configitem)
        # stopmsg = str(self.sh_primysh.stop_db_cluster())
        # startmsg = str(self.sh_primysh.start_db_cluster())
        # self.assertTrue(stopmsg)
        # self.assertTrue(startmsg)

    def test_mot_none_index(self):
        logger.info("------------------Opengauss_Function_MOT_Case0085开始执行------------------")
        self.schema = 'schema_mot_test'
        self.sql_cmd = f'''
                        DROP SCHEMA IF EXISTS {self.schema} CASCADE;
                        CREATE SCHEMA {self.schema};
                        --对列t1,t2,t4创建普通索引，float8类型8字节，附加大小为3，非唯一索引需额外的8字节
                        CREATE FOREIGN TABLE {self.schema}.mixindex1(t1 float8 not null,t2 float8 not null,t3 float8 not null,t4 varchar(223) not null);
                        --总列宽257
                        CREATE INDEX index1 ON {self.schema}.mixindex1(t1,t2,t4);
                        --对列t1,t3,t4创建唯一索引
                        CREATE FOREIGN TABLE {self.schema}.mixindex2(t1 float8 not null,t2 float8 not null,t3 float8 not null,t4 varchar(231) not null);
                        --总列宽257
                        CREATE UNIQUE INDEX index4 ON {self.schema}.mixindex2(t1,t3,t4);
                        DROP SCHEMA {self.schema} CASCADE;
                     '''
        logger.info("-------------------开始用例测试:mot不支持在总列宽>256的表上创建索引，数据类型为float8-------------------")
        msg = self.sh_primysh.execut_db_sql(self.sql_cmd)
        logger.info(msg)
        self.assertIn(self.constant.CREATE_FOREIGN_SUCCESS_MSG, msg)
        self.assertIn(self.constant.CREATE_INDEX_FAILED, msg)

    def tearDown(self):
        # logger.info('-----------恢复配置，并重启数据库-----------')
        # self.configitem = "enable_incremental_checkpoint=on"
        # mod_msg = self.sh_primysh.execute_gsguc('set', self.constant.GSGUC_SUCCESS_MSG, self.configitem)
        # stopmsg = str(self.sh_primysh.stop_db_cluster())
        # startmsg = str(self.sh_primysh.start_db_cluster())
        # self.assertTrue(stopmsg)
        # self.assertTrue(startmsg)
        logger.info('---------------Opengauss_Function_MOT_Case0085执行结束----------------')
