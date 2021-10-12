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
Case Type   : security_masking
Case Name   : 使用randommasking脱密策略，对信用卡格式的数据类型进行脱敏
Description :
    1.poladmin用户创建表，并赋予表的所有操作权限给用户1
    2.poladmin用户将敏感字段加到资源标签
    3.poladmin用户设置脱敏策略randommasking,过滤用户1
    4.用户1查看数据是否脱敏
Expect      :
    1.创表成功，赋权成功
    2.资源标签创建成功：CREATE RESOURCE LABEL
    3.脱敏策略设置失败成功
    4.查看到string字段的文本内容均脱敏处理，原来的文本按字符随机脱敏
History     :
"""
import unittest
from yat.test import Node
from yat.test import macro
from testcase.utils.Common import Common
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

logger = Logger()


class Security(unittest.TestCase):
    def setUp(self):
        text = '---Opengauss_Function_Security_Masking_Case0046 start---'
        logger.info(text)
        self.userNode = Node('PrimaryDbUser')
        self.sh_primy = CommonSH('PrimaryDbUser')
        self.common = Common()
        self.constant = Constant()
        self.poladmin = 'poladmin_security_masking_0046'
        self.com_user = 'com_security_masking_0046'
        self.resource_label = 'rl_security_masking_0046'
        self.masking_policy = 'mp_security_masking_0046'
        self.table = f'{self.poladmin}.table_security_masking_0046'
    
    def test_masking(self):
        text = '---step1：poladmin用户创建表，并赋予表的所有操作权限给普通用户1 ' \
               'expect:创建表成功，权限赋予成功-------'
        logger.info(text)
        sql_cmd1 = f'drop user if exists {self.com_user};' \
            f'drop user if exists {self.poladmin};' \
            f'create user {self.poladmin} with POLADMIN password \'' \
            f'{macro.COMMON_PASSWD}\';' \
            f'create user {self.com_user} with password \'' \
            f'{macro.COMMON_PASSWD}\';' \
            f'grant all privileges to {self.com_user};'
        msg1 = self.sh_primy.execut_db_sql(sql_cmd1)
        logger.info(msg1)
        excute_cmd2 = f'source {macro.DB_ENV_PATH};' \
            f'gs_guc reload -D {macro.DB_INSTANCE_PATH} -c ' \
            f'"enable_security_policy=on"'
        msg2 = self.userNode.sh(excute_cmd2).result()
        logger.info(msg2)
        assert_1 = self.constant.CREATE_ROLE_SUCCESS_MSG in msg1
        assert_2 = self.constant.ALTER_ROLE_SUCCESS_MSG in msg1
        sql_cmd3 = f'show enable_security_policy;'
        msg3 = self.sh_primy.execut_db_sql(sql_cmd3)
        logger.info(msg3)
        self.common.equal_sql_mdg(msg3, 'enable_security_policy', 'on',
                                  '(1 row)', flag='1')
        self.assertTrue(assert_1 and assert_2, '执行失败:' + text)
        sql_cmd4 = f'''drop table if exists {self.table};
                create table {self.table}(id int,name char(10),string
                varchar(25),address varchar(60));
                insert into {self.table} values(1,'张三','6256-0056-7000-1452',
                'Shanxi,Xian,yuhuazhai'),(2,'李四','6523-0044-7252-1569-652',
                'Fujian');'''
        excute_cmd4 = f'source {macro.DB_ENV_PATH};' \
            f'gsql -d {self.userNode.db_name} -p ' \
            f'{self.userNode.db_port} -c "{sql_cmd4}"'
        logger.info(excute_cmd4)
        msg4 = self.userNode.sh(excute_cmd4).result()
        logger.info(msg4)
        assert_1 = self.constant.CREATE_TABLE_SUCCESS in msg4
        assert_2 = self.constant.INSERT_SUCCESS_MSG in msg4
        self.assertTrue(assert_1 and assert_2, '执行失败:' + text)
        text = '---step2：poladmin用户将敏感字段加到资源标签,设置脱敏策略' \
               'randommasking,过滤用户1 expect:添加成功，脱敏策略设置成功---'
        logger.info(text)
        sql_cmd5 = f'drop resource label if exists {self.resource_label};' \
            f'create resource label {self.resource_label} add column(' \
            f'{self.table}.string);' \
            f'drop masking policy if exists {self.masking_policy};' \
            f'create masking policy {self.masking_policy} ' \
            f'randommasking on label({self.resource_label}) ' \
            f'filter on roles({self.com_user});'
        excute_cmd5 = f'source {macro.DB_ENV_PATH};' \
            f'gsql -d {self.userNode.db_name} -p ' \
            f'{self.userNode.db_port} -U {self.poladmin} -W ' \
            f'{macro.COMMON_PASSWD} -c "{sql_cmd5}"'
        logger.info(excute_cmd5)
        msg5 = self.userNode.sh(excute_cmd5).result()
        logger.info(msg5)
        assert_1 = self.constant.resource_label_create_success_msg in msg5
        assert_2 = self.constant.masking_policy_create_success_msg in msg5
        self.assertTrue(assert_1 and assert_2, '执行失败:' + text)
        text = '---step3：登录用户1查看表的string字段脱敏 expect:脱敏成功---'
        logger.info(text)
        sql_cmd6 = f'select string from {self.table};'
        excute_cmd6 = f'source {macro.DB_ENV_PATH};' \
            f'gsql -d {self.userNode.db_name} -p ' \
            f'{self.userNode.db_port} -U {self.com_user} -W \'' \
            f'{macro.COMMON_PASSWD}\' -c "{sql_cmd6}"'
        logger.info(excute_cmd6)
        msg6 = self.userNode.sh(excute_cmd6).result()
        logger.info(msg6)
        msg6_list = msg6.splitlines()
        assert_1 = (msg6_list[2].strip() != '6254-2532-7400-1432-965' and
                    msg6_list[3].strip() != '6212-2544-7000-1432-965')
        self.assertTrue(assert_1, '执行失败:' + text)
    
    def tearDown(self):
        logger.info('-------清理资源------')
        sql_cmd1 = f'drop masking policy if exists {self.masking_policy};' \
            f'drop resource label if exists {self.resource_label};' \
            f'drop table if exists {self.table};'
        excute_cmd1 = f'source {macro.DB_ENV_PATH};' \
            f'gsql -d {self.userNode.db_name} -p ' \
            f'{self.userNode.db_port} -c "{sql_cmd1}"'
        msg1 = self.userNode.sh(excute_cmd1).result()
        logger.info(msg1)
        excute_cmd2 = f'source {macro.DB_ENV_PATH};' \
            f'gs_guc reload -D {macro.DB_INSTANCE_PATH} -c ' \
            f'"enable_security_policy=off"'
        msg2 = self.userNode.sh(excute_cmd2).result()
        logger.info(msg2)
        sql_cmd3 = f'show enable_security_policy;'
        msg3 = self.sh_primy.execut_db_sql(sql_cmd3)
        logger.info(msg3)
        sql_cmd4 = f'drop user {self.poladmin};' \
            f'drop user {self.com_user};'
        msg4 = self.sh_primy.execut_db_sql(sql_cmd4)
        logger.info(msg4)
        logger.info(
            '---Opengauss_Function_Security_Masking_Case0046 finish---')
