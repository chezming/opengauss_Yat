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
Case Type   : tools
Case Name   : 启动gaussdb进程时，备机使用-h参数指定备机host启动是否成功
Description :
    1.关闭正在运行的数据库（备机）
    gs_ctl stop -D /opt/openGauss_zl/cluster/dn1
    2.查看进程，确定关闭成功
    ps -ef|grep zl
    3.使用gaussdb工具后台运行进程
    gaussdb -D /opt/openGauss_zl/cluster/dn1 -p 19701 -h 10.183.187.233
     -M standby &
Expect      :
    1.关闭正在运行的数据库成功
    2.查看进程，数据库连接进程不存在，数据库关闭成功
    3.使用gaussdb工具指定备机host启动数据库进程成功
History     :
"""
import datetime
import unittest
from multiprocessing import Process
from time import sleep

from testcase.utils.ComThread import ComThread
from yat.test import Node
from yat.test import macro
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Logger import Logger


class Tools(unittest.TestCase):
    def setUp(self):
        self.logger = Logger()
        self.logger.info('-Opengauss_Function_Tools_Gaussdb_Case0021 start-')
        self.userNode = Node(node='PrimaryDbUser')
        self.sh_primy = CommonSH('PrimaryDbUser')
        self.DB_ENV_PATH = macro.DB_ENV_PATH
        self.DB_INSTANCE_PATH = macro.DB_INSTANCE_PATH
        self.process = Process()

    def test_systools(self):
        self.logger.info('-------若为单机环境，后续不执行-------')
        excute_cmd = f''' source {self.DB_ENV_PATH}
                   gs_om -t status --detail'''
        self.logger.info(excute_cmd)
        msg = self.userNode.sh(excute_cmd).result()
        self.logger.info(msg)
        if 'Standby' not in msg:
            self.logger.info('单机环境，后续不执行!')
        else:
            self.standbyNode = Node(node='Standby1DbUser')
            self.standbyNode2 = Node('Standby1DbUser')
            self.logger.info("--------关闭正在运行的数据库--------")
            excute_cmd1 = f'''source {self.DB_ENV_PATH};
                    gs_ctl stop -D {self.DB_INSTANCE_PATH}'''
            self.logger.info(excute_cmd1)
            msg1 = self.standbyNode.sh(excute_cmd1).result()
            self.logger.info(msg1)
            self.logger.info("--------查看进程，确定关闭成功--------")
            excute_cmd2 = f'''ps -ef|grep {self.userNode.ssh_user}'''
            self.logger.info(excute_cmd2)
            msg2 = self.standbyNode.sh(excute_cmd2).result()
            self.logger.info(msg2)
            self.assertFalse(self.DB_INSTANCE_PATH in msg2)
            self.logger.info("----使用gaussdb工具启动---")
            host_msg = self.standbyNode.db_host
            excute_cmd3 = f'source {self.DB_ENV_PATH};' \
                          f'gaussdb -D {self.DB_INSTANCE_PATH} -p ' \
                          f'{self.userNode.db_port} -h {host_msg} -M standby'
            self.logger.info(excute_cmd3)
            thread_2 = ComThread(self.standbyNode2.sh, args=(excute_cmd3,))
            thread_2.setDaemon(True)
            thread_2.start()
            thread_2.join(10)
            msg_result_2 = thread_2.get_result()
            self.logger.info(msg_result_2)
            self.logger.info('-----------查看集群状态是否正常----------')
            excute_cmd4 = f'source {self.DB_ENV_PATH};' \
                          f'gs_om -t status --detail'
            self.logger.info(excute_cmd4)
            msg4 = self.standbyNode.sh(excute_cmd4).result()
            self.logger.info(msg4)
            self.assertTrue(
                'P Primary Normal' in msg4 and 'S Standby Normal' in msg4)

    def tearDown(self):
        self.logger.info('-Opengauss_Function_Tools_Gaussdb_Case0021 finish-')
