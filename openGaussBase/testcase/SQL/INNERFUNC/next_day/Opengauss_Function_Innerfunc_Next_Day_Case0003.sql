-- @testpoint: next_day函数参数1的边界值测试
select next_day('0001-01-01 00:00:00',1) from sys_dummy;
select next_day('9999-12-31 23:59:59',1) from sys_dummy;