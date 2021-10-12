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
Case Type   : gs_dropnode
Case Name   : 1+2备在被减容的备库执行gs_om -t stop 期望：集群被停止，可以start恢复
Description :
        1.在数据库用户下减容备机，期望：减容成功
        2.在减容备机上执行gs_om -t stop查询集群状态 期望：集群被stop
        3.清理环境 在主机start集群后扩容 期望：集群恢复为1+2
Expect      :
        1.减容执行成功，备2被减容
        2.集群被stop
        3.恢复环境
History     :
"""
import time
import unittest

from testcase.utils.ComThread import ComThread
from testcase.utils.Common import Common
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger
from yat.test import Node
from yat.test import macro

LOGGER = Logger()
COMMONSH = CommonSH("PrimaryDbUser")
COSHROOT = CommonSH("PrimaryRoot")


@unittest.skipIf(1 == COMMONSH.get_node_num(),
                 'Single node, and subsequent codes are not executed.')
class Gstoolstestcase(unittest.TestCase):
    def setUp(self):
        LOGGER.info("==Opengauss_Function_Tools_gs_dropnode_Case0049 start==")
        self.constant = Constant()
        status = COMMONSH.get_db_cluster_status("detail")
        LOGGER.info(status)
        self.assertTrue("Normal" in status or "Degraded" in status)
        status = COMMONSH.restart_db_cluster()
        LOGGER.info(status)
        status = COMMONSH.get_db_cluster_status("detail")
        LOGGER.info(status)
        self.assertTrue("Normal" in status or "Degraded" in status)
        self.user_node = Node("PrimaryDbUser")
        self.s_node2 = Node("Standby2DbUser")
        self.com_root = CommonSH("PrimaryRoot")
        self.s_com1 = CommonSH("Standby1DbUser")
        self.s_com2 = CommonSH("Standby2DbUser")
        self.com = Common()

        LOGGER.info("查询synchronous_standby_names默认值")
        result = COMMONSH.execut_db_sql("show synchronous_standby_names")
        LOGGER.info(f"primary synchronous_standby_names is {result}")
        self.synchronous_standby_names_p = result.strip().splitlines()[-2]
        result = self.s_com1.execut_db_sql("show synchronous_standby_names")
        LOGGER.info(f"s1 synchronous_standby_names is {result}")
        self.synchronous_standby_names_s1 = result.strip().splitlines()[-2]
        result = self.s_com2.execut_db_sql("show synchronous_standby_names")
        LOGGER.info(f"s2 synchronous_standby_names is {result}")
        self.synchronous_standby_names_s2 = result.strip().splitlines()[-2]

    def test_tool(self):
        LOGGER.info("步骤1：1主2备，启线程1执行减容 根据减容和重启提示输入yes")
        result = COMMONSH.execut_db_sql(
            "select count(*) from pg_stat_get_wal_senders();")
        LOGGER.info(result)
        self.assertEqual("2", result.split("\n")[-2].strip())

        execute_cmd = f'''source {macro.DB_ENV_PATH};
                    expect <<EOF
                    set timeout 120
                    spawn gs_dropnode -U {self.user_node.ssh_user} \
                    -G {self.user_node.ssh_user} \
                    -h {self.s_node2.ssh_host}
                    expect "*drop the target node (yes/no)?*"
                    send "yes\\n"
                    expect eof\n''' + '''EOF'''
        LOGGER.info(execute_cmd)
        result = self.user_node.sh(execute_cmd).result()
        LOGGER.info(result)
        self.assertIn("Success to drop the target nodes", result)

        LOGGER.info("步骤2：减容同时备机执行stop 合理报错")
        result = self.s_com2.stop_db_cluster("")
        LOGGER.info(result)
        status = self.s_com2.get_db_cluster_status("detail")
        LOGGER.info(status)
        self.assertTrue("stopped" in status and "Normal" not in status)

        LOGGER.info("步骤3：核对减容成功 剩余1+1")
        result = self.s_com2.start_db_cluster("")
        LOGGER.info(result)
        status = COMMONSH.get_db_cluster_status("detail")
        LOGGER.info(status)
        self.assertTrue("Normal" in status or "Degraded" in status)
        result = COMMONSH.execut_db_sql(
            "select count(*) from pg_stat_get_wal_senders();")
        LOGGER.info(result)
        self.assertEqual("1", result.split("\n")[-2].strip())

    def tearDown(self):
        LOGGER.info("恢复环境 若用例失败 则检查节点 节点不为3时执行扩容")
        result = COMMONSH.restart_db_cluster()
        LOGGER.info(result)
        status = COMMONSH.get_db_cluster_status("detail")
        LOGGER.info(status)
        result = COMMONSH.execut_db_sql(
            "select count(*) from pg_stat_get_wal_senders();")
        LOGGER.info(result)
        if "2" != result.split("\n")[-2].strip():
            res = self.com_root.exec_expension(f"{self.user_node.ssh_user}",
                                               f"{self.user_node.ssh_user}",
                                               f"{self.s_node2.ssh_host}",
                                               f"{macro.DB_XML_PATH}")
            LOGGER.info(res)
            self.assertTrue(res)

        LOGGER.info("恢复各节点synchronous_standby_names")
        COMMONSH.execute_gsguc("reload",
                               self.constant.GSGUC_SUCCESS_MSG,
                               f"synchronous_standby_names="
                               f"'{self.synchronous_standby_names_p}'",
                               single=True)
        self.s_com1.execute_gsguc("reload",
                                  self.constant.GSGUC_SUCCESS_MSG,
                                  f"synchronous_standby_names="
                                  f"'{self.synchronous_standby_names_s1}'",
                                  single=True)
        self.s_com2.execute_gsguc("reload",
                                  self.constant.GSGUC_SUCCESS_MSG,
                                  f"synchronous_standby_names="
                                  f"'{self.synchronous_standby_names_s2}'",
                                  single=True)

        self.assertTrue("Normal" in status or "Degraded" in status)
        LOGGER.info("==Opengauss_Function_Tools_gs_dropnode_Case0049 finish=")
