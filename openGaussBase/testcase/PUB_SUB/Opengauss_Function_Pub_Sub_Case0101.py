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
Case Type   : 基础功能
Case Name   : 创建新订阅，订阅端参数slot_name验证
Description :
    1、创建用户，赋予所有权限
    2、在两个集群中创建相同字段表
    3、创建发布端(集群A)
    4、创建订阅，其他配置信息正常，发布名称存在，子句指定订阅参数slot_name，验证默认值（集群B）
    4.1:创建订阅   expect:创建订阅成功
    4.2:查看复制槽名称   expect:复制槽名称为订阅名
    4.3:向发布端表中插入数据   expect:成功
    4.4:查询集群B中表中数据是否同步   expect:数据已同步
    5、创建订阅，其他配置信息正常，发布名称存在，子句指定订阅参数slot_name，验证空值null（集群B）
    5.1:创建订阅   expect:创建订阅成功
    5.2:查看复制槽名称   expect:复制槽名称为null
    5.3:向发布端表中插入数据   expect:成功
    5.4:查询集群B中表中数据是否同步   expect:数据已同步
    6、创建订阅，其他配置信息正常，发布名称存在，子句指定订阅参数slot_name，验证slot_name=已存在复制槽名称（集群B）
    6.1:创建逻辑复制槽   expect:成功
    6.2:创建订阅   expect:创建订阅失败
    7、创建订阅，其他配置信息正常，发布名称存在，子句指定订阅参数slot_name，
    验证slot_name=符合规范值（集群B）   expect:创建订阅成功
    7.1:创建订阅   expect:创建订阅成功
    7.2:查看复制槽名称   expect:复制槽名称为定义名称
    7.3:向发布端表中插入数据   expect:成功
    7.4:查询集群B中表中数据是否同步   expect:数据已同步
Expect      :
    1：成功
    2：成功
    3：成功
    4.1：创建订阅成功
    4.2：复制槽名称为订阅名称
    4.3：插入数据成功
    4.4：数据同步成功
    5.1：成功
    5.2：复制槽名称为null
    5.2：插入数据成功
    5.3：数据同步成功
    6.1：创建逻辑复制槽成功
    6.2：创建订阅失败
    7.1：创建订阅成功
    7.2：复制槽名称为定义名称
    7.3：插入数据成功
    7.4：同步数据成功
