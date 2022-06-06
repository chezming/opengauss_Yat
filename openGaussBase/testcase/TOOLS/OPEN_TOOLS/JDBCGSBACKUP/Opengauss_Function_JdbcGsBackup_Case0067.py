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
Case Type   : openGauss-tools-backup
Case Name   : 主节点导出过程中停止备节点，-h主节点
Description :
        1.创建工具所在目录
        2.获取工具安装包并解压
        3.创建数据库
        4.指定数据库下建用户，建表
        5.修改信任方式为sha256
        6.主节点导出过程停止备节点
        7.删表导入
        8.重启集群并检查数据库状态
        9.主备查询导入的表
        10.清理环境
Expect      :
        1.创建成功
        2.解压成功
        3.创建成功
        4.创建成功
        5.修改成功
        6.停止备节点成功；导出成功
        7.导入成功
        8.重启集群成功，数据库状态正常
        9.表导入成功，数据正确
        10.清理环境完成
"""
import os
import unittest

from testcase.utils.ComThread import ComThread
from testcase.utils.Common import Common
from testcase.utils.CommonSH import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger
from yat.test import Node
from yat.test import macro

COMMONSH = CommonSH("PrimaryDbUser")


@unittest.skipIf(1 == COMMONSH.get_node_num(), "单机不执行")
class ToolsBackup(unittest.TestCase):
    def setUp(self):
        self.log = Logger()
        self.pri_sh = CommonSH('PrimaryDbUser')
        self.standby_sh = CommonSH('Standby1DbUser')
        self.log.info(
            '---Opengauss_Function_JdbcGsBackup_Case0067start---')
        self.constant = Constant()
        self.DB_ENV_PATH = macro.DB_ENV_PATH
        self.Primary_Node = Node('PrimaryDbUser')
        self.Root_Node = Node('PrimaryRoot')
        self.com = Common()
        self.package = os.path.join(
            os.path.dirname(macro.DB_INSTANCE_PATH), 'package_tool')
        self.db_name = "db_jdbcgsbackup_0067"
        self.user = "u_jdbcgsbackup_0067"
        self.tb_name = "t_jdbcgsbackup_0067"
        text = '---备份主节点pg_hba.conf文件---'
        self.log.info(text)
        cmd = f"cp {os.path.join(macro.DB_INSTANCE_PATH, 'pg_hba.conf')}  " \
              f"{os.path.join(macro.DB_INSTANCE_PATH, 'pg_hba.conf_t_bak')}"
        self.log.info(cmd)
        msg = self.Primary_Node.sh(cmd).result()
        self.log.info(msg)

    def test_tools_backup(self):
        text = '----step1:创建工具所在目录;expect:创建成功----'
        self.log.info(text)
        mkdir_cmd = f'''if [ ! -d "{self.package}" ]
                        then
                            mkdir -p {self.package}
                        fi'''
        self.log.info(mkdir_cmd)
        result = self.Primary_Node.sh(mkdir_cmd).result()
        self.log.info(result)
        self.assertEqual(result, '', '执行失败:' + text)

        text = '----step2:获取openGauss-tools-backup工具包并解压 ' \
               'expect:解压成功----'
        self.log.info(text)
        sql_cmd = f'''wget -P {self.package} {macro.PACKAGE_URL};
            cd {self.package};
            tar -zxvf openGauss-tools-backup.tar.gz;'''
        self.log.info(sql_cmd)
        result = self.Primary_Node.sh(sql_cmd).result()
        self.log.info(result)
        self.assertIn(f"‘{self.package}/openGauss-tools-backup.tar.gz’ saved"
                      , result, '执行失败:' + text)

        text = '-----step3:创建数据库;expect:创建成功----'
        self.log.info(text)
        sql_cmd = self.pri_sh.execut_db_sql(f'''drop database if exists \
            {self.db_name};
            create database {self.db_name};''')
        self.log.info(sql_cmd)
        self.assertIn(self.constant.CREATE_DATABASE_SUCCESS, sql_cmd,
                      '执行失败:' + text)

        text = '---step4:创建测试用户,创建表;expect:创建成功---'
        self.log.info(text)
        sql_cmd = f'''drop user if exists {self.user};
            create user {self.user} with sysadmin \
            password '{macro.COMMON_PASSWD}';
            drop table if  exists {self.tb_name};
            create table {self.tb_name} (id int);
            insert into {self.tb_name} values (generate_series(1,1000000));'''
        self.log.info(sql_cmd)
        sql_result = self.pri_sh.execut_db_sql(sql=sql_cmd,
                                               dbname=f'{self.db_name}')
        self.log.info(sql_result)
        self.assertIn(self.constant.TABLE_CREATE_SUCCESS, sql_result,
                      '执行失败:' + text)
        self.assertIn(self.constant.CREATE_ROLE_SUCCESS_MSG, sql_result,
                      '执行失败:' + text)

        text = '---step5:修改主节点信任方式为sha256;expect:修改成功---'
        self.log.info(text)
        cmd = f"grep -nr '127.0.0.1/32' " \
              f"{os.path.join(macro.DB_INSTANCE_PATH, 'pg_hba.conf')}"
        self.log.info(cmd)
        line = self.Primary_Node.sh(
            cmd).result().splitlines()[0].split(':')[0]
        self.log.info(line)
        cmd = f'sed -i "{str(int(line)+1)} ihost   all     all ' \
              f'{self.Primary_Node.db_host}/32   sha256" ' \
              f'{os.path.join(macro.DB_INSTANCE_PATH, "pg_hba.conf")}; ' \
              f'cat {os.path.join(macro.DB_INSTANCE_PATH, "pg_hba.conf")};'
        self.log.info(cmd)
        result = self.Primary_Node.sh(cmd).result()
        self.log.info(result)
        restart_msg = self.pri_sh.restart_db_cluster()
        self.log.info(restart_msg)
        status = self.pri_sh.get_db_cluster_status()
        self.assertTrue("Degraded" in status or "Normal" in status)
        self.assertIn(f'{self.Primary_Node.db_host}/32   sha256', result,
                      '执行失败:' + text)

        text = '---step6:主节点导出时停止备节点;expect:导出成功---'
        self.log.info(text)
        sql_cmd = f'''cd {self.package}/openGauss-tools-backup;\
            java -jar openGauss-tools-backup.jar \
            -m dump \
            -d {self.db_name} \
            -h {self.Primary_Node.db_host} \
            -p {self.Primary_Node.db_port} \
            -U {self.user} \
            -P {macro.COMMON_PASSWD} \
            -s public'''
        self.log.info(sql_cmd)
        connect_thread1 = ComThread(
            self.com.get_sh_result, args=(Node('PrimaryDbUser'), sql_cmd))
        connect_thread1.setDaemon(True)
        connect_thread1.start()

        text = '---step6.1:停止备节点;expect:备节点停止成功---'
        self.log.info(text)
        result = self.standby_sh.stop_db_instance()
        self.log.info(result)
        self.assertTrue(result, '执行失败:' + text)

        text = '---step6.2:获取step6结果;expect:导出成功---'
        self.log.info(text)
        connect_thread1.join(60 * 10)
        thread1_result = connect_thread1.get_result()
        self.log.info(thread1_result)
        self.assertIn(self.constant.jdbcgsbackup_success, thread1_result,
                      '执行失败:' + text)
        self.assertNotIn(self.constant.jdbcgsbackup_failed[0] and
                         self.constant.jdbcgsbackup_failed[1] and
                         self.constant.jdbcgsbackup_failed[2], thread1_result,
                         '执行失败:' + text)

        text = 'step7:---删除表导入session1结果;expect:导入成功---'
        self.log.info(text)
        sql_cmd = f'''drop table {self.tb_name};'''
        sql_result = self.pri_sh.execut_db_sql(sql=sql_cmd,
                                               dbname=f'{self.db_name}')
        self.log.info(sql_result)
        self.assertIn(self.constant.DROP_TABLE_SUCCESS, sql_result,
                      '执行失败:' + text)
        sql_cmd = f'''cd {self.package}/openGauss-tools-backup;\
            java -jar openGauss-tools-backup.jar \
            -m restore \
            -d {self.db_name} \
            -h {self.Primary_Node.db_host} \
            -p {self.Primary_Node.db_port} \
            -U {self.user} \
            -P {macro.COMMON_PASSWD} \
            -s public \
            -n public'''
        self.log.info(sql_cmd)
        msg = self.Primary_Node.sh(sql_cmd).result()
        self.log.info(msg)
        self.assertIn(self.constant.jdbcgsbackup_success, msg,
                      '执行失败:' + text)
        self.assertNotIn(self.constant.jdbcgsbackup_failed[0] and
                         self.constant.jdbcgsbackup_failed[1] and
                         self.constant.jdbcgsbackup_failed[2], msg,
                         '执行失败:' + text)

        text = '---step8:重启集群并检查数据库状态;expect:重启集群成功-- '
        self.log.info(text)
        result = self.pri_sh.restart_db_cluster()
        self.log.info(result)
        result = self.pri_sh.get_db_cluster_status('detail')
        self.log.info(result)
        self.assertTrue("Degraded" in result or "Normal" in result,
                        '执行失败:' + text)

        text = '---step9:主备分别查询导入表;expect:查询成功-- '
        self.log.info(text)
        sql_cmd = f'''select count(*) from {self.tb_name};'''
        sql_result = self.pri_sh.execut_db_sql(sql=sql_cmd,
                                               dbname=f'{self.db_name}')
        self.log.info(sql_result)
        self.assertEqual('1000000', sql_result.splitlines()[2].strip())
        sql_cmd = f'''select count(*) from {self.tb_name};'''
        sql_result = self.standby_sh.execut_db_sql(sql=sql_cmd,
                                                   dbname=f'{self.db_name}')
        self.log.info(sql_result)
        self.assertEqual('1000000', sql_result.splitlines()[2].strip())

    def tearDown(self):
        text = 'step10:---清理环境;expect:清理环境完成---'
        self.log.info(text)
        sql_cmd = f'''rm -rf {self.package};'''
        self.log.info(sql_cmd)
        result = self.Root_Node.sh(sql_cmd).result()
        self.log.info(result)
        cmd = f"rm -rf " \
              f"{os.path.join(macro.DB_INSTANCE_PATH, 'pg_hba.conf')};" \
              f"mv " \
              f"{os.path.join(macro.DB_INSTANCE_PATH, 'pg_hba.conf_t_bak')} " \
              f"{os.path.join(macro.DB_INSTANCE_PATH, 'pg_hba.conf')}"
        self.log.info(cmd)
        self.Primary_Node.sh(cmd)
        sql_cmd = self.pri_sh.execut_db_sql(f'''drop database if exists \
            {self.db_name};;
            drop user if exists {self.user} cascade;''')
        self.log.info(sql_cmd)
        self.log.info(
            '---Opengauss_Function_JdbcGsBackup_Case0067finish---')
