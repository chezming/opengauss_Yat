-- @testpoint: replace函数给定字符串为算术表达式
select replace(56+23*100,'23','xx') as result from sys_dummy;