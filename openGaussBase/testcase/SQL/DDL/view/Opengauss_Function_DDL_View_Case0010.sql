-- @testpoint: 创建视图,为视图指定一个可选的参数
--建表
drop table if exists table_view_010;
create table table_view_010(id int,name varchar(20));
--插入数据
insert into table_view_010 values(1,'hello'),(2,'world');
--创建视图
drop view if exists temp_view_010;
create view temp_view_010(id) with(security_barrier = true) as select * from table_view_010;
--查询视图
select * from temp_view_010;
--security_barrier为false，创建视图
create or replace view temp_view_010(id) with(security_barrier = false) as select * from table_view_010;
--security_barrier为0,创建视图
create or replace view temp_view_010(id) with(security_barrier = 0) as select * from table_view_010;
--security_barrier为1,创建视图
create or replace view temp_view_010(id) with(security_barrier = 1) as select * from table_view_010;
--删表
drop table table_view_010 cascade;