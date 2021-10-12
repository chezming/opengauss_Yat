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
Case Type   : 服务端工具
Case Name   : gs_dump工具显示帮助信息(正常)
Description :
    1.显示帮助信息(-？)
    2.显示帮助信息(--help)
Expect      :
    1.显示正确
    2.显示正确
History     :
"""
import unittest
from yat.test import Node
from yat.test import macro
from testcase.utils.Constant import Constant
from testcase.utils.Logger import Logger

LOG = Logger()


class Tools(unittest.TestCase):
    def setUp(self):
        LOG.info('---Opengauss_Function_Tools_gs_dump_Case0001start---')
        self.dbuser_node = Node('dbuser')
        self.constant = Constant()

    def test_server_tools(self):
        LOG.info('------------------显示帮助信息------------------')
        cmd_list = ['-?', '--help']
        for cmd in cmd_list:
            check_cmd1 = f'''source {macro.DB_ENV_PATH}
                        gs_dump {cmd}'''
            LOG.info(check_cmd1)
            msg1 = self.dbuser_node.sh(check_cmd1).result()
            LOG.info(msg1)
            LOG.info('--------------校验语法------------------')
            self.assertIn('gs_dump [OPTION]... [DBNAME]', msg1)
            LOG.info('--------------校验参数存在与否------------------')
            start_index = msg1.find('General options:')
            options_list = []
            for i in msg1[start_index:].split('\n'):
                for j in i.split(' '):
                    if len(j) != 0:
                        if j[0] == '-':
                            options_list.append(j)
                        else:
                            pass
                    else:
                        pass
            LOG.info(options_list)
            parameter = [
                '-f,', '--file=FILENAME', '-F,', '--format=c|d|t|p', '-v,',
                '--verbose', '-V,', '--version', '-Z,', '--compress=0-9',
                '--lock-wait-timeout=TIMEOUT', '-?,', '--help', '-a,',
                '--data-only', '-b,', '--blobs', '-c,', '--clean', '-C,',
                '--create', '-E,', '--encoding=ENCODING', '-n,',
                '--schema=SCHEMA', '-N,', '--exclude-schema=SCHEMA',
                '-o,', '--oids', '-O,', '--no-owner', '-s,', '--schema-only',
                '-S,', '--sysadmin=NAME', '-t,', '--table=TABLE', '-T,',
                '--exclude-table=TABLE', '--include-table-file=FileName',
                '--exclude-table-file=FileName', '-x,',
                '--no-privileges/--no-acl',
                '--column-inserts/--attribute-inserts',
                '--disable-dollar-quoting', '--disable-triggers',
                '--exclude-table-data=TABLE', '--inserts',
                '--no-security-labels', '--no-tablespaces',
                '--no-unlogged-table-data', '--include-alter-table',
                '--quote-all-identifiers', '--section=SECTION',
                '--serializable-deferrable', '--dont-overwrite-file',
                '--use-set-session-authorization', '--with-encryption=AES128',
                '--with-key=KEY', '--binary-upgrade',
                '--binary-upgrade-usermap="USER1=USER2"', '--non-lock-table',
                '--include-depend-objs', '--exclude-self',
                '-h,', '--host=HOSTNAME', '-p,', '--port=PORT', '-U,',
                '--username=NAME', '-w,', '--no-password', '-W,',
                '--password=PASSWORD', '--role=ROLENAME',
                '--rolepassword=ROLEPASSWORD']
            if len(options_list) == len(parameter):
                for opt in options_list:
                    if opt in parameter:
                        LOG.info(f'{opt}---------参数校验通过---------')
                    else:
                        LOG.error(f'{opt}---------参数校验不通过---------')
            else:
                LOG.error('---------参数校验有误---------')

    def tearDown(self):
        LOG.info('--------------无需清理环境-------------------')
        LOG.info('----Opengauss_Function_Tools_gs_dump_Case0001finish-----')
