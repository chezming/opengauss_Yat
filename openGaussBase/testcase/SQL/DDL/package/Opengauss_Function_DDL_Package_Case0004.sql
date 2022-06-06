-- @testpoint: 创建package指定schema

--step1:创建schema expect:创建成功
drop schema if exists s_package_0004;
create schema s_package_0004;

--step2:指定schema声明package expect:声明成功
create or replace package s_package_0004.p_test_0004 is
var1 int:=1;
var2 int:=2;
procedure p_package_0004();
end p_test_0004;
/

--step3:定义包体 expect:定义成功
create or replace package body s_package_0004.p_test_0004 is
procedure p_package_0004()
is
begin
drop table if exists t_package_0004;
create table t_package_0004(c_int int);
insert into t_package_0004 values(var1),(var2);
end;
end p_test_0004;
/

--step4:联合系统表gs_package,pg_namespace查询package所属的schema expect:返回新建schema
select nspname from pg_namespace where oid = (select pkgnamespace from gs_package where pkgname = 'p_test_0004');

--step5:清理环境 expect:清理环境成功
drop schema s_package_0004 cascade;