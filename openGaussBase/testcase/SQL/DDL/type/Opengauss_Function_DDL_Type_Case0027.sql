--  @testpoint:改变一种复合类型中某个属性的类型，省略SET DATA选项
--创建类型
drop type if exists test3_type cascade;
create type test3_type as(a int,b text);
--改变一种复合类型中某个属性的类型，省略SET DATA
ALTER TYPE test3_type ALTER ATTRIBUTE b TYPE date;
--建表
drop table if exists test_t2 cascade;
create table test_t2 (id int,d test3_type);
--插入数据
insert into test_t2 values(1,(1,'2020-10-31'));
--查询
select * from test_t2;
--删除表
drop table if exists test_t2 cascade;
--删除类型
drop type if exists test3_type cascade;