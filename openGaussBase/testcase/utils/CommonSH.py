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

数据库执行公共函数

"""
import time
import os

from yat.test import Node
from yat.test import macro

from .Constant import Constant
from .Logger import Logger


class CommonSH:
    def __init__(self, node_name='dbuser'):
        """
        初始化
        :param node_name: 通过root用户还是数据库安装的用户执行脚本（见 conf/nodes.yml）
        """
        self.DB_INSTANCE_PATH = macro.DB_INSTANCE_PATH
        self.DB_ENV_PATH = macro.DB_ENV_PATH
        self.log = Logger()
        self.Constant = Constant()
        self.node = Node(node=node_name)

    def start_db_cluster(self, get_detail=False):
        """
        启动数据库集群
        return 停止是否成功
        """
        self.log.info("----start_db_cluster----")
        start_cmd = f'source {self.DB_ENV_PATH};gs_om -t start'
        self.log.info(start_cmd)
        start_msg = self.node.sh(start_cmd).result()
        self.log.info(start_msg)
        time.sleep(10)
        if get_detail:
            return start_msg
        else:
            return start_msg.find(self.Constant.START_SUCCESS_MSG) > -1

    def stop_db_cluster(self, command='', get_detail=False):
        """
        停止数据库集群
        return 启动是否成功
        """
        self.log.info("----stop_db_cluster----")
        stop_msg = self.node.sh(
            f'source {self.DB_ENV_PATH};gs_om -t stop {command}').result()
        self.log.info(stop_msg)
        time.sleep(3)
        if get_detail:
            return stop_msg
        else:
            return stop_msg.find(self.Constant.STOP_SUCCESS_MSG) > -1

    def restart_db_cluster(self, get_detail=False):
        """
        重启数据库集群
        return 重启是否成功
        """
        self.log.info("----restart_db_cluster----")
        restart_msg = self.node.sh(
            f'source {self.DB_ENV_PATH}; gs_om -t restart').result()
        self.log.info(restart_msg)
        time.sleep(3)
        if get_detail:
            return restart_msg
        else:
            flag = self.Constant.STOP_SUCCESS_MSG in restart_msg and \
                   self.Constant.START_SUCCESS_MSG in restart_msg
            return flag

    def get_db_cluster_status(self, param='info', args=''):
        """
        param="info":返回数据库集群状态概要信息
        param="status":返回数据库集群状态
        param="detail":返回数据库集群状态详细信息
        param="other":返回指定参数下集群状态信息
        """
        if param == 'status':
            body = f'source {self.DB_ENV_PATH};gs_om -t status --detail'
            res = self.node.sh(body).result()
            self.log.info(res)
            if "stopped" in res or "repair" in res or "Unknown" in res:
                return False
            else:
                return True
        elif param == 'info':
            cmd = f'source {self.DB_ENV_PATH};gs_om -t status'
            self.log.info(cmd)
            return self.node.sh(cmd).result()
        elif param == 'other':
            cmd = f'source {self.DB_ENV_PATH};gs_om -t {args}'
            self.log.info(cmd)
            return self.node.sh(cmd).result()
        else:
            cmd = f'source {self.DB_ENV_PATH};gs_om -t status --{param}'
            self.log.info(cmd)
            return self.node.sh(cmd).result()

    def start_db_instance(self, mode="primary"):
        """
        启动数据库实例
        :param mode: primary or standby
        """
        self.log.error("==start_db_instance==")
        msg = self.node.sh('source {};gs_ctl start -D {} -M {}'.format(
            self.DB_ENV_PATH, self.DB_INSTANCE_PATH, mode)).result()
        self.log.info(msg)
        time.sleep(10)
        return msg

    def stop_db_instance(self):
        """
        停止数据库实例
        """
        self.log.error("==stop_db_instance==")
        msg = self.node.sh('source {};gs_ctl stop -D {}'.format(
            self.DB_ENV_PATH, self.DB_INSTANCE_PATH)).result()
        self.log.info(msg)
        time.sleep(3)
        return msg

    def get_db_instance_status(self):
        """
        查询数据库状态
        返回： 正常运行 True  其他： False
        """
        self.log.error("==get Db Instance Status==")
        msg = self.node.sh('source {};gs_ctl status -D {}'.format(
            self.DB_ENV_PATH, self.DB_INSTANCE_PATH)).result()
        self.log.info(msg)
        return msg.find(self.Constant.INSTANCE_RUNNING) > -1

    def reload_db_config(self):
        """
        重新加载数据库配置文件 pg_hba.conf  postgresql.conf
        """
        self.log.error("==reload Db Instance Conf==")
        msg = self.node.sh('source {};gs_ctl reload -D {}'.format(
            self.DB_ENV_PATH, self.DB_INSTANCE_PATH)).result()
        self.log.info(msg)
        time.sleep(5)
        return msg

    def execut_db_sql(self, sql, sql_type='', dbname=None):
        """
        使用gsql的方式调用数据库sql语句
        :param sql: sql语句
        :param sql_type: 参数？
        :param dbname: 库名
        :return:
        """
        if dbname is None:
            database_name = self.node.db_name
        else:
            database_name = dbname
        shell = f'source {self.DB_ENV_PATH}; ' \
            f'gsql -d {database_name} ' \
            f'-p {self.node.db_port} ' \
            f'-r ' \
            f'-c "{sql}" ' \
            f'{sql_type}'
        msg = self.node.sh(shell).result()
        self.log.info(shell)
        return msg

    def execute_gsctl(self, command, assert_flag, param='', get_detail=False):
        """
        gs_ctl工具
        :param command: 例如'build'
        :param assert_flag: 例如'self.Constant.REBUILD_SUCCESS_MSG'
        :param param: 例如'-b full'
        :param get_detail: True返回详细信息，False返回bool值
        :return: 返回执行结果
        """
        self.log.info("----gs_ctl start execute----")
        gs_ctl_cmd = f"""
               source {self.DB_ENV_PATH}; 
               gs_ctl {command} -D {self.DB_INSTANCE_PATH} {param};
               """
        self.log.info(gs_ctl_cmd)
        show_msg = self.node.sh(gs_ctl_cmd).result()
        self.log.info(show_msg)
        time.sleep(5)
        if get_detail:
            return show_msg
        else:
            return show_msg.find(assert_flag) > -1

    def execute_gsguc(self, command, assert_flag, param, node_name='all',
                      get_detail=False, single=False):
        """
        gs_guc工具
        :param command: 例如'check'
        :param assert_flag: 例如self.Constant.GSGUC_SUCCESS_MSG
        :param param: 例如'max_connections'
        :param node_name: 节点名
        :param get_detail: True返回详细信息，False返回bool值
        :param single: True代表仅在本节点执行gs_guc命令，False在所有节点执行gs_guc命令
        :return: 返回执行结果
        """
        self.log.info("----gs_guc start execute----")
        if single:
            gs_guc_cmd = f'source {self.DB_ENV_PATH}; ' \
                f'gs_guc {command} ' \
                f'-D {self.DB_INSTANCE_PATH} ' \
                f'-c "{param}";'
        else:
            gs_guc_cmd = f'source {self.DB_ENV_PATH}; ' \
                f'gs_guc {command} ' \
                f'-N {node_name} ' \
                f'-D {self.DB_INSTANCE_PATH} ' \
                f'-c "{param}";'
        self.log.info(gs_guc_cmd)
        show_msg = self.node.sh(gs_guc_cmd).result()
        self.log.info(show_msg)
        time.sleep(5)
        if get_detail:
            return show_msg
        else:
            return show_msg.find(assert_flag) > -1

    def cycle_exec_sql(self, sql, count):
        """
        循环执行sql语句count次
        :param sql: 要执行的sql语句
        :param count: 执行次数
        :return: 执行完成返回True
        """
        try:
            for i in range(count):
                self.log.info(i)
                shell = f'source {self.DB_ENV_PATH}; ' \
                    f'gsql -d {self.node.db_name} ' \
                    f'-p {self.node.db_port} ' \
                    f'-r ' \
                    f'-c "{sql}" '
                self.log.info(shell)
                msg = self.node.sh(shell).result()
                self.log.info(msg)
        except:
            self.log.error('执行失败！')
            return False
        else:
            self.log.info('执行成功！')
            return True

    def restore_file(self, filename, cmd='-c', dbname=None):
        if dbname is None:
            dbname = self.node.db_name
        dump_cmd = f"source {self.DB_ENV_PATH};" \
            f"gsql -d {self.node.db_user} -p {self.node.db_port} -r " \
            f"-c 'select pg_sleep(0.5)';" \
            f"gs_restore -U '{self.node.db_user}' " \
            f"-W '{self.node.db_password}' " \
            f"-p {self.node.db_port} " \
            f"-d {dbname} '{filename}' " \
            f"{cmd}"
        dump_msg = self.node.sh(dump_cmd).result()
        return dump_msg

    def build_standby(self, mode='-b full'):
        dump_cmd = """
            source {source_path};
            gs_ctl build -D {db_path} {mode}""".format(
            source_path=self.DB_ENV_PATH,
            db_path=self.DB_INSTANCE_PATH,
            mode=mode)
        self.log.info(dump_cmd)
        build_msg = self.node.sh(dump_cmd).result()
        self.log.info(build_msg)
        return build_msg

    def restart_db_cluster_for_func(self, func):
        """
        使用gs_om重启数据库
        :return:
        """
        self.log.error("==restart_db_cluster==")
        restart_cmd = f'source {self.DB_ENV_PATH};gs_om -t restart'
        self.log.info(restart_cmd)
        msg = self.node.sh(restart_cmd).result()
        self.log.info(msg)
        if "Error" in msg or "FAILURE" in msg or "Failed" in msg:
            raise Exception('数据库重启失败，请检查！')

        time.sleep(10)

        get_status_cmd = f"source {self.DB_ENV_PATH};gs_om -t status --detail"
        self.log.info(get_status_cmd)
        msg = self.node.sh(get_status_cmd).result()
        self.log.info(msg)
        if "stopped" in msg or "repair" in msg or "Unknown" in msg:
            raise Exception('数据库状态异常，请检查！')

        return func

    def ensure_dbstatus_normal(self):
        """
        执行用例前确认数据库状态正常
        """
        db_details = self.get_db_cluster_status('details')
        # 考虑备机数据追赶情况，增加等待时间180s
        if "Catchup" in db_details \
                or ("Primary Normal" in db_details
                    and "Standby Need repair" in db_details):
            time.sleep(180)
            db_status = self.get_db_cluster_status('status')
            if not db_status:
                raise Exception("The status of db cluster is unnoraml. \
                    Please check! db_status: {}".format(db_status))
        # 数据库状态异常
        elif "stopped" in db_details \
                or "repair" in db_details \
                or "Unknown" in db_details:
            raise Exception("The status of db cluster is unnoraml. \
                            Please check!")

    def check_whether_need_build(self):
        """
        检查备机是否需要重建
        :return: True需要重建，False不需要
        """
        db_status = self.get_db_cluster_status('detail')
        if db_status.count('|') > 0:
            dest_str = db_status.splitlines()[-1].strip()
            dest_list = dest_str.split('|')
        else:
            dest_str = db_status.split('[ Datanode State ]')[-1].strip()
            dest_list = dest_str.splitlines()[2::]

        node_num = len(dest_list)
        standby_normal_num = db_status.count('Standby Normal')
        if int(standby_normal_num) == int(node_num) - 1:
            self.log.info(db_status)
            return False
        else:
            self.log.info(db_status)
            return True

    def check_connection_status(self, flag='', get_detail=False):
        """
        function:查询数据库可否使用gsql连接
        :param flag:期望的集群状态
        :param get_detail:为True时返回详情
        :return:返回查询结果或bool值
        """
        cmd = f'source {macro.DB_ENV_PATH};gs_om -t status --all'
        self.log.info(cmd)
        result = self.node.sh(cmd).result()
        self.log.info(result)
        if get_detail:
            return result
        else:
            status = result.splitlines()[2]
            return status.find(flag) > -1

    def get_standby_and_build(self):
        """
        function: 通过postgres.conf文件获取备机ip，ssh到备机后执行备机重建
        :return: 备机重建回显信息
        """
        conf_path = os.path.join(macro.DB_INSTANCE_PATH,
                                 macro.DB_PG_CONFIG_NAME)
        self.log.info('----获取备节点ip----')
        shell_cmd = f"cat {conf_path} | " \
            f"grep 'replconninfo' | " \
            f"grep -Ev '^#' | " \
            f"tr -s ' '| " \
            f"cut -d ' ' -f 7 | " \
            f"cut -d '=' -f 2"
        self.log.info(shell_cmd)
        msg = self.node.sh(shell_cmd).result()
        self.log.info(msg)
        standby_ip_list = msg.splitlines()

        self.log.info('----备机重建----')
        build_msg_list = list()
        for ip in standby_ip_list:
            shell_cmd = f'''ssh {ip} <<-EOF
                        source {macro.DB_ENV_PATH}
                        gs_ctl build -D {macro.DB_INSTANCE_PATH} -b full
                        exit\n''' + "EOF"
            self.log.info(shell_cmd)
            build_msg = self.node.sh(shell_cmd).result()
            build_msg_list.append(build_msg)

        return build_msg_list

    def check_location_consistency(self, node_type, node_num,
                                   max_wait_time=1800):
        """
        Function:判断主备数据是否同步
        :param ：node_type，传入主节点还是备节点，'primary'，'standby'
        :param ：node_num，集群个数，一主两备传入3，一主一备传入2
        :param ：max_wait_time，最多等待时长，单位：秒
        :return:返回True表明已经同步；False表明在规定时间内未同步
        """
        start_time = time.time()
        while True:
            query_msg = self.execute_gsctl('query', '', get_detail=True)
            result_list = list()
            assert_flag = True
            status_flag = True
            for arg in query_msg.splitlines():
                if 'sender_replay_location' in arg or \
                        'receiver_replay_location' in arg:
                    result_list.append(arg.strip())
            result_set = set(result_list)
            if len(result_set) > 0:
                if node_type == 'primary':
                    if len(result_set) * (node_num - 1) != len(result_list):
                        self.log.info('主备未同步')
                        db_status = self.get_db_cluster_status('detail')
                        self.log.info(db_status)
                        if 'Standby Need repair(WAL)' in db_status or \
                                'stopped' in db_status:
                            self.log.error('存在无法同步情况，请检查!')
                            status_flag = False
                        time.sleep(10)
                        assert_flag = False
                value_list = list()
                if assert_flag:
                    for arg in result_list:
                        value_list.append(arg.split(':')[-1].strip())
                    if value_list.count(value_list[0]) == len(result_list):
                        self.log.info('主备已同步')
                        return True
                    else:
                        self.log.info('主备未同步')
                        time.sleep(10)
            if len(result_set) == 0:
                db_status = self.get_db_cluster_status('detail')
                self.log.info(db_status)
                if 'Standby Need repair(WAL)' in db_status or \
                        'stopped' in db_status:
                    self.log.error('存在无法同步情况，请检查!')
                    status_flag = False

            if not status_flag:
                return False

            end_time = time.time()
            # 设置超时退出，避免死循环
            if end_time - start_time > max_wait_time:
                self.log.error('返回信息异常或数据同步仍未完成，请检查!')
                return False

    def wait_cluster_connected(self, dn_path=macro.DB_INSTANCE_PATH):
        """
        function:等待数据库主节点恢复，变为可连接状态
        :param dn_path:默认为macro文件中配置路径，可传入自定义值
        :return:1小时恢复为可连接True，否则False
        """
        cmd = f"source {macro.DB_ENV_PATH};gs_ctl query -D {dn_path}"
        for i in range(60):
            self.log.info(cmd)
            result = self.node.sh(cmd).result()
            self.log.info(result)
            lines = result.strip().splitlines()
            for line in lines:
                if 'detail_information' in line:
                    if 'Normal' in line:
                        self.log.info(line)
                        return True
                    else:
                        self.log.info(line)
                        break
            time.sleep(30)
        return False

    def get_sync_status(self):
        sender_replay_location = ''
        receiver_replay_location = ''
        query_msg = self.execute_gsctl('query', '', get_detail=True)
        test_list = query_msg.strip().splitlines()
        for ts in test_list:
            if 'sender_replay_location' in ts:
                sender_replay_location = ts.split(':')[-1].strip()
            elif 'receiver_replay_location' in ts:
                receiver_replay_location = ts.split(':')[-1].strip()

        return sender_replay_location, receiver_replay_location

    def check_data_consistency(self):
        start_time = time.time()
        while True:
            sender_replay_location, receiver_replay_location = \
                self.get_sync_status()
            if len(sender_replay_location) > 0 and \
                    len(receiver_replay_location) > 0:
                if sender_replay_location == receiver_replay_location:
                    self.log.info(
                        f'sender_replay_location: {sender_replay_location}')
                    self.log.info(
                        f'receiver_replay_location: {sender_replay_location}')
                    return True
            time.sleep(10)
            end_time = time.time()
            # 设置超时退出，避免死循环
            if end_time - start_time > 1800:
                self.log.error('gs_ctl query 返回信息异常或数据同步仍未完成，请检查!')
                return False

    def exec_refresh_conf(self):
        '''
        执行refreshconf
        :return:执行成功返回True，否则返回False
        '''
        self.log.info("==refreshconf start execute==")
        refresh_cmd = f"source {macro.DB_ENV_PATH}; gs_om -t refreshconf "
        self.log.info(refresh_cmd)
        refresh_msg = self.node.sh(refresh_cmd).result()
        self.log.info(refresh_msg)
        status = refresh_msg.find(self.Constant.refresh_success_msg) > -1
        time.sleep(5)
        return status

    def check_cascade_standby_consistency(self):
        '''
        Function: 查询级联备同步情况
        :return: 同步返回True否则返回False
        '''
        cmd = f"source {macro.DB_ENV_PATH};gs_om -t status --all"
        self.log.info(cmd)
        result = self.node.sh(cmd).result()
        self.log.info(result)
        list_tmp = result.split('----------------------------------------')
        flg_cascade = 0
        flg_standby = 0
        for i in range(len(list_tmp) - 1):
            if 'Cascade Standby' in list_tmp[i]:
                detail_list = list_tmp[i].strip().splitlines()
                for j in range(len(detail_list) - 1):
                    if 'receiver_replay_location' in detail_list[j]:
                        receiver_replay_location = \
                            detail_list[j].strip().split(':')[1]
                        self.log.info(f"receiver_replay_location "
                                      f"is {receiver_replay_location}")
                        flg_cascade = flg_cascade + 1
            elif ': Standby' in list_tmp[i]:
                detail_list = list_tmp[i].strip().splitlines()
                for j in range(len(detail_list) - 1):
                    if 'sender_replay_location' in detail_list[j]:
                        sender_replay_location = \
                            detail_list[j].strip().split(':')[1]
                        self.log.info(f"sender_replay_location "
                                      f"is {sender_replay_location}")
                        flg_standby = flg_standby + 1
        if flg_standby > 0 and flg_cascade > 0:
            if sender_replay_location == receiver_replay_location:
                return True
        else:
            return False

    def exec_expension(self, user, group, host, xml, para="-L", detail=False):
        '''
        执行gs_expension
        host :对应-h 表示待扩容节点
        para :默认为-L 可传入为其他值
        user :对应-U 数据库安装用户
        group :对应-G 数据库属主
        xml :对应-X 数据库xml文件
        detail:False则返回扩容成功或失败，True则返回扩容执行结果
        return:执行成功返回True，否则返回False 如果detail为真返回执行详细结果
        '''

        # 如果在备机上对集群进行安装 则需要在主机上解压安装包以执行扩容
        result = self.node.sh(f"ls {macro.DB_SCRIPT_PATH}").result()
        self.log.info(result)
        if "gs_expansion" not in result:
            result = self.node.sh(f"cd {macro.DB_SCRIPT_PATH}/../;"
                f"tar -zxvf openGauss-*.tar.gz > /dev/null").result()
            self.log.info(result)
            result = self.node.sh(f"ls {macro.DB_SCRIPT_PATH}").result()
            self.log.info(result)
            if "gs_expansion" not in result:
                self.log.info("cat not find gs_expansion, Please check!")
                return False

        execute_cmd = f'''source {macro.DB_ENV_PATH};
                cd {macro.DB_SCRIPT_PATH}
                expect <<EOF
                set timeout 600
                spawn ./gs_expansion -U {user} \
                -G {group} \
                -h {host} -X {xml} {para}
                expect eof\n''' + '''EOF'''
        self.log.info(execute_cmd)
        result = self.node.sh(execute_cmd).result()
        self.log.info(result)
        time.sleep(5)
        # detail默认为False 返回扩容成功或失败 detail为True时返回扩容执行结果
        if detail:
            return result
        else:
            return result.find("Expansion Finish") > -1

    def get_node_num(self):
        """
        判断备机数量
        :return:返回备机数量
        """
        db_status = self.get_db_cluster_status('detail')
        if db_status.count('|') > 0:
            dest_str = db_status.splitlines()[-1].strip()
            dest_list = dest_str.split('|')
        else:
            dest_str = db_status.split(']')[-1].strip()
            dest_list = dest_str.splitlines()[2::]

        node_num = len(dest_list)
        return node_num