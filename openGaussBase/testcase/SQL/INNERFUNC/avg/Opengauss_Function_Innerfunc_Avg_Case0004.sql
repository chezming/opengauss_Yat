-- @testpoint: 运算表达式/函数表达式/比较表达式
drop table if exists t_function_1;
create table t_function_1(f0 bigint, f1 int, f2 double precision, f3 char(10), f4 varchar(10), f5 number(10,6), f6 date, f7 timestamp);
insert into t_function_1(f0, f1, f2, f3, f4, f5, f6, f7) values(null, null, 2.22, '5', 'test', 87.223, null, '2018-02-28 12:13:14.456');
insert into t_function_1(f0, f1, f2, f3, f4, f5, f6, f7) values(1, 2, 1.112233, '3', 'nebulaisok', 998.22222, '2018-01-31 12:13:14', null);
select avg(f0+f1+f2) from t_function_1;
select avg(2.4578*5+12.34655-5.83992) from sys_dummy limit 1;
select avg(-92.4567/3.87763+8.9999) from sys_dummy limit 1;
SELECT avg(sin(0.988271))AS RESULT from sys_dummy;
select avg(acos(-1)) AS RESULT from sys_dummy;
select avg(exp(3)) as RESULT from sys_dummy;
drop table if exists t_function_1;