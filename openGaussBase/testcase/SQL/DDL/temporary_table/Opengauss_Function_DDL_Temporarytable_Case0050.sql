-- @testpoint: 创建有主键约束的临时表，违反约束，合理报错
-- @modify at: 2020-11-24
--建表
drop table if exists temp_table_050;
create  temporary table temp_table_050(a int primary key,b char);
--插入数据，报错
insert into temp_table_050 values(1,'a'),(1,'b');
--删表
drop table temp_table_050;


