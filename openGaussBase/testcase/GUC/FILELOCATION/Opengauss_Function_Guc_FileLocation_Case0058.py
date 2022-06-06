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
Case Type   : GUC
Case Name   : 使用ALTER SYSTEM SET修改数据库参数external_pid_file为问题路径
              （如路径分隔符为\）
Description :
        1.查询external_pid_file默认值
        2.创建测试文件
        3.使用ALTER SYSTEM SET修改数据库参数external_pid_file为问题路径并
        重启数据库
        4.查询参数修改后的值
        5.清理环境
Expect      :
        1.默认值为空
        2.创建成功
        3.重启成功
        4.修改成功
        5.清理环境完成
History     :
"""
import unittest

from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger
from yat.test import Node
from yat.test import macro


class FilePosition(unittest.TestCase):
    def setUp(self):
        self.log = Logger()
        self.log.info(
            '-Opengauss_Function_Guc_FileLocation_Case0058start-')
        self.constant = Constant()
        self.pri_sh = CommonSH('PrimaryDbUser')
        self.user_node = Node('PrimaryDbUser')

    def test_guc(self):
        text = '---step1:查询默认值;expect:默认值是空---'
        self.log.info(text)
        sql_cmd = self.pri_sh.execut_db_sql('show external_pid_file;')
        self.log.info(sql_cmd)
        self.assertEqual('', sql_cmd.splitlines()[-2].strip(),
                         '执行失败:' + text)

        text = '---step2:创建测试文件;expect:创建成功---'
        self.log.info(text)
        touch_cmd = f'''touch {macro.DB_INSTANCE_PATH}/external.pid'''
        self.log.info(touch_cmd)
        msg = self.user_node.sh(touch_cmd).result()
        self.log.info(msg)

        text = '---step3:使用ALTER SYSTEM SET修改数据库参数external_pid_file' \
               '为问题路径并重启数据库;expect:重启成功'
        sql_cmd = self.pri_sh.execut_db_sql(f"alter system set "
                                            f"external_pid_file to "
                                            f"'{macro.DB_INSTANCE_PATH}"
                                            f"\\external.pid'")
        self.log.info(sql_cmd)
        self.assertIn('ALTER SYSTEM SET', sql_cmd, '执行失败:' + text)
        msg = self.pri_sh.restart_db_cluster()
        self.log.info(msg)
        status = self.pri_sh.get_db_cluster_status()
        self.assertTrue("Degraded" in status or "Normal" in status,
                        '执行失败:' + text)

        text = '---step4:查询修改后的参数值;expect:修改成功---'
        self.log.info(text)
        sql_cmd = self.pri_sh.execut_db_sql('show external_pid_file;')
        self.log.info(sql_cmd)
        self.assertIn(f'{macro.DB_INSTANCE_PATH}external.pid', sql_cmd,
                      '执行失败:' + text)

    def tearDown(self):
        text = '---step5:清理环境;expect:清理环境完成---'
        self.log.info(text)
        rm_cmd = f'''rm -rf {macro.DB_INSTANCE_PATH}/external.pid'''
        self.log.info(rm_cmd)
        msg = self.user_node.sh(rm_cmd).result()
        self.log.info(msg)
        sql_cmd = self.pri_sh.execut_db_sql("alter system set "
                                            "external_pid_file to '';")
        self.log.info(sql_cmd)
        msg = self.pri_sh.restart_db_cluster()
        self.log.info(msg)
        status = self.pri_sh.get_db_cluster_status()
        self.assertTrue("Degraded" in status or "Normal" in status,
                        '执行失败:' + text)
        self.log.info(
            '-Opengauss_Function_Guc_FileLocation_Case0058finish-')
