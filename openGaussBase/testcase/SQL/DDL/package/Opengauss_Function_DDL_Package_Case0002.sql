-- @testpoint: 创建package后使用replace参数,重新声明package,不重新定义package body调用package,合理报错

--step1:声明包规格 expect:声明包规格成功
create or replace package p_test_0002 is
var1 int:=1;
var2 int:=2;
procedure p_package_0002();
end p_test_0002;
/

--step2:定义包体 expect:定义包体成功
create  or replace package body p_test_0002 is
procedure p_package_0002()
is
begin
drop table if exists t_package_0002;
create table t_package_0002(c_int int);
insert into t_package_0002 values(var1),(var2);
end;
end p_test_0002;
/

--step3:使用replace参数,声明重名package expect:声明成功
create or replace package p_test_0002 is
var3 int:=1;
procedure p_package_0002(var4 int);
end p_test_0002;
/

--step4:查询系统表gs_package中p_test_0002对应的包规格内容 expect:返回重新声明的包规格内容
select pkgspecsrc from gs_package where pkgname = 'p_test_0002';

--step5:调用package expect:合理报错
call p_test_0002.p_package_0002();

--step6:清理环境 expect:清理环境成功
drop package p_test_0002;