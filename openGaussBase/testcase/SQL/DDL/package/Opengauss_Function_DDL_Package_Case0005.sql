-- @testpoint: 不指定schema,切换schema,创建package

--step1:创建schema1 expect:创建成功
drop schema if exists s_schema_test_0005_01;
create schema s_schema_test_0005_01;

--step2:切换当前模式为schema1 expect:切换成功
set current_schema=s_schema_test_0005_01;

--step3:不指定schema声明package expect:声明成功
create or replace package p_test_0005 is
var1 int:=1;
var2 int:=2;
procedure p_package_0005();
end p_test_0005;
/

--step4:定义包体 expect:定义成功
create or replace package body p_test_0005 is
procedure p_package_0005()
is
begin
drop table if exists t_package_0005;
create table t_package_0005(c_int int);
insert into t_package_0005 values(var1),(var2);
end;
end p_test_0005;
/

--step5:联合系统表gs_package,pg_namespace查询package所属的schema expect:返回新建schema1
select nspname from pg_namespace where oid = (select pkgnamespace from gs_package where pkgname = 'p_test_0005');

--step6:创建schema2 expect:创建成功
drop schema if exists s_schema_test_0005_02;
create schema s_schema_test_0005_02;

--step7:切换当前模式为schema2 expect:切换成功
set current_schema=s_schema_test_0005_02;

--step8:不指定schema声明package expect:声明成功
create or replace package p_test_0005_01 is
var1 int:=1;
var2 int:=2;
procedure p_package_0005();
end p_test_0005_01;
/

--step9:定义包体 expect:定义成功
create or replace package body p_test_0005_01 is
procedure p_package_0005()
is
begin
drop table if exists t_package_0005;
create table t_package_0005(c_int int);
insert into t_package_0005 values(var1),(var2);
end;
end p_test_0005_01;
/

--step10:联合系统表gs_package,pg_namespace查询package所属的schema expect:返回新建schema2
select nspname from pg_namespace where oid = (select pkgnamespace from gs_package where pkgname = 'p_test_0005_01');

--step11:清理环境 expect:清理成功
drop schema s_schema_test_0005_01 cascade;
drop schema s_schema_test_0005_02 cascade;