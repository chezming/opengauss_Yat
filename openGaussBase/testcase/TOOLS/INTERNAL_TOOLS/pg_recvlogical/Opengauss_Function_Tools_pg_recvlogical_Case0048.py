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
Case Type   : 系统内部使用工具
Case Name   : 逻辑复制pg_recvlogical 不设置输出到指定文件-f/--file=FILE
Description :
        1.修改参数wal_level为logical;enable_slot_log为on
        2.主机pg_hba.conf文件中配置逻辑复制的用户白名单
        3.主机创建逻辑复制槽
        4.启动逻辑复制槽的流复制，不设置输出到指定文件-f/--file=FILE
        5.删除复制槽
        6.清理环境
Expect      :
        1.修改参数wal_level为logical;enable_slot_log为on成功
        2.pg_hba.conf 配置逻辑复制的用户白名单成功
        3.创建逻辑复制槽成功
        4.启动流复制失败，未指定输出文件
        pg_recvlogical: no target file specified
        5.删除复制槽成功
        6.清理环境完成
History     :
"""
import os
import unittest
from time import sleep

from testcase.utils.Common import Common
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger
from yat.test import Node
from yat.test import macro


class Tools(unittest.TestCase):
    def setUp(self):
        self.log = Logger()
        self.log.info(
            '-Opengauss_Function_Tools_pg_recvlogical_Case0048 start-')
        self.constant = Constant()
        self.common = Common()
        self.primary_node = Node('PrimaryDbUser')
        self.pri_sh = CommonSH('PrimaryDbUser')
        self.u_name = "u_pg_recvlogical_0048"
        self.slot_name = "slot_pg_recvlogical_0048"
        self.default_value1 = self.common.show_param('wal_level')
        self.default_value2 = self.common.show_param('enable_slot_log')
        self.file_path = os.path.join(
            os.path.dirname(macro.DB_INSTANCE_PATH),
            'recvlogical_case0048.log')

    def test_standby(self):
        text = '----step1:修改wal_level为logical;enable_slot_log为on;' \
               'expect: 修改成功----'
        self.log.info(text)
        mod_msg = self.pri_sh.execute_gsguc('set',
                                            self.constant.GSGUC_SUCCESS_MSG,
                                            'wal_level =logical')
        self.log.info(mod_msg)
        self.assertTrue(mod_msg)
        mod_msg = self.pri_sh.execute_gsguc('set',
                                            self.constant.GSGUC_SUCCESS_MSG,
                                            'enable_slot_log =on')
        self.log.info(mod_msg)
        self.assertTrue(mod_msg)
        restart_msg = self.pri_sh.restart_db_cluster()
        self.log.info(restart_msg)

        text = '----step2:主机配置逻辑复制的用户;expect:配置成功----'
        self.log.info(text)
        sql_cmd = self.pri_sh.execut_db_sql(f"drop user if exists "
                                            f"{self.u_name};"
                                            f"create user {self.u_name} "
                                            f"replication password "
                                            f"'{macro.COMMON_PASSWD}';")
        self.log.info(sql_cmd)
        self.assertIn(self.constant.CREATE_ROLE_SUCCESS_MSG, sql_cmd,
                      '执行失败：' + text)
        guc_cmd = f'source {macro.DB_ENV_PATH}; ' \
                  f'gs_guc reload -D {macro.DB_INSTANCE_PATH} ' \
                  f'-h "host  replication  {self.u_name}  ' \
                  f'{self.primary_node.db_host}/32  sha256"'
        self.log.info(guc_cmd)
        guc_res = self.primary_node.sh(guc_cmd).result()
        self.log.info(guc_res)
        self.assertIn(self.constant.GSGUC_SUCCESS_MSG, guc_res,
                      '执行失败：' + text)

        text = '--step3:主机创建逻辑复制槽;expect:成功--'
        self.log.info(text)
        create_cmd = f"pg_recvlogical " \
                     f"-d postgres " \
                     f"-U {self.u_name} " \
                     f"-h {self.primary_node.db_host} " \
                     f"-S {self.slot_name} " \
                     f"-p {str(int(self.primary_node.db_port)+1)} " \
                     f"--create " \
                     f"-W " \
                     f"-v "
        execute_cmd = f'''source {macro.DB_ENV_PATH}
                   expect <<EOF
                   set timeout 300
                   spawn {create_cmd}
                   expect "Password:"
                   send "{macro.COMMON_PASSWD}\\n"
                   expect eof\n''' + '''EOF'''
        self.log.info(execute_cmd)
        exec_msg = self.primary_node.sh(execute_cmd).result()
        self.log.info(exec_msg)
        self.assertIn(f'initializing replication slot "{self.slot_name}"',
                      exec_msg, '执行失败：' + text)
        self.assertNotIn('FATAL', exec_msg, '执行失败：' + text)

        text = '--step4启动逻辑复制槽的流复制, 不设置输出到指定文件' \
               '-f/--file=FILE;expect:启动流复制失败，未指定输出文件 ' \
               'pg_recvlogical: no target file specified--'
        self.log.info(text)
        start_cmd = f"pg_recvlogical " \
                    f"-d postgres " \
                    f"-U {self.u_name} " \
                    f"-h {self.primary_node.db_host} " \
                    f"-S {self.slot_name} " \
                    f"-p {str(int(self.primary_node.db_port)+1)} " \
                    f"--start " \
                    f"-s 2 " \
                    f"-v -n "
        execute_cmd = f'''source {macro.DB_ENV_PATH}
                   expect <<EOF
                   set timeout 30
                   spawn {start_cmd}
                   expect "Password:"
                   send "{macro.COMMON_PASSWD}\\n"
                   expect eof\n''' + '''EOF'''
        self.log.info(execute_cmd)
        exec_msg = self.primary_node.sh(execute_cmd).result()
        self.log.info(exec_msg)
        self.assertIn('pg_recvlogical: no target file specified', exec_msg,
                      '执行失败：' + text)
        self.log.info('------------杀掉pg_recvlogical进程-----------')
        kill_cmd = "ps aux|grep 'pg_recvlogical'|grep -v " \
                   "grep|tr -s ' '|cut -d ' ' -f 2|xargs kill -9"
        self.log.info(kill_cmd)
        kill_msg = self.primary_node.sh(kill_cmd).result()
        self.log.info(kill_msg)
        sleep(5)

        text = '--step5:主机删除复制槽;expect:成功--'
        self.log.info(text)
        del_cmd = f"pg_recvlogical " \
                  f"-d postgres " \
                  f"-U {self.u_name} " \
                  f"-h {self.primary_node.db_host} " \
                  f"-S {self.slot_name} " \
                  f"-p {str(int(self.primary_node.db_port)+1)} " \
                  f" --drop " \
                  f"-v "
        self.log.info(del_cmd)
        execute_cmd = f'''source {macro.DB_ENV_PATH}
                          expect <<EOF
                          set timeout 300
                          spawn {del_cmd}
                          expect "Password:"
                          send "{macro.COMMON_PASSWD}\\n"
                          expect eof\n''' + '''EOF'''
        self.log.info(execute_cmd)
        exec_msg = self.primary_node.sh(execute_cmd).result()
        self.log.info(exec_msg)
        self.assertIn(f'freeing replication slot "{self.slot_name}"',
                      exec_msg, '执行失败：' + text)
        self.assertNotIn('FATAL', exec_msg, '执行失败：' + text)

    def tearDown(self):
        text = '--step6:清理环境;expect:清理环境完成--'
        self.log.info(text)
        self.log.info('--删除用户--')
        drop_cmd = self.pri_sh.execut_db_sql(f"drop user if exists "
                                             f"{self.u_name} cascade;")
        self.log.info(drop_cmd)
        self.log.info('----主机pg_hba.conf文件恢复----')
        guc_cmd = f'source {macro.DB_ENV_PATH}; ' \
                  f'gs_guc reload -D {macro.DB_INSTANCE_PATH} ' \
                  f'-h "host  replication  {self.u_name}  ' \
                  f'{self.primary_node.db_host}/32"'
        self.log.info(guc_cmd)
        guc_res = self.primary_node.sh(guc_cmd).result()
        self.log.info(guc_res)

        self.log.info('--恢复参数默认值--')
        res_cmd1 = self.pri_sh.execute_gsguc('set',
                                             self.constant.GSGUC_SUCCESS_MSG,
                                             f'wal_level='
                                             f'{self.default_value1}')
        self.log.info(res_cmd1)
        res_cmd2 = self.pri_sh.execute_gsguc('set',
                                             self.constant.GSGUC_SUCCESS_MSG,
                                             f'enable_slot_log='
                                             f'{self.default_value2}')
        self.log.info(res_cmd2)
        restart_msg = self.pri_sh.restart_db_cluster()
        self.log.info(restart_msg)
        status = self.pri_sh.get_db_cluster_status()
        self.assertTrue("Degraded" in status or "Normal" in status)
        self.log.info('----断言tearDown执行成功----')
        self.assertTrue(self.constant.DROP_ROLE_SUCCESS_MSG in drop_cmd,
                        '执行失败:' + text)
        self.assertIn(self.constant.GSGUC_SUCCESS_MSG, guc_res,
                      '执行失败：' + text)
        self.assertTrue(res_cmd1, '执行失败:' + text)
        self.assertTrue(res_cmd2, '执行失败:' + text)
        self.log.info(
            '-Opengauss_Function_Tools_pg_recvlogical_Case0048 finish--')
