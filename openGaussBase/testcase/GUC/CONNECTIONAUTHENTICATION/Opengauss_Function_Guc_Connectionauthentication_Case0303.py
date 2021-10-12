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
Case Type   : GUC参数--连接认证
Case Name   : alter system set修改参数listen_address为本机主机名
Description :
    1、查看listen_addresses默认值
    2、获取主机名
    3、设置listen_addresses参数为主机名并重启数据库
    4、使用非套接字和套接字连接数据库
    5、恢复默认值
Expect      :
    1、listen_addresses默认值为监听本机TCP/IP地址
    2、修改listen_addresses参数为空成功
    3、设置并重启数据库成功
    4、使用套接字连接成功;非套接字连接失败
    5、恢复默认值成功
History     :
"""
import unittest
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger
from yat.test import Node
from yat.test import macro

LOGGER = Logger()
COMMONSH = CommonSH("PrimaryDbUser")


class GUC(unittest.TestCase):
    def setUp(self):
        LOGGER.info(
            '-Opengauss_Function_Guc_Connectionauthentication_Case0303start-')
        self.constant = Constant()
        self.user_node = Node("PrimaryDbUser")

    def test_listen_addresses(self):
        LOGGER.info("步骤1:查询listen_addresses值")
        sql_cmd = COMMONSH.execut_db_sql("show listen_addresses;")
        LOGGER.info(sql_cmd)
        self.default_value = sql_cmd.split("\n")[-2].strip()
        LOGGER.info("步骤2:获取主机名")
        check_cmd = f'hostname'
        LOGGER.info(check_cmd)
        hostname = self.user_node.sh(check_cmd).result()
        LOGGER.info(hostname)
        LOGGER.info("步骤3:设置listen_addresses参数为主机名并重启数据库")
        sql_cmd = COMMONSH.execut_db_sql(f"alter system set listen_addresses "
                                         f"to '{hostname}';")
        LOGGER.info(sql_cmd)
        self.assertIn('ALTER SYSTEM SET', sql_cmd)
        sql_cmd = COMMONSH.restart_db_cluster()
        LOGGER.info(sql_cmd)
        status = COMMONSH.get_db_cluster_status()
        LOGGER.info(status)
        self.assertTrue("Normal" in status or "Degraded" in status)
        LOGGER.info("步骤4:使用非套接字和套接字连接数据库")
        result = self.user_node.sh(f'''source {macro.DB_ENV_PATH};\
            gsql \
            -d postgres \
            -p {self.user_node.db_port} \
            -h 127.0.0.1 \
            -U {self.user_node.ssh_user} \
            -W {self.user_node.ssh_password} \
            -c "show listen_addresses;"''').result()
        LOGGER.info(result)
        self.assertIn("could not connect to server", result)
        result = self.user_node.sh(f'''source {macro.DB_ENV_PATH};\
            gsql \
            -d postgres \
            -p {self.user_node.db_port} \
            -U {self.user_node.ssh_user} \
            -W {self.user_node.ssh_password} \
            -c "show listen_addresses;"''').result()
        LOGGER.info(result)
        self.assertIn(f'{hostname}', result)

    def tearDown(self):
        LOGGER.info("步骤5:恢复默认值")
        sql_cmd = COMMONSH.execut_db_sql(f"alter system set listen_addresses "
                                         f"to '{self.default_value}';")
        LOGGER.info(sql_cmd)
        result = COMMONSH.restart_db_cluster()
        LOGGER.info(result)
        status = COMMONSH.get_db_cluster_status()
        self.assertTrue("Normal" in status or "Degraded" in status)
        LOGGER.info(
            '-Opengauss_Function_Guc_Connectionauthentication_Case0303finish-')
