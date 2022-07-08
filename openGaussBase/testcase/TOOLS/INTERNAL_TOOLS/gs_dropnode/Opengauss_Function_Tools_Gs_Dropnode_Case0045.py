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
Case Name   : 主备切换后在新主机上对原主机进行减容
Description :
    1.下载解压数据库安装包
    2.配置xml文件
    3.创建用户并修改文件属性
    4.gs_preinstall预安装：
    ./gs_preinstall -U [初始用户] -G [初始用户组] -X [xml配置文件路径]
    --sep-env-file=[env文件路径] --skip-hostname-set --non-interactive
    5.gs_install安装数据库：
    gs_install -X [xml配置文件路径]
    6.进行switchover切换主备
    7.在新主上对原主执行gs_dropnode进行减容：
    ./gs_dropnode -U {usrname} -G {grp_name} -h {hostname}
    8.清理环境
    清理用户下进程
    删除数据库相关目录并删除用户
Expect      :
    1.下载解压成功
    2.配置成功
    3.用户创建成功且文件属性修改成功
    4.预安装成功
    5.数据库安装成功
    6.主备切换成功
    7.减容成功
    8.清理成功
History     :
"""
import os
import re
import unittest
from testcase.utils.Common import Common
from testcase.utils.Common import CommonSH
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger
from yat.test import Node
from yat.test import macro
primary_sh = CommonSH('PrimaryDbUser')
Constant = Constant()


@unittest.skipIf(3 != primary_sh.get_node_num(), '非1+2环境不执行')
class Tools(unittest.TestCase):
    def setUp(self):
        self.log = Logger()
        self.common = Common()
        self.log.info(f'----{os.path.basename(__file__)} start----')
        self.primary_root_node = Node('PrimaryRoot')
        self.primary_node = Node('PrimaryDbUser')
        self.standby1_root_node = Node('Standby1Root')
        self.standby2_root_node = Node('Standby2Root')
        self.u_name = os.path.basename(__file__)[:-3].split('Tools_')[-1]
        self.pri_host = self.primary_node.db_host
        self.sta1_host = self.standby1_root_node.db_host
        self.sta2_host = self.standby2_root_node.db_host
        self.ssh_file = os.path.join('/home', self.u_name, 'hostfile')
        self.path = macro.DB_INSTANCE_PATH.split('/')[1]
        self.openGauss_path = os.path.join('/', f'{self.path}',
                                           f'{self.u_name}')
        self.package_path = os.path.join(self.openGauss_path, 'pkg')
        self.conf_path = os.path.join(self.openGauss_path, 'config')
        self.data_path = os.path.join(self.openGauss_path, 'cluster')
        self.xml_path = os.path.join(self.conf_path,
                                     'primary_standby1_standby2.xml')
        self.env_path = os.path.join(self.conf_path, 'env')
        self.script_path = os.path.join(self.package_path, 'script')
        self.instance_path = os.path.join(self.data_path, 'dn1')
        wget_result = self.primary_node.sh(f"wget {macro.FTP_PATH} "
                                           f"-c -t2 -T30").result()
        res = re.search(Constant.wget_connect_success_msg, wget_result)
        self.log.info(res)
        if not re.search(Constant.wget_connect_success_msg, wget_result):
            raise Exception('wget连接失败')

    def test_gs_dropnode(self):
        text = '----step1:下载解压数据库安装包 expect:下载解压成功----'
        self.log.info(text)
        self.common.check_load_msg(self.primary_root_node, self.primary_node,
                                   self.package_path, self.conf_path)
        text = '----查看主机名----'
        self.log.info(text)
        primary_node_name = self.primary_root_node.sh("uname -n").result()
        standby1_node_name = self.standby1_root_node.sh("uname -n").result()
        standby2_node_name = self.standby2_root_node.sh("uname -n").result()
        self.log.info(primary_node_name)
        self.log.info(standby1_node_name)
        self.log.info(standby2_node_name)
        self.assertIsNotNone(primary_node_name, '执行失败:' + text)
        self.assertIsNotNone(standby1_node_name, '执行失败:' + text)
        self.assertIsNotNone(standby2_node_name, '执行失败:' + text)
        text = '----查询系统未使用端口----'
        self.log.info(text)
        for count in range(5):
            port = self.common.get_not_used_port(self.primary_node)
            self.log.info(port)
            standby_port_check_cmd = f'netstat -tlnp | grep {port}'
            sta1_check_msg = self.standby1_root_node.sh(
                standby_port_check_cmd).result()
            sta2_check_msg = self.standby2_root_node.sh(
                standby_port_check_cmd).result()
            if not (sta1_check_msg or sta2_check_msg):
                self.assertNotEqual(0, port, '执行失败:' + text)
                break
            else:
                continue

        text = '----step2:配置xml文件 expect:配置成功----'
        self.log.info(text)
        gaussdb_app_path = os.path.join(self.data_path, 'app')
        gaussdb_log_path = os.path.join(self.data_path, 'gaussdb_log')
        tmpmppdb_path = os.path.join(self.data_path, 'tmp')
        gaussdb_tool_path = os.path.join(self.data_path, 'tool')
        self.common.scp_file(self.primary_root_node,
                             'primary_standby1_standby2.xml',
                             self.conf_path)
        xml_cmd = \
            f"sed -i " \
            f"'s#v_nodeNames#{primary_node_name}, {standby1_node_name}, " \
            f"{standby2_node_name}#g' " \
            f"{self.xml_path};" \
            f"sed -i 's#v_gaussdbAppPath#{gaussdb_app_path}#g' " \
            f"{self.xml_path};" \
            f"sed -i 's#v_gaussdbLogPath#{gaussdb_log_path}#g' " \
            f"{self.xml_path};" \
            f"sed -i 's#v_tmpMppdbPath#{tmpmppdb_path}#g' " \
            f"{self.xml_path};" \
            f"sed -i 's#v_gaussdbToolPath#{gaussdb_tool_path}#g' " \
            f"{self.xml_path};" \
            f"sed -i 's#v_corePath#{macro.DB_CORE_PATH}#g' " \
            f"{self.xml_path};" \
            f"sed -i 's#v_db_host#{self.pri_host}, {self.sta1_host}, " \
            f"{self.sta2_host}#g' " \
            f"{self.xml_path};" \
            f"sed -i 's#v_pri_nodeNames#{primary_node_name}#g' " \
            f"{self.xml_path};" \
            f"sed -i 's#v_pri_db_host#{self.pri_host}#g' " \
            f"{self.xml_path};" \
            f"sed -i 's#v_dataPortBase#{port}#g' " \
            f"{self.xml_path};" \
            f"sed -i 's#v_dataNode1#" \
            f"{self.instance_path}, {standby1_node_name}, " \
            f"{self.instance_path}, {standby2_node_name}, " \
            f"{self.instance_path}#g' {self.xml_path};" \
            f"sed -i 's#v_sta1_nodeNames#{standby1_node_name}#g' " \
            f"{self.xml_path};" \
            f"sed -i 's#v_sta1_db_host#{self.sta1_host}#g' " \
            f"{self.xml_path};" \
            f"sed -i 's#v_sta2_nodeNames#{standby2_node_name}#g' " \
            f"{self.xml_path};" \
            f"sed -i 's#v_sta2_db_host#{self.sta2_host}#g' " \
            f"{self.xml_path};" \
            f"cat {self.xml_path}"
        self.log.info(xml_cmd)
        xml_result = self.primary_root_node.sh(xml_cmd).result()
        self.log.info(xml_result)
        msg_list = [primary_node_name, standby1_node_name, standby2_node_name,
                    self.data_path, f"{port}", self.pri_host, self.sta1_host,
                    self.sta2_host]
        for content in msg_list:
            self.assertIn(content, xml_result, '执行失败:' + text)

        text = '----step3:创建用户并修改文件属性 expect:成功----'
        self.log.info(text)
        self.common.create_user(self.primary_root_node, self.u_name)
        file_own = f'chown -R {self.u_name}:{self.u_name} {self.openGauss_path}'
        self.log.info(file_own)
        file_msg = self.primary_root_node.sh(file_own).result()
        self.log.info(file_msg)
        self.assertEqual('', file_msg, '执行失败:' + text)

        text = '----step4:执行gs_preinstall命令 expect:预安装成功----'
        self.log.info(text)
        preinstall_cmd = f'./gs_preinstall -U {self.u_name} ' \
                         f'-G {self.u_name} -X {self.xml_path}' \
                         f' --sep-env-file={self.env_path} --skip-hostname-set '
        execute_cmd = f'''cd {self.script_path}
                           expect <<EOF
                           set timeout 300
                           spawn {preinstall_cmd}
                           expect "*(yes/no)?"
                           send "yes\\n"
                           expect "Password:"
                           send "{self.primary_root_node.ssh_password}\\n"
                           expect "*(yes/no)?"
                           send "yes\\n"
                           expect "Password:"
                           send "{macro.COMMON_PASSWD}\\n"
                           expect "Password:"
                           send "{macro.COMMON_PASSWD}\\n"
                           expect "Password:"
                           send "{macro.COMMON_PASSWD}\\n"
                           expect eof\n''' + '''EOF'''
        self.log.info(execute_cmd)
        msg = self.primary_root_node.sh(execute_cmd).result()
        self.log.info(msg)
        self.assertIn(Constant.preinstall_success_msg, msg,
                      '执行失败:' + text)

        text = '----step5:执行gs_install安装数据库 expect:安装成功----'
        self.log.info(text)
        su_cmd = f'su - {self.u_name}'
        install_cmd = f'gs_install -X {self.xml_path}'
        execute_cmd = f'''expect <<EOF
                   set timeout 200
                   spawn {su_cmd}
                   expect "$"
                   send "source {self.env_path}\\n"
                   expect "$"
                   send "{install_cmd}\\n"
                   expect "Please enter password for database:"
                   send "{macro.COMMON_PASSWD}\\n"
                   expect "Please repeat for database:"
                   send "{macro.COMMON_PASSWD}\\n"
                   expect eof\n''' + '''EOF'''
        self.log.info(execute_cmd)
        exec_msg = self.primary_root_node.sh(execute_cmd).result()
        self.log.info(exec_msg)
        self.assertIn(Constant.install_success_msg, exec_msg, text + '执行失败')

        text = '----step6:执行switchover进行主备切换 expect:成功----'
        self.log.info(text)
        switch_cmd = f"su - {self.u_name} <<EOF\n" \
                     f"source {self.env_path};" \
                     f"gs_ctl switchover -D {self.instance_path};" \
                     f"gs_om -t refreshconf;" \
                     f"gs_om -t stop && gs_om -t start\n" \
                     f"EOF"
        self.log.info(switch_cmd)
        switch_res = self.standby1_root_node.sh(switch_cmd).result()
        self.log.info(switch_res)
        for msg in [Constant.SWITCHOVER_SUCCESS_MSG,
                    Constant.REFRESH_SUCCESS_MSG, Constant.START_SUCCESS_MSG]:
            self.assertIn(msg, switch_res, '主备切换失败')

        text = '----step7:执行gs_dropnode进行备机减容 expect:成功'
        self.log.info(text)
        drop_cmd = f'gs_dropnode -U {self.u_name} -G {self.u_name} ' \
                   f'-h {self.pri_host}'
        self.log.info(drop_cmd)
        shell_path = f'/home/{self.u_name}/dropnode.sh'
        shell_cmd = f'touch {shell_path};echo -e {drop_cmd} > {shell_path};' \
                    f'chmod 755 {shell_path};cat {shell_path}'
        self.log.info(shell_cmd)
        shell_res = self.standby1_root_node.sh(shell_cmd).result()
        self.log.info(shell_res)
        drop_cmd = f'''expect <<EOF
                       set timeout 60
                       spawn su - {self.u_name}
                       expect "$"
                       send "source {self.env_path}\\n"
                       expect "$"
                       send "{shell_path}\\n"
                       expect "(yes/no)?"
                       send "yes\\n"
                       expect eof\n''' + '''EOF'''
        self.log.info(drop_cmd)
        drop_res = self.standby1_root_node.sh(drop_cmd).result()
        self.log.info(drop_res)
        self.assertIn('Success to drop the target nodes', drop_res,
                      text + '减容失败')

        self.log.info('检查数据库是否减容')
        check_cmd = f'su - {self.u_name} <<EOF\n' \
                    f'source {self.env_path};' \
                    f'gs_om -t status --detail;\n' \
                    f'EOF'
        self.log.info(check_cmd)
        check_res = self.standby1_root_node.sh(check_cmd).result()
        self.log.info(check_res)
        self.assertNotIn(self.pri_host, check_res, '数据库状态检查失败')

    def tearDown(self):
        text = "----step8:清理进程及缓存，清理用户及文件 expect:成功----"
        self.log.info(text)
        text_2 = '-----删除用户下进程 expect:成功-----'
        self.log.info(text_2)
        kill_cmd = f"ps -u {self.u_name} | grep -v PID | " \
                   f"awk \'{{{{print $1}}}}\' | xargs kill -9;" \
                   f"ipcs -m|awk '{{{{if($3~/^[0-9]+$/) {{{{print $2}}}}}}}}'" \
                   f" | xargs -I {{{{}}}} ipcrm -m {{{{}}}};" \
                   f"ipcs -s|awk '{{{{if($3~/^[0-9]+$/) {{{{print $2}}}}}}}}'" \
                   f" | xargs -I {{{{}}}} ipcrm -s {{{{}}}};sync;" \
                   f"echo 3 > /proc/sys/vm/drop_caches"
        self.log.info(kill_cmd)
        self.common.get_sh_result(self.primary_root_node, kill_cmd)
        self.common.get_sh_result(self.standby1_root_node, kill_cmd)
        self.common.get_sh_result(self.standby2_root_node, kill_cmd)
        text_3 = '----删除用户及数据准备目录 expect:成功----'
        self.log.info(text_3)
        dir_del_cmd = f'rm -rf {self.openGauss_path}'
        self.log.info(dir_del_cmd)
        self.primary_root_node.sh(dir_del_cmd).result()
        self.standby1_root_node.sh(dir_del_cmd).result()
        self.standby2_root_node.sh(dir_del_cmd).result()
        check_cmd = f'if [ -d {self.openGauss_path} ]; ' \
                    f'then echo "exists"; else echo "not exists"; fi'
        self.log.info(check_cmd)
        pri_del_dir_msg = self.common.get_sh_result(self.primary_root_node,
                                                    check_cmd)
        sta1_del_dir_msg = self.common.get_sh_result(self.standby1_root_node,
                                                     check_cmd)
        sta2_del_dir_msg = self.common.get_sh_result(self.standby2_root_node,
                                                     check_cmd)
        usr_del_cmd = f'userdel -rf {self.u_name};id {self.u_name}'
        self.log.info(usr_del_cmd)
        pri_del_usr_msg = self.primary_root_node.sh(usr_del_cmd).result()
        sta1_del_usr_msg = self.standby1_root_node.sh(usr_del_cmd).result()
        sta2_del_usr_msg = self.standby2_root_node.sh(usr_del_cmd).result()
        for msg in [pri_del_dir_msg, sta1_del_dir_msg, sta2_del_dir_msg]:
            self.assertEqual('not exists', msg, '目录删除失败:' + text_3)
        for msg in [pri_del_usr_msg, sta1_del_usr_msg, sta2_del_usr_msg]:
            self.log.info(msg)
            self.assertIn('no such user', msg, '用户删除失败' + text_3)
        self.log.info(f'----{os.path.basename(__file__)} finish----')