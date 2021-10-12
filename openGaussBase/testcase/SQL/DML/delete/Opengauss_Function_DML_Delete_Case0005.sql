--  @testpoint:delete语法中，WHERE condition使用逻辑操作符
drop table if exists t_delete05;
create table t_delete05(age int,salary numeric);
--插入数据
insert into t_delete05 values(25,8500);
insert into t_delete05 values(30,9500.50);
insert into t_delete05 values(45,6000);
--使用delete语句，where条件中使用and逻辑运算符，删除1条数据成功
delete FROM t_delete05 WHERE AGE >= 25 AND SALARY > 8500;
--使用delete语句，where条件中使用or逻辑运算符，删除1条数据
delete FROM t_delete05 WHERE AGE >30 or SALARY > 10000;
--使用delete语句,where条件中使用in,删除1条数据成功
delete FROM t_delete05 WHERE age in(20,25);
--使用delete语句,where条件中使用not in,删除0条数据
delete FROM t_delete05 WHERE age not in(30,45);
--删除表
drop table t_delete05;