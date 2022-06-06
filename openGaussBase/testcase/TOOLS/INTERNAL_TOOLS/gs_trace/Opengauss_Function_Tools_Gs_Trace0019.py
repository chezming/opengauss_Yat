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
Case Name   : -o指定已存在的文件执行dump trace
Description :
    1.查看gaussdb端口号
    2.启动trace
    3.将共享内存中的trace信息写入指定文件
    4.-o指定已存在的文件执行dump trace
Expect      :
    1.查看gaussdb端口号成功
    2.启动trace成功
    3.将共享内存中的trace信息写入指定文件成功
    4.-o指定已存在的文件执行dump trace,成功
History     :
"""

import unittest
import os

from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger
from yat.test import Node
from yat.test import macro

LOG = Logger()


class SystemInternalTools(unittest.TestCase):
    def setUp(self):
        self.logger = Logger()
        self.logger.info(f'-----{os.path.basename(__file__)} start-----')
        self.constant = Constant()
        self.PrimaryNode = Node('PrimaryDbUser')
        self.sh_primary = CommonSH('PrimaryDbUser')

    def test_system_internal_tools(self):
        LOG.info('-----------------查看数据库端口号---------------')
        show_port = f'''show port;'''
        res = self.sh_primary.execut_db_sql(show_port)
        self.node_port = res.splitlines()[-2].strip()
        LOG.info('数据库端口为:' + self.node_port)

        LOG.info('--------------启动trace------------------')
        start_cmd = f'''source {macro.DB_ENV_PATH};
            source /etc/profile
            gstrace start -p {self.node_port};
            '''
        LOG.info(start_cmd)
        start_msg = self.PrimaryNode.sh(start_cmd).result()
        LOG.info(start_msg)
        self.assertIn(self.constant.trace_start_success, start_msg)

        LOG.info('--------------创建目录-------------')
        mkdir_cmd = f"mkdir {macro.DB_BACKUP_PATH}/testzz;"
        LOG.info(mkdir_cmd)
        mkdir_msg = self.PrimaryNode.sh(mkdir_cmd).result()
        LOG.info(mkdir_msg)
        self.assertNotIn(self.constant.SQL_WRONG_MSG[1], mkdir_msg)

        LOG.info('---------将共享内存中的trace信息写入指定文件---------')
        dump_cmd = f'''source {macro.DB_ENV_PATH};
            gstrace dump -p {self.node_port} -o \
            {macro.DB_BACKUP_PATH}/gs_trace.dump ;
            '''
        LOG.info(dump_cmd)
        dump_msg = self.PrimaryNode.sh(dump_cmd).result()
        self.assertIn('dump Success', dump_msg)

        LOG.info('------------o指定已存在的文件执行dump trace-------------')
        dump_cmd = f'''source {macro.DB_ENV_PATH};
            gstrace dump -p {self.node_port} -o \
            {macro.DB_BACKUP_PATH}/gs_trace.dump ;
            '''
        LOG.info(dump_cmd)
        dump_msg = self.PrimaryNode.sh(dump_cmd).result()
        self.assertIn('dump Success', dump_msg)

    def tearDown(self):
        LOG.info('--------------this is tearDown--------------')
        stop_cmd = f'''source {macro.DB_ENV_PATH};
            gstrace stop -p {self.node_port};
            rm -rf {macro.DB_BACKUP_PATH}/gs_trace.dump;
            '''
        LOG.info(stop_cmd)
        stop_msg = self.PrimaryNode.sh(stop_cmd).result()
        LOG.info(stop_msg)
        self.logger.info(f'-----{os.path.basename(__file__)} end-----')
