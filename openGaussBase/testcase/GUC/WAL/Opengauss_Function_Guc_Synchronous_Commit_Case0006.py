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
Case Name   : 系统管理员使用alter database命令设置synchronous_commit参数值为2
Description :
        1.查询synchronous_commit默认值
        2.创建用户和数据库
        3.系统管理员使用alter database命令修改参数为2
        4.重新连接数据库，查看参数值
        5.恢复参数默认值
        6.删除用户和数据库
Expect      :
        1.单机环境显示默认值为off，双机为on
        2.创建成功
        3.修改成功,未退出会话，查看参数值，未生效
        4.显示remote_apply
        5.恢复成功
        6.删除成功
History     :
"""
import sys
import unittest
sys.path.append(sys.path[0]+"/../")
from yat.test import macro
from yat.test import Node
from testcase.utils.Logger import Logger
from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH


logger = Logger()
commonsh = CommonSH('PrimaryDbUser')
constant = Constant()

class GUC_SC(unittest.TestCase):
    def setUp(self):
        logger.info('------------------------Opengauss_Function_Guc_Synchronous_Commit_Case0006开始执行-----------------------------')
        self.userNode = Node('PrimaryDbUser')
        self.DB_ENV_PATH = macro.DB_ENV_PATH
        self.DB_INSTANCE_PATH = macro.DB_INSTANCE_PATH
        self.sh_primy = CommonSH('PrimaryDbUser')
        self.Constant = Constant()

    def test_synchronous_commit(self):
        # 查看参数默认值(off)且创建系统管理员和数据库
        sql_cmd1 = commonsh.execut_db_sql(f'''show synchronous_commit;
                                       drop user if exists test1_sys006 cascade;
                                       create user test1_sys006 with sysadmin password '{macro.COMMON_PASSWD}';
                                       drop database if exists testdb_006;
                                       create database testdb_006;''')
        logger.info(sql_cmd1)
        flag = (constant.SYNCHRONOUS_COMMIT_DEFAULT[0] in sql_cmd1 or constant.SYNCHRONOUS_COMMIT_DEFAULT[1] in sql_cmd1)
        self.assertTrue(flag)
        self.assertIn(constant.CREATE_ROLE_SUCCESS_MSG, sql_cmd1)
        self.assertIn(constant.CREATE_DATABASE_SUCCESS, sql_cmd1)
        # 系统管理员使用alter database命令修改参数为2;修改成功,未退出会话，查看参数值，未生效
        sql_cmd2 = ('''alter database testdb_006 set synchronous_commit to 2;
        show synchronous_commit;''')
        excute_cmd1 = f'''
                            source {self.DB_ENV_PATH};
                            gsql -d testdb_006 -p {self.userNode.db_port} -U test1_sys006 -W '{macro.COMMON_PASSWD}' -c "{sql_cmd2}"
                            '''
        logger.info(excute_cmd1)
        msg1 = self.userNode.sh(excute_cmd1).result()
        logger.info(msg1)
        self.assertIn(constant.ALTER_DATABASE_SUCCESS_MSG, msg1)
        flag = (constant.SYNCHRONOUS_COMMIT_DEFAULT[0] in msg1 or constant.SYNCHRONOUS_COMMIT_DEFAULT[1] in msg1)
        self.assertTrue(flag)
      # 重新连接数据库，查看参数值，参数值生效，为remote_apply
        sql_cmd4 = (''' show synchronous_commit;''')
        excute_cmd1 = f'''
                                   source {self.DB_ENV_PATH};
                                   gsql -d testdb_006 -p {self.userNode.db_port} -c "{sql_cmd4}"
                                   '''
        logger.info(excute_cmd1)
        msg1 = self.userNode.sh(excute_cmd1).result()
        logger.info(msg1)
        self.assertIn('remote_apply',msg1)

    # 清理环境
    def tearDown(self):
        logger.info('----------this is teardown-------')
        # 恢复参数为默认值
        sql_cmd5 = commonsh.execut_db_sql('''ALTER DATABASE testdb_006 RESET synchronous_commit;''')
        logger.info(sql_cmd5)
        # 删除用户
        sql_cmd6 = commonsh.execut_db_sql('''drop user test1_sys006 cascade;
                                           drop database if exists testdb_006; ''')
        logger.info(sql_cmd6)
        logger.info('------------------------Opengauss_Function_Guc_Synchronous_Commit_Case0006执行结束--------------------------')
