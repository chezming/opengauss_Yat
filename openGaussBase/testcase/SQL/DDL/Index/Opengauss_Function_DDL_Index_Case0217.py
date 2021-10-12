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
Case Type   : 功能
Case Name   : 创建索引过程中在事务外对无关表进行select操作
Description :
    1.创建表，并插入大数据
    2.使用concurrently创建索引
    3.在创建索引的同时对无关表进行 select操作
    4.使用explain检查索引可否正常使用
Expect      :
History     :
"""
import unittest
from yat.test import macro
from yat.test import Node
from testcase.utils.CommonSH import *
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger
from testcase.utils.ComThread import ComThread


class Concurrently(unittest.TestCase):
    primary_sh = CommonSH('PrimaryDbUser')

    def setUp(self):
        self.dbPrimaryDbUser = Node(node='PrimaryDbUser')
        self.log = Logger()
        self.Constant = Constant()
        self.tblname = 'ddl_index_case0217'
        self.tblname_no_rel = 'ddl_index_case0217_no_rel'
        self.idxname = 'ddl_index_case0217_idx'
        self.log.info('----------------------Opengauss_Function_DDL_Index_Case0217.py start------------------------')

    def test_in_select(self):
        self.log.info('-------------------create table--------------------------------')
        result = self.primary_sh.execut_db_sql(
            f'DROP TABLE IF EXISTS {self.tblname};CREATE TABLE {self.tblname}(id INT, c_point point);')
        self.log.info(result)
        self.assertIn(self.Constant.CREATE_TABLE_SUCCESS, result)
        self.log.info('-------------------insert data--------------------------------')
        result = self.primary_sh.execut_db_sql(f'INSERT INTO {self.tblname} SELECT id, point\'(1,2)\' FROM (SELECT * FROM generate_series(1,2000000) AS id) AS x;\
        update {self.tblname} set c_point=point\'(1,1)\' where id = 712;')
        self.log.info(result)
        self.assertIn(self.Constant.INSERT_SUCCESS_MSG, result)
        self.assertIn(self.Constant.UPDATE_SUCCESS_MSG, result)

        self.log.info('-------------------create table no relevance--------------------------------')
        result = self.primary_sh.execut_db_sql(
            f'DROP TABLE IF EXISTS {self.tblname_no_rel};CREATE TABLE {self.tblname_no_rel}(id INT, first_name text, last_name text);')
        self.log.info(result)
        self.assertIn(self.Constant.CREATE_TABLE_SUCCESS, result)
        self.log.info('-------------------insert data--------------------------------')
        result = self.primary_sh.execut_db_sql(f'INSERT INTO {self.tblname_no_rel} SELECT id, md5(random()::text), md5(random()::text) FROM (SELECT * FROM generate_series(1,8000000) AS id) AS x;\
                update {self.tblname_no_rel} set first_name=\'测试查询不阻塞\', last_name=\'测试%%不阻塞\' where id = 712;')
        self.log.info(result)
        self.assertIn(self.Constant.INSERT_SUCCESS_MSG, result)
        self.assertIn(self.Constant.UPDATE_SUCCESS_MSG, result)
        #
        self.log.info('-----------------create index-----------------------------')
        sql = f'select current_time;create index concurrently {self.idxname} on {self.tblname} USING gist(c_point);select current_time;'
        create_index_thread = ComThread(self.primary_sh.execut_db_sql, args=(sql, ''))
        create_index_thread.setDaemon(True)
        create_index_thread.start()

        self.log.info('-----------------select table-----------------------------')
        before_time = self.dbPrimaryDbUser.sh("date +'%s'").result()
        result = self.primary_sh.execut_db_sql(f'SELECT * FROM {self.tblname_no_rel} where id = 712;')
        after_time = self.dbPrimaryDbUser.sh("date +'%s'").result()
        self.log.info(result)
        self.assertIn('测试查询不阻塞', result)
        self.assertIn('测试%%不阻塞', result)
        self.assertIn('712', result)
        total_time = int(after_time) - int(before_time)
        self.log.info(f'before_time is : {before_time}')
        self.log.info(f'after_time is : {after_time}')

        self.log.info('-----------------check create index result-----------------------------')
        create_index_thread.join(10 * 60)
        create_idx_result = create_index_thread.get_result()
        self.log.info(create_idx_result)
        before_create_time = create_idx_result.splitlines()[2].strip()
        after_create_time = create_idx_result.splitlines()[-2].strip()
        self.log.info(f'before_create_time is {before_create_time}')
        self.log.info(f'after_create_time is {after_create_time}')
        create_time_H = before_create_time.split(':')[0]
        create_time_M = before_create_time.split(':')[1]
        create_time_S = before_create_time.split(':')[2].split('.')[0]
        create_time_H1 = after_create_time.split(':')[0]
        create_time_M1 = after_create_time.split(':')[1]
        create_time_S1 = after_create_time.split(':')[2].split('.')[0]
        create_index_time = int(create_time_H1) * 60 * 60 + int(create_time_M1) * 60 + int(create_time_S1) - int(
            create_time_H) * 60 * 60 - int(create_time_M) * 60 - int(create_time_S)
        self.log.info(f'create_index_time is {create_index_time}')
        self.assertIn(self.Constant.CREATE_INDEX_SUCCESS, create_idx_result)
        # 若阻塞查询时间必然比创建索引时间大
        self.assertTrue(create_index_time - total_time)

        self.log.info('-----------------explain select-----------------------------')
        result = self.primary_sh.execut_db_sql(
            f'SET ENABLE_SEQSCAN=off;explain SELECT * FROM {self.tblname} where c_point  <^ point(1,2);')
        self.log.info(result)
        self.assertIn(self.idxname, result)

        self.log.info('----------------- select-----------------------------')
        result = self.primary_sh.execut_db_sql(
            f'SET ENABLE_SEQSCAN=off;SELECT * FROM {self.tblname} where c_point  <^ point(1,2);')
        self.log.info(result)
        self.assertIn('(1,1)', result)
        self.assertIn('712', result)

    def tearDown(self):
        self.log.info('----------------this is tearDown------------------------------------')
        self.log.info('----------------drop table------------------------------------')
        result = self.primary_sh.execut_db_sql(
            f'RESET ENABLE_SEQSCAN;'
            f'drop table if exists {self.tblname};'
            f'drop table if exists {self.tblname_no_rel};')
        self.log.info(result)
