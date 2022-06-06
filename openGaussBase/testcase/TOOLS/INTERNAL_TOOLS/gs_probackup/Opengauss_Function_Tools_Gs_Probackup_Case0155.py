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
Case Name   : 使用gs_probackup add-instance命令添加远程模式相关参数，
              指定--remote-proto=tcp错误
Description :
    1.创建备份目录
    2.进行初始化
    3.添加远程实例
    4.恢复环境
Expect      :
    1.创建备份目录成功
    2.初始化成功
    3.添加远程实例成功, 此处不校验参数信息
    4.恢复环境完成
            新增--remote-lib=libpath参数
"""

import os
import unittest

from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger
from yat.test import Node
from yat.test import macro

Pri_SH = CommonSH('PrimaryDbUser')


@unittest.skipIf(1 == Pri_SH.get_node_num(), '单机环境不执行')
class SystemInternalTools(unittest.TestCase):
    def setUp(self):
        self.Primary_User_Node = Node('PrimaryDbUser')
        self.Standby_User_Node = Node('Standby1DbUser')
        self.log = Logger()
        self.constant = Constant()
        self.re_path = os.path.join(os.path.dirname(macro.DB_INSTANCE_PATH),
                                    'app', 'bin')
        self.remote_lib = os.path.join(os.path.dirname(macro.DB_INSTANCE_PATH),
                                       'app', 'lib')
        self.gs_probackup_path = os.path.join(macro.DB_INSTANCE_PATH,
                                              'gs_probackup_testdir0155')
        self.log.info(
            '----Opengauss_Function_Tools_Gs_Probackup_Case0155 start----')

    def test_server_tools(self):
        text = '--step1:创建备份目录;expect:创建成功----'
        self.log.info(text)
        mkdir_cmd = f'''if [ ! -d "{self.gs_probackup_path}" ]
                        then
                            mkdir -p {self.gs_probackup_path}
                        fi'''
        self.log.info(mkdir_cmd)
        primary_result = self.Primary_User_Node.sh(mkdir_cmd).result()
        self.log.info(primary_result)
        self.assertEqual(primary_result, '', '执行失败:' + text)

        text = '--step2:进行初始化;expect:初始化成功---'
        self.log.info(text)
        init_cmd = f"source {macro.DB_ENV_PATH};" \
                   f"gs_probackup init -B {self.gs_probackup_path};"
        self.log.info(init_cmd)
        init_msg = self.Primary_User_Node.sh(init_cmd).result()
        self.log.info(init_msg)
        self.assertIn(self.constant.init_success, init_msg,
                      '执行失败:' + text)

        text = '--step3:添加远程实例;expect:添加成功----'
        self.log.info(text)
        add_cmd = f"source {macro.DB_ENV_PATH};" \
                  f"gs_probackup add-instance " \
                  f"-B {self.gs_probackup_path} " \
                  f"-D {macro.DB_INSTANCE_PATH} " \
                  f"--instance=test_0155 " \
                  f"--remote-user={self.Standby_User_Node.ssh_user} " \
                  f"--remote-host={self.Standby_User_Node.db_host} " \
                  f"--remote-port=22 " \
                  f"--remote-proto=tcp " \
                  f"--remote-path={self.re_path} " \
                  f"--remote-lib={self.remote_lib}"
        self.log.info(add_cmd)
        exec_msg = self.Primary_User_Node.sh(add_cmd).result()
        self.log.info(exec_msg)
        self.assertIn("'test_0155' " + self.constant.init_success, exec_msg,
                      '执行失败:' + text)

    def tearDown(self):
        text = '--step4:恢复环境;expect:恢复环境完成--'
        self.log.info(text)
        rm_cmd = f'rm -rf {self.gs_probackup_path}'
        self.log.info(rm_cmd)
        clear_msg = self.Primary_User_Node.sh(rm_cmd).result()
        self.log.info(clear_msg)
        self.log.info(
            '----Opengauss_Function_Tools_Gs_Probackup_Case0155 end----')
