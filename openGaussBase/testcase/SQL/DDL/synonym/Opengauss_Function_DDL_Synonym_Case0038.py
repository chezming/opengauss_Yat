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
Case Type   : 同义词
Case Name   : insert语句中使用自定义函数的同义词
Description :
        1.建表后插入数据并创建表的同义词
        2.创建函数并创建同义词
        3.insert中使用函数同义词
        4.清理环境
Expect      :
        1.建表且插入数据并创建表的同义词成功
        2.创建函数并创建同义词成功
        3.查询成功
        4.环境清理完成
History     :
"""
import sys
import unittest

sys.path.append(sys.path[0] + "/../")
from testcase.utils.Logger import Logger
from testcase.utils.Constant import Constant
from testcase.utils.CommonSH import CommonSH


class Synonym(unittest.TestCase):
    def setUp(self):
        self.log = Logger()
        self.log.info('-----------Opengauss_Function_DDL_Synonym_Case0038start------------')
        self.Constant = Constant()
        self.commonsh = CommonSH('dbuser')

    def test_synonym(self):
        # 建表1
        sql_cmd = self.commonsh.execut_db_sql('''drop table if exists SYN_TAB_038;
                                                create table SYN_TAB_038(id int,c_bigint bigint,c_bool boolean,c_number number(38, 0),c_dec decimal(38, 0),
                                                 c_float float,c_double DOUBLE PRECISION,c_real real,c_char char(128),c_varchar varchar(512),c_varchar2 varchar2(512),
                                                 c_date date,c_timestamp timestamp);''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.TABLE_CREATE_SUCCESS, sql_cmd)
        # 插入数据
        sql_cmd = self.commonsh.execut_db_sql('''
    begin
	    for i in 1..500 loop
		    insert into SYN_TAB_038 values(i,i+1,cast(cast(mod(i,2) as int)as boolean),i+2,i+3,i+4,i+5,i+6,'a'||i,'aa'||i,'中国'||i,'2019-06-27','2019-06-27 10:56:48');
	    end loop;
    end;''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.ANONYMOUS_BLOCK_EXECUTE_SUCCESS_MSG, sql_cmd)
        # 创建表1同义词
        sql_cmd = self.commonsh.execut_db_sql('''drop synonym if exists SYN_TAB_SYN_038;
                                               create or replace synonym  SYN_TAB_SYN_038 for SYN_TAB_038;''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.CREATE_SYNONYM_SUCCESS_MSG, sql_cmd)
        # 建表2
        sql_cmd = self.commonsh.execut_db_sql('''drop table if exists SYN_TAB_038_02;
                                               create table SYN_TAB_038_02(new_id int,c_uint bigint,c_clob clob,c_blob blob);''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.TABLE_CREATE_SUCCESS,sql_cmd)
        # 插入数据
        sql_cmd = self.commonsh.execut_db_sql('''
    begin
	   for i in 1..1000 loop
	   end loop;
    end;''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.ANONYMOUS_BLOCK_EXECUTE_SUCCESS_MSG, sql_cmd)
        # 创建表2同义词
        sql_cmd = self.commonsh.execut_db_sql('''drop synonym if exists SYN_TAB_SYN_038_02;
                                               create or replace  synonym  SYN_TAB_SYN_038_02 for SYN_TAB_038_02;''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.CREATE_SYNONYM_SUCCESS_MSG, sql_cmd)
        # 建表3
        sql_cmd = self.commonsh.execut_db_sql('''drop table if exists SYN_TAB_038_03;
                                               create table SYN_TAB_038_03(f_id int,f_int integer[],f_varchar varchar(30)[]);''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.TABLE_CREATE_SUCCESS, sql_cmd)
        # 插入数据
        sql_cmd = self.commonsh.execut_db_sql('''
    begin
	   for i in 1..1000 loop
		   insert into SYN_TAB_038_03 values (i,array[1,2,3,4,5],array['a','b','c','d','e']);
	   end loop;
    end;''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.ANONYMOUS_BLOCK_EXECUTE_SUCCESS_MSG, sql_cmd)
        # 创建表3同义词
        sql_cmd = self.commonsh.execut_db_sql('''drop synonym if exists SYN_TAB_SYN_038_03;
                                               create or replace  synonym  SYN_TAB_SYN_038_03 for SYN_TAB_038_03;''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.CREATE_SYNONYM_SUCCESS_MSG, sql_cmd)
        # 创建函数1
        sql_cmd = self.commonsh.execut_db_sql('''drop function if exists SYN_FUN_038(a varchar) cascade;
create or replace function SYN_FUN_038 (a varchar) return int
as
b int;
begin
	b:=length(a);
	return b;
end;''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.CREATE_FUNCTION_SUCCESS_MSG, sql_cmd)
        # 创建函数1同义词
        sql_cmd = self.commonsh.execut_db_sql('''drop synonym if exists SYN_FUN_SYN_038;
        create or replace  synonym  SYN_FUN_SYN_038 for SYN_FUN_038;''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.CREATE_SYNONYM_SUCCESS_MSG, sql_cmd)
        # 创建函数2
        sql_cmd = self.commonsh.execut_db_sql('''drop function if exists SYN_FUN_002_02(a varchar) cascade;
create or replace function SYN_FUN_002_02 (a varchar) return varchar
as
b varchar(1024);
begin
	b:=a||a;
	return b;
end;''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.CREATE_FUNCTION_SUCCESS_MSG, sql_cmd)
        # 创建函数2同义词
        sql_cmd = self.commonsh.execut_db_sql('''drop synonym if exists SYN_FUN_SYN_038_02;
        create or replace  synonym  SYN_FUN_SYN_038_02 for SYN_FUN_002_02;''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.CREATE_SYNONYM_SUCCESS_MSG, sql_cmd)
        # 创建函数3
        sql_cmd = self.commonsh.execut_db_sql('''drop function if exists SYN_FUN_038_03(a varchar) cascade;
create or replace function SYN_FUN_038_03(a number,str varchar) return varchar
as
	cur sys_refcursor;
	var varchar(1024);
	new_var varchar(1024):=str;
begin
	open cur for select str from dual;
	for i in 1..a loop
		fetch cur into var;
		exit when cur%notfound;
		new_var:=new_var||var;
	end loop;
	return new_var;
end;''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.CREATE_FUNCTION_SUCCESS_MSG, sql_cmd)
        # 创建函数3同义词
        sql_cmd = self.commonsh.execut_db_sql('''drop synonym if exists SYN_FUN_SYN_038_03;
                                               create or replace  synonym  SYN_FUN_SYN_038_03 for SYN_FUN_038_03;''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.CREATE_SYNONYM_SUCCESS_MSG, sql_cmd)
        # 查询
        sql_cmd = self.commonsh.execut_db_sql('''insert into  SYN_TAB_SYN_038
        (select f_id,SYN_FUN_SYN_038(c_varchar2),c_bool,c_number,c_dec,c_float,c_double,c_real,c_char, SYN_FUN_SYN_038_02(c_varchar),c_varchar2,c_date,c_timestamp
        from  SYN_TAB_SYN_038
        join SYN_TAB_SYN_038_02 on id=new_id
       join SYN_TAB_SYN_038_03  on new_id=f_id and SYN_FUN_SYN_038(SYN_FUN_SYN_038_02(c_varchar))=SYN_FUN_SYN_038(c_varchar2)*1 );''')
        self.log.info(sql_cmd)
        self.assertIn(self.Constant.INSERT_SUCCESS_MSG, sql_cmd)

    def tearDown(self):
        self.log.info('----------------恢复默认值-----------------------')
        sql = '''drop table if exists SYN_TAB_038 cascade;\
            drop table if exists SYN_TAB_038_02 cascade;\
            drop table if exists SYN_TAB_038_03 cascade;\
            drop function if exists SYN_FUN_038(a varchar) cascade;\
            drop function if exists SYN_FUN_002_02(a varchar) cascade;\
            drop function if exists \
            SYN_FUN_038_03(a number,str varchar) cascade;'''
        sql_cmd = self.commonsh.execut_db_sql(sql)
        self.log.info(sql_cmd)
        self.log.info('--------------Opengauss_Function_DDL_Synonym_Case0038执行完成---------------')