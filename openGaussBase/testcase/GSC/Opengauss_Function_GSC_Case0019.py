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
Case Type   : GSC功能模块
Case Name   : gsc打开，某个库中某张表未进行缓存/已缓场景下，并发查询表，验证该库相应系统缓存信息变化
Description :
    1、修改enable_global_syscache为on;
    2、重启数据库，使参数生效;
    3、创建数据库;
    4、创建10个表;
    5、查询所有库并进行连接;
    6、表未缓存时，并发进行表查询，查看syscache占用情况;
    7、表已缓存时，进行表查询，查看syscache占用情况;
Expect      :
    1、修改enable_global_syscache为on; 成功
    2、重启数据库，使参数生效; 重启成功
    3、创建数据库; 创建成功
    4、创建10个表; 创建成功
    5、查询所有库并进行连接; 连接成功
    6、表未缓存时，并发进行表查询，查看syscache占用情况; gsc最终缓存结果一致
    7、表已缓存时，进行表查询，查看syscache占用情况; 系统缓存不增加
History     :
"""
import os
import unittest

from testcase.utils.ComThread import ComThread
from testcase.utils.Common import Common
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger
from yat.test import Node


class GscTestCase(unittest.TestCase):
    def setUp(self):
        self.log = Logger()
        self.log.info(f'----{os.path.basename(__file__)}:start----')
        self.sh = CommonSH('PrimaryDbUser')
        self.constant = Constant()
        self.com = Common()
        self.pri_dbuser = Node(node='PrimaryDbUser')
        self.db_name = 'db_gsc0019'
        self.circle_num = 3
        self.tb_num = 10
        self.tb_ex_name = 'tb_gsc0019_'

    def test_main(self):
        step_txt = '----step0:查看enable_global_syscache初始配置值;----'
        self.log.info(step_txt)
        self.init_para1 = self.com.show_param('enable_global_syscache')

        step_txt = '----step1:修改enable_global_syscache为on; expect:成功----'
        self.log.info(step_txt)
        msg = self.sh.execute_gsguc('set',
                                    self.constant.GSGUC_SUCCESS_MSG,
                                    f"enable_global_syscache= on")
        self.assertTrue(msg, '执行失败:' + step_txt)

        step_txt = '----step2:重启数据库，使参数生效; expect:重启成功----'
        self.log.info(step_txt)
        restart_result = self.sh.restart_db_cluster()
        self.assertTrue(restart_result)
        self.log.info('----查询参数----')
        self.new_para1 = self.com.show_param('enable_global_syscache')
        self.assertEqual(self.new_para1, 'on', '执行失败:' + step_txt)

        step_txt = f'----step3:创建数据库; expect:创建成功----'
        self.log.info(step_txt)
        create_db = f'create database {self.db_name};'
        create_result = self.sh.execut_db_sql(create_db)
        self.log.info(create_result)
        self.assertIn(self.constant.CREATE_DATABASE_SUCCESS,
                      create_result, '执行失败:' + step_txt)

        step_txt = f'----step4:创建{self.tb_num}个表; expect:创建成功----'
        self.log.info(step_txt)
        for i in range(self.tb_num):
            create_tb_sql = f"create table {self.tb_ex_name}{i} " \
                f"(c_integer integer,c_tinyint tinyint," \
                f"c_smallint smallint,c_binary_integer binary_integer," \
                f"c_bigint bigint,c_numeric numeric(10,4)," \
                f"c_number number(10,4),c_smallserial smallserial)"
            create_result = self.sh.execut_db_sql(create_tb_sql,
                                                  dbname=f'{self.db_name}')
            self.log.info(create_result)
            self.assertIn(self.constant.TABLE_CREATE_SUCCESS, create_result,
                          '执行失败:' + step_txt)

        step_txt = '----step5:查询所有库并进行连接; expect:连接成功----'
        self.log.info(step_txt)
        select_db_sql = "select datname from pg_database where datname " \
                        "not like('template%');"
        select_db_result = self.sh.execut_db_sql(select_db_sql)
        self.log.info(select_db_result)
        db_list = select_db_result.splitlines()[2:-1:1]
        for i in db_list:
            con_result = self.sh.execut_db_sql('select current_database();',
                                               dbname=f'{i}')
            self.log.info(con_result)
            self.assertIn(i, con_result, '执行失败:' + step_txt)

        step_txt = '----step6:表未缓存时，并发进行表查询，查看syscache占用情况; ' \
                   'expect:gsc最终缓存结果一致----'
        self.log.info(step_txt)
        connect_thread = []
        gsc_size = []
        for j in range(self.circle_num):
            connect_thread.append(ComThread(self.check_gsc, args=()))
            connect_thread[j].setDaemon(True)
            connect_thread[j].start()
        for j in range(self.circle_num):
            connect_thread[j].join(20)
            result = connect_thread[j].get_result()
            self.log.info(result)
            gsc_size.append(int(result.splitlines()[-2].strip()))
        self.log.info(gsc_size)
        self.assertEqual(1, len(set(gsc_size)), '执行失败:' + step_txt)

        step_txt = '----step7:表已缓存时，进行表查询，查看syscache占用情况; ' \
                   'expect:系统缓存不增加----'
        self.log.info(step_txt)
        gsc_size1 = []
        for i in range(self.tb_num):
            check_sql = f"select * from {self.tb_ex_name}{i};" \
                f"select * from gs_gsc_memory_detail;" \
                f"select * from gs_gsc_dbstat_info() where " \
                f"database_name = '{self.db_name}';" \
                f"select sum(totalsize) from gs_gsc_memory_detail " \
                f"where db_id = (select cast((select oid from " \
                f"pg_database where datname = '{self.db_name}') as text));"
            check_result = self.sh.execut_db_sql(check_sql,
                                                 dbname=f'{self.db_name}')
            self.log.info(check_result)
            gsc_size1.append(int(check_result.splitlines()[-2].strip()))
        self.log.info(gsc_size1)
        self.assertEqual(1, len(set(gsc_size1)), '执行失败:' + step_txt)

    def check_gsc(self):
        check_sql = ''
        for i in range(self.tb_num):
            check_sql = check_sql + f"select * from {self.tb_ex_name}{i};" \
                f"select * from gs_gsc_memory_detail;" \
                f"select * from gs_gsc_dbstat_info() where " \
                f"database_name = '{self.db_name}';" \
                f"select sum(totalsize) from gs_gsc_memory_detail " \
                f"where db_id = (select cast((select oid from " \
                f"pg_database where datname = '{self.db_name}') as text));"
        check_result = self.sh.execut_db_sql(check_sql,
                                             dbname=f'{self.db_name}')
        return check_result

    def tearDown(self):
        step_txt = '----this is teardown----'
        self.log.info(step_txt)
        step1_txt = '----删除数据库 expect:删除成功----'
        self.log.info(step1_txt)
        drop_db = f'drop database {self.db_name}'
        drop_db_result = self.sh.execut_db_sql(drop_db)

        step2_txt = '----恢复参数为初始值并查询; expect:设置成功----'
        self.log.info(step2_txt)
        msg1 = self.sh.execute_gsguc('set',
                                     self.constant.GSGUC_SUCCESS_MSG,
                                     f"enable_global_syscache="
                                     f"{self.init_para1}")

        step3_txt = '----重启数据库，使参数生效; expect:重启成功----'
        self.log.info(step3_txt)
        restart_result = self.sh.restart_db_cluster()
        step4_txt = '----查询数据库状态; expect:状态正常----'
        self.log.info(step4_txt)
        status_result = self.sh.get_db_cluster_status('status')

        self.log.info(f'----{os.path.basename(__file__)}:end----')
        flag = self.constant.DROP_DATABASE_SUCCESS
        self.assertIn(flag, drop_db_result, '执行失败:' + step_txt + step1_txt)
        self.assertTrue(msg1, '执行失败:' + step_txt + step2_txt)
        self.assertTrue(restart_result, '执行失败:' + step_txt + step3_txt)
        self.assertTrue(status_result, '执行失败:' + step_txt + step4_txt)