History     :
"""
import unittest
import os
from yat.test import macro
from yat.test import Node
from testcase.utils.Logger import Logger
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Common import Common
from testcase.utils.Constant import Constant

Primary_SH = CommonSH('PrimaryDbUser')


@unittest.skipIf(3 != Primary_SH.get_node_num(), '非1+2环境不执行')
class Pubsubclass(unittest.TestCase):
    def setUp(self):
        self.log = Logger()
        self.log.info("-----------this is setup-----------")
        self.log.info(f"-----{os.path.basename(__file__)[:-3]} start-----")
        self.pri_userdb_pub = Node(node='PrimaryDbUser')
        self.pri_userdb_sub = Node(node='remote1_PrimaryDbUser')
        self.constant = Constant()
        self.commsh_pub = CommonSH('PrimaryDbUser')
        self.commsh_sub = CommonSH('remote1_PrimaryDbUser')
        self.com_pub = Common()
        self.subname1 = "sub_case101_1"
        self.subname2 = "sub_case101_2"
        self.subname3 = "sub_case101_3"
        self.subname4 = "sub_case101_4"
        self.pubname1 = "pub_case101_1"
        self.pubname2 = "pub_case101_2"
        self.pubname3 = "pub_case101_3"
        self.pubname4 = "pub_case101_4"
        self.tb_name1 = "t_case101_1"
        self.tb_name2 = "t_case101_2"
        self.tb_name3 = "t_case101_3"
        self.tb_name4 = "t_case101_4"
        self.parent_path_pub = os.path.dirname(macro.DB_INSTANCE_PATH)
        self.parent_path_sub = os.path.dirname(macro.DB_INSTANCE_PATH_REMOTE1)
        self.port = str(int(self.pri_userdb_pub.db_port) + 1)
        self.wal_level = self.com_pub.show_param("wal_level")
        self.user_name = "u_case101_1"
        self.user_param_u = f'-U {self.user_name} ' \
            f'-W {macro.COMMON_PASSWD}'
        self.user_param_pub = f'-U {self.pri_userdb_pub.db_user} ' \
            f'-W {self.pri_userdb_pub.db_password}'
        self.user_param_sub = f'-U {self.pri_userdb_sub.db_user} ' \
            f'-W {self.pri_userdb_sub.db_password}'

        cmd = f"cp " \
            f"{os.path.join(macro.DB_INSTANCE_PATH, 'pg_hba.conf')} " \
            f"{os.path.join(self.parent_path_pub, 'pg_hba.conf')};"
        self.log.info(cmd)
        result = self.pri_userdb_pub.sh(cmd).result()
        self.log.info(result)
        cmd = f"cp " \
            f"{os.path.join(macro.DB_INSTANCE_PATH_REMOTE1, 'pg_hba.conf')}" \
            f" {os.path.join(self.parent_path_sub, 'pg_hba.conf')};"
        self.log.info(cmd)
        result = self.pri_userdb_sub.sh(cmd).result()
        self.log.info(result)
        self.slot_name = 'slot_pub_sub_case0101'
        self.slot_name2 = 'slot_pub_sub_case0101_2'

    def test_pubsub(self):
        text = '--step:预置条件,修改pg_hba expect:成功'
        self.log.info(text)
        self.log.info("#######发布端: ")
        guc_res = self.commsh_pub.execute_gsguc(
            'reload', self.constant.GSGUC_SUCCESS_MSG, '',
            'all', False, False, '',
            f'host    replication  {self.user_name} '
            f'{self.pri_userdb_sub.db_host}/32 sha256')
        self.log.info(guc_res)
        self.assertTrue(guc_res, '执行失败:' + text)
        guc_res = self.commsh_pub.execute_gsguc(
            'reload', self.constant.GSGUC_SUCCESS_MSG, '',
            'all', False, False, '',
            f'host    {self.pri_userdb_pub.db_name}  {self.user_name} '
            f'{self.pri_userdb_sub.db_host}/32 sha256')
        self.log.info(guc_res)
        self.assertTrue(guc_res, '执行失败:' + text)
        result = self.commsh_pub.execute_gsguc(
            'set', self.constant.GSGUC_SUCCESS_MSG, 'wal_level=logical')
        self.assertTrue(result, '执行失败:' + text)
        result = self.commsh_pub.restart_db_cluster(True)
        flg = self.constant.START_SUCCESS_MSG in result or 'Degrade' in result
        self.assertTrue(flg, '执行失败:' + text)
        self.log.info("#######订阅端: ")
        guc_res = self.commsh_sub.execute_gsguc(
            'reload', self.constant.GSGUC_SUCCESS_MSG, '',
            'all', False, False, macro.DB_INSTANCE_PATH_REMOTE1,
            f'host    replication  {self.user_name} '
            f'{self.pri_userdb_pub.db_host}/32 sha256',
            macro.DB_ENV_PATH_REMOTE1)
        self.log.info(guc_res)
        self.assertTrue(guc_res, '执行失败:' + text)
        guc_res = self.commsh_sub.execute_gsguc(
            'reload', self.constant.GSGUC_SUCCESS_MSG, '',
            'all', False, False, macro.DB_INSTANCE_PATH_REMOTE1,
            f'host {self.pri_userdb_sub.db_name}  {self.user_name} '
            f'{self.pri_userdb_sub.db_host}/32 sha256',
            macro.DB_ENV_PATH_REMOTE1)
        self.log.info(guc_res)
        self.assertTrue(guc_res, '执行失败:' + text)

        text = "--step1:创建用户，赋予所有权限 expect:成功--"
        self.log.info(text)
        sql = f"create user {self.user_name} password " \
            f"'{macro.COMMON_PASSWD}';" \
            f"grant all privileges to {self.user_name};"
        result = self.commsh_pub.execut_db_sql(sql,
                                               sql_type=self.user_param_pub)
        self.log.info(result)
        self.assertIn(self.constant.CREATE_ROLE_SUCCESS_MSG, result,
                      '执行失败:' + text)
        result = self.commsh_sub.execut_db_sql(sql,
                                               self.user_param_sub, None,
                                               macro.DB_ENV_PATH_REMOTE1)
        self.log.info(result)
        self.assertIn(self.constant.CREATE_ROLE_SUCCESS_MSG, result,
                      '执行失败:' + text)

        text = '--step2:在两个集群中创建相同字段表 expect:成功--'
        self.log.info(text)
        create_sql = f'create table {self.tb_name1}' \
            f'(id int primary key,name text);' \
            f'create table {self.tb_name2}' \
            f'(id int primary key,name text);' \
            f'create table {self.tb_name3}' \
            f'(id int primary key,name text);' \
            f'create table {self.tb_name4}' \
            f'(id int primary key,name text);'
        result = self.commsh_pub.execut_db_sql(
            create_sql, sql_type=self.user_param_u)
        self.log.info(result)
        self.assertIn(self.constant.TABLE_CREATE_SUCCESS,
                      result, '执行失败:' + text)
        self.assertNotIn(self.constant.SQL_WRONG_MSG[1], result,
                         '执行失败:' + text)
        result = self.commsh_sub.execut_db_sql(create_sql,
                                               self.user_param_u, None,
                                               macro.DB_ENV_PATH_REMOTE1)
        self.log.info(result)
        self.assertIn(self.constant.TABLE_CREATE_SUCCESS,
                      result, '执行失败:' + text)
        self.assertNotIn(self.constant.SQL_WRONG_MSG[1], result,
                         '执行失败:' + text)

        text = "--step3:创建发布端(集群A) expect:成功--"
        self.log.info(text)
        sql = f"CREATE PUBLICATION {self.pubname1} " \
            f"for table {self.tb_name1} ;" \
            f"CREATE PUBLICATION {self.pubname2} " \
            f"for table {self.tb_name2};" \
            f"CREATE PUBLICATION {self.pubname3} " \
            f"for table {self.tb_name3};" \
            f"CREATE PUBLICATION {self.pubname4} " \
            f"for table {self.tb_name4};"
        result = self.commsh_pub.execut_db_sql(sql,
                                               sql_type=self.user_param_u)
        self.log.info(result)
        self.assertIn(self.constant.create_pub_succ_msg, result,
                      '执行失败:' + text)
        self.assertNotIn(self.constant.SQL_WRONG_MSG[1], result,
                         '执行失败:' + text)

        text = "--step4.1:创建订阅   expect:创建订阅成功--"
        self.log.info(text)
        result = self.commsh_sub.execute_generate(
            macro.COMMON_PASSWD, env_path=macro.DB_ENV_PATH_REMOTE1)
        self.assertIn('', result, '执行失败:' + text)
        sql = f"CREATE SUBSCRIPTION {self.subname1} CONNECTION " \
            f"'host={self.pri_userdb_pub.db_host} " \
            f"port={self.port} " \
            f"user={self.user_name} " \
            f"dbname={self.pri_userdb_pub.db_name} " \
            f"password={macro.COMMON_PASSWD}' " \
            f"PUBLICATION {self.pubname1}  with(slot_name='{self.pubname1}');"
        result = self.commsh_sub.execut_db_sql(sql, self.user_param_u, None,
                                               macro.DB_ENV_PATH_REMOTE1)
        self.log.info(result)
        self.assertNotIn(self.constant.SQL_WRONG_MSG[1], result,
                      '执行失败:' + text)
        self.assertIn(self.constant.create_sub_succ_msg, result,
                      '执行失败:' + text)

        text = "--step4.2:查看复制槽名称   expect:复制槽名称为订阅名--"
        self.log.info(text)
        sql_slot = f"select * from pg_replication_slots;"
        result = self.commsh_pub.execut_db_sql(sql_slot,
                                               sql_type=self.user_param_u)
        self.log.info(result)
        self.assertIn(self.pubname1, result, '执行失败' + text)

        text = "--step4.3:向发布端表中插入数据   expect:成功--"
        self.log.info(text)
        sql_insert = f"insert into {self.tb_name1} " \
            f"values(generate_series(1,100),'a_'||generate_series(1,100));"
        result = self.commsh_pub.execut_db_sql(sql_insert,
                                               sql_type=self.user_param_u)
        self.log.info(result)
        self.assertIn(self.constant.INSERT_SUCCESS_MSG, result, '执行失败' + text)

        text = "--step4.4:查询集群B中表中数据是否同步   expect:数据已同步--"
        self.log.info(text)
        sql_select = f"select count(*) from {self.tb_name1}"
        result = self.commsh_sub.execut_db_sql(sql_select,
                                               self.user_param_u,
                                               None,
                                               macro.DB_ENV_PATH_REMOTE1)
        self.log.info(result)
        self.assertIn('100', result, '执行失败' + text)

        text = "--step5.1:创建订阅   expect:创建订阅成功--"
        self.log.info(text)
        sql = f"select pg_sleep(50);" \
            f"CREATE SUBSCRIPTION {self.subname2} CONNECTION " \
            f"'host={self.pri_userdb_pub.db_host} " \
            f"port={self.port} " \
            f"user={self.user_name} " \
            f"dbname={self.pri_userdb_pub.db_name} " \
            f"password={macro.COMMON_PASSWD}' " \
            f"PUBLICATION {self.pubname2}  with(slot_name=Null);"
        result = self.commsh_sub.execut_db_sql(sql, self.user_param_u, None,
                                               macro.DB_ENV_PATH_REMOTE1)
        self.log.info(result)
        self.assertNotIn(self.constant.SQL_WRONG_MSG[1], result,
                         '执行失败:' + text)
        self.assertIn(self.constant.create_sub_succ_msg, result,
                         '执行失败:' + text)

        text = "--step5.2:查看复制槽名称   expect:复制槽名称为null--"
        self.log.info(text)
        result = self.commsh_pub.execut_db_sql(sql_slot,
                                               sql_type=self.user_param_u)
        self.log.info(result)
        self.assertIn('null', result, '执行失败' + text)

        text = "--step5.3:向发布端表中插入数据   expect:成功--"
        self.log.info(text)
        sql_insert = f"insert into {self.tb_name2} " \
            f"values(generate_series(1,100),'a_'||generate_series(1,100));"
        result = self.commsh_pub.execut_db_sql(sql_insert,
                                               sql_type=self.user_param_u)
        self.log.info(result)
        self.assertIn(self.constant.INSERT_SUCCESS_MSG, result, '执行失败' + text)

        text = "--step5.4:查询集群B中表中数据是否同步   expect:数据已同步--"
        self.log.info(text)
        sql_select = f"select count(*) from {self.tb_name2}"
        result = self.commsh_sub.execut_db_sql(sql_select,
                                               self.user_param_u,
                                               None,
                                               macro.DB_ENV_PATH_REMOTE1)
        self.log.info(result)
        self.assertIn('100', result, '执行失败' + text)

        text = "--step6.1:创建逻辑复制槽   expect:成功--"
        self.log.info(text)
        sql = f"select * from pg_create_logical_replication_slot('" \
            f"{self.slot_name}', 'mppdb_decoding');"
        result = self.commsh_pub.execut_db_sql(sql,
                                               sql_type=self.user_param_u)
        self.log.info(result)
        self.assertIn(self.slot_name, result, '执行失败:' + text)

        text = "--step6.2:创建订阅   expect:创建订阅失败--"
        self.log.info(text)
        sql = f"select pg_sleep(5);" \
            f"CREATE SUBSCRIPTION {self.subname3} CONNECTION " \
            f"'host={self.pri_userdb_pub.db_host} " \
            f"port={self.port} " \
            f"user={self.user_name} " \
            f"dbname={self.pri_userdb_pub.db_name} " \
            f"password={macro.COMMON_PASSWD}' " \
            f"PUBLICATION {self.pubname3}  with(slot_name={self.slot_name});"
        result = self.commsh_sub.execut_db_sql(sql, self.user_param_u, None,
                                               macro.DB_ENV_PATH_REMOTE1)
        self.log.info(result)
        self.assertIn(self.constant.SQL_WRONG_MSG[1], result,
                         '执行失败:' + text)
        self.assertIn('already exists', result, '执行失败:' + text)

        text = "--step7.1:创建订阅   expect:创建订阅成功--"
        self.log.info(text)
        sql = f"select pg_sleep(50);" \
            f"CREATE SUBSCRIPTION {self.subname4} CONNECTION " \
            f"'host={self.pri_userdb_pub.db_host} " \
            f"port={self.port} " \
            f"user={self.user_name} " \
            f"dbname={self.pri_userdb_pub.db_name} " \
            f"password={macro.COMMON_PASSWD}' " \
            f"PUBLICATION {self.pubname4}  with(slot_name={self.slot_name2});"
        result = self.commsh_sub.execut_db_sql(sql, self.user_param_u, None,
                                               macro.DB_ENV_PATH_REMOTE1)
        self.log.info(result)
        self.assertNotIn(self.constant.SQL_WRONG_MSG[1], result,
                         '执行失败:' + text)
        self.assertIn(self.constant.create_sub_succ_msg, result,
                      '执行失败:' + text)

        text = "--step7.2:查看复制槽名称   expect:复制槽名称为定义名称--"
        self.log.info(text)
        result = self.commsh_pub.execut_db_sql(sql_slot,
                                               sql_type=self.user_param_u)
        self.log.info(result)
        self.assertIn(self.slot_name2, result, '执行失败' + text)

        text = "--step7.3:向发布端表中插入数据   expect:成功--"
        self.log.info(text)
        sql_insert = f"insert into {self.tb_name4} " \
            f"values(generate_series(1,100),'a_'||generate_series(1,100));"
        result = self.commsh_pub.execut_db_sql(sql_insert,
                                               sql_type=self.user_param_u)
        self.log.info(result)
        self.assertIn(self.constant.INSERT_SUCCESS_MSG, result, '执行失败' + text)

        text = "--step7.4:查询集群B中表中数据是否同步   expect:数据已同步--"
        self.log.info(text)
        sql_select = f"select count(*) from {self.tb_name4}"
        result = self.commsh_sub.execut_db_sql(sql_select,
                                               self.user_param_u,
                                               None,
                                               macro.DB_ENV_PATH_REMOTE1)
        self.log.info(result)
        self.assertIn('100', result, '执行失败' + text)

    def tearDown(self):
        self.log.info('------------this is tearDown-------------')
        text = "--环境清理--"
        self.log.info(text)
        sql = f"DROP SUBSCRIPTION if exists {self.subname1};" \
            f"DROP SUBSCRIPTION if exists {self.subname2};" \
            f"DROP SUBSCRIPTION if exists {self.subname3};" \
            f"DROP SUBSCRIPTION if exists {self.subname4};"
        drop_sub_result = self.commsh_sub.execut_db_sql(
            sql, self.user_param_u, None, macro.DB_ENV_PATH_REMOTE1)
        self.log.info(drop_sub_result)
        sql = f"DROP PUBLICATION  {self.pubname1};" \
            f"DROP PUBLICATION  {self.pubname2};" \
            f"DROP PUBLICATION  {self.pubname3};" \
            f"DROP PUBLICATION  {self.pubname4};"
        drop_pub_result = self.commsh_pub.execut_db_sql(
            sql, sql_type=self.user_param_u)
        self.log.info(drop_pub_result)
        sql = f"DROP table if exists {self.tb_name1};" \
            f"DROP table if exists {self.tb_name2};" \
            f"DROP table if exists {self.tb_name3};" \
            f"DROP table if exists {self.tb_name4};"
        result = self.commsh_sub.execut_db_sql(sql, self.user_param_u, None,
                                               macro.DB_ENV_PATH_REMOTE1)
        self.log.info(result)
        result = self.commsh_pub.execut_db_sql(sql,
                                               sql_type=self.user_param_u)
        self.log.info(result)
        sql = f"select * from pg_drop_replication_slot('{self.slot_name}');"
        result = self.commsh_pub.execut_db_sql(sql,
                                               sql_type=self.user_param_u)
        self.log.info(result)
        sql = f"drop user {self.user_name};"
        result = self.commsh_pub.execut_db_sql(sql,
                                               sql_type=self.user_param_pub)
        self.log.info(result)
        result = self.commsh_sub.execut_db_sql(sql, self.user_param_sub, None,
                                               macro.DB_ENV_PATH_REMOTE1)
        self.log.info(result)
        self.log.info(result)
        cmd = f"mv " \
            f"{os.path.join(self.parent_path_pub, 'pg_hba.conf')} "\
            f"{os.path.join(macro.DB_INSTANCE_PATH, 'pg_hba.conf')};"
        self.log.info(cmd)
        result = self.pri_userdb_pub.sh(cmd).result()
        self.log.info(result)
        cmd = f"mv " \
            f"{os.path.join(self.parent_path_sub, 'pg_hba.conf')} "\
            f"{os.path.join(macro.DB_INSTANCE_PATH_REMOTE1, 'pg_hba.conf')} "
        self.log.info(cmd)
        result = self.pri_userdb_sub.sh(cmd).result()
        self.log.info(result)
        result = self.commsh_pub.execute_gsguc(
            'set', self.constant.GSGUC_SUCCESS_MSG,
            f'wal_level={self.wal_level}')
        self.assertTrue(result, '执行失败:' + text)
        self.commsh_pub.restart_db_cluster(True)
        self.commsh_sub.restart_db_cluster(True, macro.DB_ENV_PATH_REMOTE1)
        self.assertIn(self.constant.drop_pub_succ_msg, drop_pub_result,
                      '执行失败' + text)
        self.assertIn(self.constant.drop_sub_succ_msg, drop_sub_result,
                      '执行失败' + text)
        self.log.info(f"-----{os.path.basename(__file__)[:-3]} end-----")
