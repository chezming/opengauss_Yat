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
Case Type   : 系统内部使用工具
Case Name   : gs_ctl start只使用-D指定不正确数据库实例目录启动主机
Description :
    1.关闭正在运行的主机
    2.指定不正确数据库实例目录启动主机
    3.恢复集群状态
Expect      :
    1.关闭正在运行的主机成功
    2.指定不正确数据库实例目录启动主机成功
    3.恢复集群状态成功
History     :
"""

import unittest

from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Logger import Logger
from yat.test import Node
from yat.test import macro

LOG = Logger()


class LogicalReplication(unittest.TestCase):
    def setUp(self):
        LOG.info('----------------this is setup-----------------------')
        LOG.info(
            '---Opengauss_Function_Tools_gs_ctl_Case0003开始执行-----')
        self.constant = Constant()
        self.env_path = macro.DB_ENV_PATH
        self.my_path = macro.DB_BACKUP_PATH
        self.instance_path = macro.DB_INSTANCE_PATH
        self.user_node = Node('PrimaryDbUser')
        self.sh_primary = CommonSH('PrimaryDbUser')

    def test_system_internal_tools(self):
        LOG.info('---------关闭正在运行的主机------------')
        excute_cmd = f'''
                    source {self.env_path};
                    gs_ctl stop -D {self.instance_path} 
                '''
        LOG.info(excute_cmd)
        msg = self.user_node.sh(excute_cmd).result()
        LOG.info(msg)
        self.assertIn(self.constant.GS_CTL_STOP_SUCCESS_MSG, msg)

        LOG.info('----------------开启主机-------------------')
        excute_cmd = f'''
                            source {self.env_path};
                            gs_ctl start -D {self.my_path} -M primary; 
                        '''
        LOG.info(excute_cmd)
        msg = self.user_node.sh(excute_cmd).result()
        LOG.info(msg)
        self.assertIn(self.constant.gs_ctl_start_filed, msg)

    def tearDown(self):
        LOG.info('----------------this is tearDown-----------------------')
        LOG.info('----------------开启主机-------------------')
        excute_cmd = f'''
                        source {self.env_path};
                        gs_ctl start -D {self.instance_path} -M primary; 
                    '''
        LOG.info(excute_cmd)
        msg = self.user_node.sh(excute_cmd).result()
        LOG.info(msg)
        LOG.info('----------------查看集群状态-------------------')
        status = self.sh_primary.get_db_cluster_status()
        LOG.info(status)
        LOG.info(
            '-----Opengauss_Function_Tools_gs_ctl_Case0003执行完成---')
