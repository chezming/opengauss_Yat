-- @testpoint: 修改视图所属模式
--建表
drop table if exists table_view_016 cascade;
create table table_view_016(id int,name varchar(20));
insert into table_view_016 values(1,'hello'),(2,'world');
--创建模式
drop schema if exists schema_view_016;
create schema schema_view_016;
--创建视图
drop view if exists temp_view_016 cascade;
create view temp_view_016 as select * from table_view_016;
--修改视图所属模式
alter view temp_view_016 set schema schema_view_016;
--通过系统表查询视图信息
select schemaname,viewname from pg_views where viewname = 'temp_view_016';
--删除表
drop table table_view_016 cascade;
--删除模式
drop schema schema_view_016;