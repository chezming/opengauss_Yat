-- @testpoint: 表达式存为目标类型

--建表
drop table if exists test_cast_0026 cascade;
create table test_cast_0026(c_varchar varchar,c_int4 int4);

--查询转换计划
--test point：无已注册的转换函数,隐式转换
explain performance insert into test_cast_0026(c_varchar) values('test26'||'test26');

--testpoint：调用已注册的转换函数
explain performance insert into test_cast_0026(c_int4) values(cast('26'::reltime as int4));

--testpoint：调用已注册的转换函数
explain performance insert into test_cast_0026(c_int4) values(cast (cast('26' as reltime) as int4));

--清理环境
drop table if exists test_cast_0026 cascade;