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
Case Type   : 全密态
Case Name   : 通过增、删、改、查（SUID）语法完成加密表的增删改查
Description :
    1、配置$GAUSSHOME/etc/localkms路径
    2、连接全密态数据库，创建cmk，cek,创建加密表，
    3、通过增删改查（SUID）语法完成加密表的增删改查,
    查看对加密表增删改查后加密表信息
    4、清理环境
Expect      :
    1、配置成功
    2、成功
    3、成功
    4、成功
History     :
"""
import unittest
import os
from yat.test import Node
from yat.test import macro
from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Logger import Logger


class FullDensityState(unittest.TestCase):
    def setUp(self):
        self.logger = Logger()
        self.Constant = Constant()
        self.sh_primy = CommonSH('PrimaryDbUser')
        self.userNode = Node('PrimaryDbUser')
        self.cmk = 'cmk_security_qualityquery_0009'
        self.cek = 'cek_security_qualityquery_0009'
        self.tab = 't_security_qualityquery_0009'
        self.key_path = 'keypath_security_qualityquery_0009'
        self.localkms = os.path.join(macro.DB_INSTANCE_PATH, '..', 'app',
                                     'etc', 'localkms')

    def test_create_cmk_cek(self):
        self.logger.info(f'-----{os.path.basename(__file__)}' + ' start-----')
        text = '---step1:配置$GAUSSHOME/etc/localkms路径;expect:成功-----'
        self.logger.info(text)
        mkdir_cmd = f'if [ ! -d "{self.localkms}" ];' \
                    f'then mkdir {self.localkms};fi'
        self.logger.info(mkdir_cmd)
        self.userNode.sh(mkdir_cmd).result()

        text = '---step2:连接全密态数据库，分别创建cmk，cek,' \
               '创建加密表，通过增删改查（SUID）语法完成加密表的增删改查,' \
               '分别查看对加密表增删改查后加密表信息;expect:成功---'
        self.logger.info(text)
        sql_cmd = f'''drop client master key if exists {self.cmk} cascade;
        create client master key {self.cmk} with 
        (key_store=localkms,key_path="{self.key_path}",
        algorithm=rsa_2048);
        drop column encryption key if exists {self.cek} cascade;
        create column encryption key {self.cek} with values
        (client_master_key = {self.cmk},algorithm = 
        aead_aes_256_cbc_hmac_sha256);
        drop table if exists {self.tab};
        create table {self.tab} (id_number int,name text encrypted 
        with (column_encryption_key = {self.cek}, 
        encryption_type = deterministic),
        credit_card varchar(19) encrypted with 
        (column_encryption_key = {self.cek}, 
        encryption_type = randomized))with (orientation= row);'''
        self.logger.info(sql_cmd)
        msg1 = self.sh_primy.execut_db_sql(sql_cmd, sql_type='-C')
        self.logger.info(msg1)
        self.assertTrue(self.Constant.create_cmk_success in msg1 and
                        self.Constant.create_cek_success in msg1 and
                        self.Constant.TABLE_CREATE_SUCCESS in msg1)
        text = '---step3:通过增删改查（SUID）语法完成加密表的增删改查,' \
               '分别查看对加密表增删改查后加密表信息;expect:成功---'
        sql_cmd = f'''insert into {self.tab} values 
        (15,'Tom',355512189512020345);
        select * from {self.tab};
        update {self.tab} set credit_card = 
        355512189512020015 where id_number=15;
        select * from {self.tab};
        delete from {self.tab} where id_number=15;
        select * from {self.tab};
        '''
        self.logger.info(sql_cmd)
        msg1 = self.sh_primy.execut_db_sql(sql_cmd, sql_type='-C')
        self.logger.info(msg1)
        self.assertTrue(self.Constant.INSERT_SUCCESS_MSG in msg1 and
                        '355512189512020345' in msg1 and '355512189512020015'
                        in msg1 and '(0 rows)' in msg1)

    def tearDown(self):
        text = '--step4:清理环境;expect:成功-------'
        self.logger.info(text)
        sql_cmd = f'drop table {self.tab};' \
                  f'drop column encryption key {self.cek};' \
                  f'drop client master key {self.cmk};'
        self.logger.info(sql_cmd)
        msg1 = self.sh_primy.execut_db_sql(sql_cmd, sql_type='-C')
        self.logger.info(msg1)
        del_cmd = f'rm -rf {self.localkms}'
        self.logger.info(del_cmd)
        del_res = self.userNode.sh(del_cmd).result()
        self.logger.info(del_res)
        self.assertIn(self.Constant.TABLE_DROP_SUCCESS, msg1, text + '执行失败')
        self.assertIn(self.Constant.drop_cek_success, msg1, text + '执行失败')
        self.assertIn(self.Constant.drop_cmk_success, msg1, text + '执行失败')
        self.assertEqual('', del_res, text + '执行失败')
        self.logger.info(f'-----{os.path.basename(__file__)}' + ' end-----')
