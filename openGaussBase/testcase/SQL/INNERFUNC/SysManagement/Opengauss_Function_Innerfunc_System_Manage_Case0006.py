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
Case Type   : 系统管理函数-其他函数
Case Name   : 对指定的数据库加锁和解锁
Description :
    1.查看已创建得数据库
    2.对指定的数据库加锁
    3.释放指定数据库锁
Expect      :
    1.查看已创建得数据库成功
    2.对指定的数据库加锁成功
    3.释放指定数据库锁成功
History     : 
"""

import unittest
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Logger import Logger

LOG = Logger()


class Tools(unittest.TestCase):
    def setUp(self):
        LOG.info('-Opengauss_Function_Innerfunc_System_Manage_Case0006开始-')
        self.commonsh = CommonSH('dbuser')

    def test_func_sys_manage(self):
        LOG.info(f'---步骤1.查看已创建得数据库---')
        sql_cmd = self.commonsh.execut_db_sql(f'\l')
        LOG.info(sql_cmd)
        data_name = sql_cmd.split('\n')[3].split('|')[0].strip()
        LOG.info(data_name)

        LOG.info(f'-步骤2.对指定的数据库加锁')
        sql_cmd = self.commonsh.execut_db_sql(
            f'select pgxc_lock_for_sp_database(\'{data_name}\');')
        LOG.info(sql_cmd)
        self.assertIn(f't', sql_cmd)

        LOG.info(f'-步骤3.释放指定数据库锁')
        sql_cmd = self.commonsh.execut_db_sql(
            f'select pgxc_unlock_for_sp_database(\'{data_name}\');')
        LOG.info(sql_cmd)
        self.assertIn(f't', sql_cmd)

    def tearDown(self):
        LOG.info('-------无需清理环境-------')
        LOG.info('-Opengauss_Function_Innerfunc_System_Manage_Case0006结束-')
