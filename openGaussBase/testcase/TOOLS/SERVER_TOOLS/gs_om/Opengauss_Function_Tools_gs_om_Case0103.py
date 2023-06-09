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
Case Type   : 系统内部工具
Case Name   : 数据库状态异常时(停止数据库备1节点),查询数据库状态及节点信息
Description :
    1、停止数据库备1节点,gs_ctl stop -D {dn1} -M standby
    2、结合--detail参数，查看数据库状态及节点详细信息，校验是否有port字段，校验备机IP是否发生变化，校验备机port端口号
    3、结合--all参数，查看数据库状态及所有节点信息，校验是否有port字段，校验备机IP是否发生变化，校验备机port端口号
    4、结合-h,-o参数，查看指定数据库节点状态及信息（-h指定切换后的备机），校验是否有输出文件，
       输出文件中是否有port字段，校验备机IP是否发生变化，校验备机port端口号
    5、query查询数据状态及相关信息，校验备机IP是否发生变化，校验备机port端口号
    6、恢复原有集群状态;
    7、清理环境;
Expect      :
    1、主节点停止成功;
    2、显示状态详细信息，原有主备状态发生改变，存在port字段，备机端口号正确（即原主机port为现备机port）
    3、显示数据库所有节点信息，原有主备状态发生改变，存在port字段，备机端口号正确（即原主机port为现备机port）
    4、显示指定节点状态信息，指定节点现为备机，存在port字段，端口号为原有主机port
    5、显示数据库状态信息，原有主备状态发生改变，存在port字段，备机端口号正确;
    6、恢复原有集群状态成功;
    7、清理环境成功;
History     :
"""

import os
import unittest
from yat.test import Node
from yat.test import macro
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

logger = Logger()
conf_path = os.path.join(macro.DB_INSTANCE_PATH, macro.DB_PG_CONFIG_NAME)
output_path = os.path.join(macro.DB_INSTANCE_PATH, 'output.txt')
primary_sh = CommonSH('PrimaryDbUser')


@unittest.skipIf(1 == primary_sh.get_node_num(),
                 'Single node, and subsequent codes are not executed.')
class Tools(unittest.TestCase):

    def setUp(self):
        logger.info("======Opengauss_Function_Tools_gs_om_Case0103开始执行======")
        self.commonsh = CommonSH('PrimaryDbUser')
        self.user_node = Node('PrimaryDbUser')
        self.standby_node = Node('Standby1DbUser')
        self.constant = Constant()

    def test_server_tools(self):
        logger.info("======获取端口信息======")
        sql_cmd = f'''show port;'''
        show_port_res = self.commonsh.execut_db_sql(sql_cmd)
        node_port = show_port_res.splitlines()[-2].strip()
        logger.info(node_port)

        logger.info("======步骤1:停止备1节点======")
        stop_cmd = f'''source {macro.DB_ENV_PATH};
            gs_ctl stop -D {macro.DB_INSTANCE_PATH} -M standby'''
        logger.info(stop_cmd)
        stop_res = self.standby_node.sh(stop_cmd).result()
        self.assertIn(self.constant.GS_CTL_STOP_SUCCESS_MSG, stop_res)

        logger.info("======步骤2:结合--detail参数，查看数据库状态及节点信息======")
        shell_res = self.commonsh.get_db_cluster_status(param='detail')
        logger.info(shell_res)

        logger.info("======校验port字段信息======")
        self.assertIn('port', shell_res.splitlines()[8])

        logger.info("======校验备机1状态stop & port正确======")
        self.assertTrue(self.constant.STOP_STATUS_MSG in
                        shell_res.splitlines()[11]
                        and node_port in shell_res.splitlines()[11])

        logger.info("======步骤3:结合--all参数，查看数据库状态及节点信息======")
        new_status_list = []
        new_port_list = []
        shell_res = self.commonsh.get_db_cluster_status(param='all')
        logger.info(shell_res)

        res = shell_res.splitlines()
        for param in res:
            if 'instance_role' in param:
                new_status_list.append(param)
            if 'instance_port' in param:
                new_port_list.append(param)
        logger.info(new_status_list)
        logger.info(new_port_list)

        logger.info("======备机1停止成功 && port正确======")
        try:
            if 'Down' in new_status_list[1]:
                logger.info("======备节点1停止成功======")
        except Exception as e:
            logger.info("======备节点1未停止成功======")
            raise e
        finally:
            logger.info("======备机状态校验完成======")

        try:
            if node_port == new_port_list[1].split(':')[1].strip():
                logger.info("======端口信息一致======")
        except Exception as e:
            logger.info("======端口信息不一致======")
            raise e
        finally:
            logger.info("======端口校验完成======")

        logger.info("======步骤4:结合-h,-o参数，-h指定备机1，查看状态信息======")
        shell_name = f'''hostname'''
        hostname = self.standby_node.sh(shell_name).result()
        logger.info(hostname)

        shell_res = self.commonsh.get_db_cluster_status(
            param='other', args=f'status -h {hostname} -o {output_path}')
        logger.info(shell_res)

        logger.info("======当前指定节点(备节点)状态为Down======")
        cat_res = self.user_node.sh(
            f'''cat {output_path} | grep instance_role''').result()
        logger.info(cat_res)
        self.assertIn('Down', cat_res)

        logger.info("======当前节点port正确======")
        port_res = self.user_node.sh(
            f'''cat {output_path} | grep instance_port''').result()
        logger.info(port_res)
        self.assertIn(node_port, port_res)

        logger.info("====步骤5:结合参数query，查看数据库状态信息，校验port字段，校验port端口====")
        shell_res = self.commonsh.get_db_cluster_status(param='other',
                                                        args='query')
        logger.info(shell_res)
        self.assertEqual('port', shell_res.splitlines()[8].split()[2].strip())

        logger.info("======备节点停止成功 && port端口正确======")
        self.assertTrue(self.constant.STOP_STATUS_MSG in
                        shell_res.splitlines()[11]
                        and node_port in shell_res.splitlines()[11])

        logger.info("======步骤6:恢复原有集群状态======")
        recovery_cmd = self.commonsh.restart_db_cluster(get_detail=True)
        logger.info(recovery_cmd)
        status = self.commonsh.get_db_cluster_status()
        self.assertTrue('Normal' in status)

    def tearDown(self):
        logger.info("======步骤7:清理环境======")
        clear_cmd = f'''rm -rf {output_path}'''
        logger.info(clear_cmd)
        self.user_node.sh(clear_cmd)

        status_msg = self.commonsh.get_db_cluster_status(param='detail')
        logger.info(status_msg)
        self.assertTrue('Normal' in status_msg.splitlines()[2])

        if 'Normal' not in status_msg.splitlines()[10]:
            recovery_cmd = self.commonsh.restart_db_cluster(get_detail=True)
            logger.info(recovery_cmd)
            status = self.commonsh.get_db_cluster_status()
            self.assertTrue('Normal' in status)
        else:
            logger.info("======主备节点正常======")
        logger.info("======Opengauss_Function_Tools_gs_om_Case0103执行结束======")
