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
Case Type   : 系统内部使用工具
Case Name   : 查看gs_probackup restore命令的摘要信息
Description :
    1.执行命令显示gs_probackup restore命令的摘要信息
Expect      :
    1.显示gs_probackup restore命令的摘要信息成功
History     :
"""

import unittest

from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger
from yat.test import Node
from yat.test import macro

LOG = Logger()


class SystemInternalTools(unittest.TestCase):
    def setUp(self):
        LOG.info('-------------------this is setup--------------------')
        LOG.info('-Opengauss_Function_Tools_Gs_Probackup_Case0028开始执行-')
        self.constant = Constant()
        self.PrimaryNode = Node('PrimaryDbUser')
        self.except_msg = ['gs_probackup restore -B backup-path '
                           '--instance=instance_name',
                           '[-D pgdata-path] [-i backup-id] [-j threads_num] '
                           '[--progress]',
                           '[--force] [--no-sync] [--no-validate]'
                           ' [--skip-block-validation]',
                           '[--external-mapping=OLDDIR=NEWDIR] '
                           '[-T OLDDIR=NEWDIR]',
                           '[--skip-external-dirs] [-I incremental_mode]',
                           '[--recovery-target-time=time|'
                           '--recovery-target-xid=xid',
                           '|--recovery-target-lsn=lsn|'
                           '--recovery-target-name=target-name]',
                           '[--recovery-target-inclusive=boolean]',
                           '[--remote-proto=protocol] '
                           '[--remote-host=destination]',
                           '[--remote-path=path] '
                           '[--remote-user=username]',
                           '[--remote-port=port] '
                           '[--ssh-options=ssh_options]',
                           '[--log-level-console=log-level-console]',
                           '[--log-level-file=log-level-file]',
                           '[--log-filename=log-filename]',
                           '[--error-log-filename=error-log-filename]',
                           '[--log-directory=log-directory]',
                           '[--log-rotation-size=log-rotation-size]',
                           '[--log-rotation-age=log-rotation-age]', '',
                           '-B, --backup-path=backup-path    '
                           'location of the backup storage area',
                           '--instance=instance_name     name of the instance',
                           '-D, --pgdata=pgdata-path        '
                           ' location of the database storage area',
                           '-i, --backup-id=backup-id        '
                           'backup to restore',
                           '-j, --threads=threads_num        '
                           'number of parallel threads',
                           '--progress                   show progress',
                           '--force                      '
                           'ignore invalid status of the restored backup',
                           '--no-sync                    '
                           'do not sync restored files to disk',
                           '--no-validate                '
                           'disable backup validation during restore',
                           '--skip-block-validation      '
                           'set to validate only file-level checksum',
                           '--external-mapping=OLDDIR=NEWDIR',
                           'relocate the external directory from '
                           'OLDDIR to NEWDIR',
                           '-T, --tablespace-mapping=OLDDIR=NEWDIR',
                           'relocate the tablespace from directory '
                           'OLDDIR to NEWDIR',
                           '--skip-external-dirs         '
                           'do not restore all external directories',
                           '-I, --incremental-mode=none|checksum|lsn',
                           'reuse valid pages available in '
                           'PGDATA if they have not changed',
                           '(default: none)', '', 'Recovery options:',
                           '--recovery-target-time=time  '
                           'time stamp up to which recovery will proceed',
                           '--recovery-target-xid=xid    '
                           'transaction ID up to which recovery will proceed',
                           '--recovery-target-lsn=lsn    '
                           'LSN of the write-ahead log location '
                           'up to which recovery will proceed',
                           '--recovery-target-name=target-name',
                           'the named restore point to which '
                           'recovery will proceed',
                           '--recovery-target-inclusive=boolean',
                           'whether we stop just after the recovery target',
                           '',
                           'Remote options:',
                           '--remote-proto=protocol      '
                           'remote protocol to use',
                           "available options: 'ssh', 'none' (default: ssh)",
                           '--remote-host=destination    '
                           'remote host address or hostname',
                           '--remote-port=port           '
                           'remote host port (default: 22)',
                           '--remote-path=path           '
                           'path to directory with gs_probackup '
                           'binary on remote host',
                           '(default: current binary path)',
                           '--remote-user=username       '
                           'user name for ssh connection '
                           '(default: current user)',
                           '--ssh-options=ssh_options    '
                           'additional ssh options (default: none)',
                           "(example: --ssh-options="
                           "'-c cipher_spec -F configfile')",
                           '',
                           'Logging options:',
                           '--log-level-console=log-level-console',
                           'level for console logging (default: info)',
                           "available options: 'off', 'error', "
                           "'warning', 'info', 'log', 'verbose'",
                           '--log-level-file=log-level-file',
                           'level for file logging (default: off)',
                           "available options: 'off', 'error', 'warning', "
                           "'info', 'log', 'verbose'",
                           '--log-filename=log-filename',
                           "filename for file logging "
                           "(default: 'pg_probackup.log')",
                           'support strftime format '
                           '(example: pg_probackup-%Y-%m-%d_%H%M%S.log)',
                           '--error-log-filename='
                           'error-log-filename',
                           'filename for error logging (default: none)',
                           '--log-directory=log-directory',
                           'directory for file logging '
                           '(default: BACKUP_PATH/log)',
                           '--log-rotation-size=log-rotation-size',
                           'rotate logfile if its size exceeds this value;'
                           ' 0 disables; (default: 0)',
                           "available units: 'kB', 'MB', 'GB', 'TB' "
                           "(default: kB)",
                           '--log-rotation-age=log-rotation-age',
                           'rotate logfile if its age exceeds this value; '
                           '0 disables; (default: 0)',
                           "available units: 'ms', 's', 'min', 'h', 'd' "
                           "(default: min)"]

    def test_system_internal_tools(self):
        LOG.info('step1 执行命令显示gs_probackup restore命令的摘要信息')
        help_cmd = f"source {macro.DB_ENV_PATH};" \
            f"gs_probackup restore --help;"
        LOG.info(help_cmd)
        help_msg = self.PrimaryNode.sh(help_cmd).result()
        LOG.info(help_msg)
        temp = help_msg.splitlines()
        options_list = []
        for j in temp:
            options_list.append(j.strip())
        LOG.info(options_list)
        self.assertEqual(options_list, self.except_msg)

    def tearDown(self):
        LOG.info('--------------this is tearDown--------------')
        # 无须清理环境
        LOG.info('-Opengauss_Function_Tools_Gs_Probackup_Case0028执行完成-')