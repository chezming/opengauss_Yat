-- @testpoint: 创建临时表，表名中有特殊字符,合理报错
-- @modify at: 2020-11-24
--建表，报错
drop table if exists temporary_#@!1;
create  temporary table temporary_#@!1(a int);


