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
Case Type   : 防篡改
Case Name   : 验证口令最长有效期
Description :
    1.查询参数
    2.设置口令有效期为10s
    3.创建用户后强制等待15秒
    4.以普通用户登录数据库并执行创建表语句
    5.清理环境
Expect      :
    1.显示默认值90
    2.成功
    3.成功
    4.表创建成功但在登录数据库时会提示密码过期
    5.成功
History     : 
"""



import os
import unittest
from yat.test import Node
from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Common import Common
from testcase.utils.Logger import Logger
from yat.test import macro


class ModifyCase(unittest.TestCase):
    def setUp(self):
        self.logger = Logger()
        self.logger.info(f'-----{os.path.basename(__file__)} start-----')
        self.dbuserNode = Node('PrimaryDbUser')
        self.primary_sh = CommonSH('PrimaryDbUser')
        self.Constant = Constant()
        self.common = Common()
        self.user_name = 'u_security_mgt_manamegent_0004'
        self.table_name = 't_security_mgt_manamegent_0004'
        self.default_value = self.common.show_param('password_effect_time')

    def test_security(self):
        text = '----step1:查询参数password_effect_time值; expect:默认值90----'
        self.logger.info(text)
        show_para = self.default_value
        self.logger.info(show_para)
        self.assertTrue('90' in show_para, "执行失败:" + text)

        text = '----step2:设置password_effect_time有效期10s;  expect:成功----'
        self.logger.info(text)
        sql_cmd = self.primary_sh.execut_db_sql(f'''
            alter system set password_effect_time to 0.00011;
            select pg_sleep(4);
            show password_effect_time;''')
        self.logger.info(sql_cmd)
        self.assertEqual("0.00011", sql_cmd.split("\n")[-2].strip(),
                         "执行失败:" + text)

        text = '----step3:创建用户后强制等待15秒 expect:成功----'
        self.logger.info(text)
        sql_cmd = self.primary_sh.execut_db_sql(f'''
            create user {self.user_name}  password '{macro.PASSWD_REPLACE}';
            select pg_sleep(15);''')
        self.logger.info(sql_cmd)
        self.assertTrue(
            sql_cmd.count(self.Constant.CREATE_ROLE_SUCCESS_MSG) == 1,
            "执行失败:" + text)

        text = '----step4:普通用户登录并执行创建表语句 ' \
               'expect:表创建成功但在登录数据库时会提示密码过期----'
        self.logger.info(text)
        connect_sql = f'gsql -d {self.dbuserNode.db_name} ' \
            f'-p {self.dbuserNode.db_port} -U {self.user_name} ' \
            f'-W {macro.PASSWD_REPLACE}'
        sql_cmd = f'''create table {self.table_name}
            (id char(4),name varchar(10));'''
        execute_cmd = f'''source {macro.DB_ENV_PATH}
              expect <<EOF
              set timeout 10
              spawn {connect_sql}
              expect "{self.dbuserNode.db_name}=#"
              send "{sql_cmd}\\n"
              expect eof\n''' + '''EOF'''
        self.logger.info(execute_cmd)
        msg = self.dbuserNode.sh(execute_cmd).result()
        self.logger.info(msg)
        self.assertIn(self.Constant.TABLE_CREATE_SUCCESS and
                      'The password has been expired, '
                      'please change the password', msg, '执行失败:' + text)

    def tearDown(self):
        text = '----step5:清理环境 expect:成功----'
        self.logger.info(text)
        self.logger.info('删除用户')
        sql_cmd1 = self.primary_sh.execut_db_sql(f'''
            drop user {self.user_name} cascade;''')
        self.logger.info(sql_cmd1)
        self.logger.info('恢复默认值')
        sql_cmd2 = self.primary_sh.execut_db_sql(f'''
            alter system set password_effect_time to {self.default_value};
            select pg_sleep(4);
            show password_effect_time;''')
        self.logger.info(sql_cmd2)
        self.assertEqual("90", sql_cmd2.split("\n")[-2].strip(),
                         "执行失败:" + text)
        self.assertIn(self.Constant.DROP_ROLE_SUCCESS_MSG, sql_cmd1,
                      '执行失败:' + text)
        self.logger.info(f'-----{os.path.basename(__file__)} end-----')
