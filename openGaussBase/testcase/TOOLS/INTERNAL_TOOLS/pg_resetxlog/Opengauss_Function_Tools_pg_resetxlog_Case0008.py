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
Case Type   : tools
Case Name   : 指定-n参数执行pg_resetxlog命令，是否不更新，仅显示配置文件的值
Description :
    1.查看数据库状态，若为开启状态则关闭数据库
    gs_om -t stop;
    2.在对应目录下查看原有xlog列表
    cd /opt/openGauss_zl/cluster/dn1/pg_xlog
    ll
    3.指定-n参数执行pg_resetxlog命令
    pg_resetxlog -n /opt/openGauss_zl/cluster/dn1/
    4.查看执行结果，是否为配置文件的值
    5.在对应目录下查看现有xlog列表，是否重置成功
    cd /opt/openGauss_zl/cluster/dn1/pg_xlog
    ll
    6.开启数据库
    gs_om -t start
Expect      :
    1.检查数据库状态成功
    2.在对应目录下查看xlog列表成功
    3.执行pg_resetxlog命令成功
    4.命令执行成功，显示为配置文件的值
    5.对应目录下查看xlog列表成功，日志未重置
    6.开启数据库成功
History     :
"""
import os
import time
import unittest
from yat.test import Node
from yat.test import macro
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Logger import Logger

Primary_SH = CommonSH('PrimaryDbUser')
Logger = Logger()


@unittest.skipIf(1 == Primary_SH.get_node_num(),
                 '单机环境不执行')
class Tools(unittest.TestCase):
    def setUp(self):
        Logger.info(
            '---Opengauss_Function_Tools_pg_resetxlog_Case0008 start---')
        self.userNode = Node(node='PrimaryDbUser')
        self.DB_ENV_PATH = macro.DB_ENV_PATH
        self.DB_INSTANCE_PATH = macro.DB_INSTANCE_PATH
        self.standbyNode1 = Node(node='Standby1DbUser')
        self.standbyNode2 = Node(node='Standby2DbUser')

    def test_systools(self):
        Logger.info('--------关闭数据库--------')
        close_db_exe = f'source {self.DB_ENV_PATH};' \
                       f'gs_ctl stop -D {self.DB_INSTANCE_PATH} ' \
                       f'-M primary;'
        Logger.info(close_db_exe)
        close_db_msg = self.userNode.sh(close_db_exe).result()
        Logger.info(close_db_msg)
        Logger.info('----在对应目录下查看原有xlog列表------')
        xlog_path = os.path.join(self.DB_INSTANCE_PATH, 'pg_xlog')
        excute_cmd1 = f'ls -t {xlog_path} | head -1'
        execute_msg1 = self.userNode.sh(excute_cmd1).result()
        Logger.info(execute_msg1)
        Logger.info('----指定-n参数执行pg_resetxlog命令----')
        excute_cmd2 = f'source {self.DB_ENV_PATH};' \
                      f'pg_resetxlog -n {self.DB_INSTANCE_PATH}'
        Logger.info(excute_cmd2)
        execute_msg2 = self.userNode.sh(excute_cmd2).result()
        Logger.info(execute_msg2)
        self.assertTrue('First log segment after reset' in execute_msg2)
        Logger.info('-----在对应目录下查看现有xlog列表，是否重置成功-----')
        excute_cmd3 = f'ls -t {xlog_path} | head -1'
        execute_msg3 = self.userNode.sh(excute_cmd3).result()
        Logger.info(execute_msg3)
        self.assertTrue(execute_msg3 == execute_msg1)
        Logger.info('-------开启数据库-------')
        excute_cmd4 = f'source {self.DB_ENV_PATH};' \
                      f'gs_om -t start'
        execute_msg4 = self.userNode.sh(excute_cmd4).result()
        Logger.info(execute_msg4)
        Logger.info('----------查看备机状态--------')
        excute_cmd5 = f'source {self.DB_ENV_PATH};gs_om -t status --detail'
        Logger.info(excute_cmd5)
        msg5 = self.userNode.sh(excute_cmd5).result()
        Logger.info(msg5)
        if msg5.count('Standby') >= 2:
            Logger.info('-------一主两备环境，备机重建-------')
            excute_cmd6 = f'source {self.DB_ENV_PATH};' \
                          f'gs_ctl build -D {self.DB_INSTANCE_PATH} -b full'
            Logger.info(excute_cmd6)
            execute_msg6 = self.standbyNode1.sh(excute_cmd6).result()
            Logger.info(execute_msg6)
            excute_cmd7 = f'source {self.DB_ENV_PATH};' \
                          f'gs_ctl build -D {self.DB_INSTANCE_PATH} -b full'
            Logger.info(excute_cmd7)
            execute_msg7 = self.standbyNode2.sh(excute_cmd7).result()
            Logger.info(execute_msg7)
        elif msg5.count('Standby') == 1:
            Logger.info('-------一主一备环境，备机重建-------')
            excute_cmd8 = f'source {self.DB_ENV_PATH};' \
                          f'gs_ctl build -D {self.DB_INSTANCE_PATH} -b full'
            Logger.info(excute_cmd8)
            execute_msg8 = self.standbyNode1.sh(excute_cmd8).result()
            Logger.info(execute_msg8)
        Logger.info('----------查看备机状态--------')
        time.sleep(5)
        excute_cmd6 = f'source {self.DB_ENV_PATH};' \
                      f'gs_om -t status --detail'
        Logger.info(excute_cmd6)
        msg6 = self.userNode.sh(excute_cmd6).result()
        Logger.info(msg6)
        self.assertTrue('S Standby Normal' in msg6)

    def tearDown(self):
        Logger.info(
            'Opengauss_Function_Tools_pg_resetxlog_Case0008 finish')
