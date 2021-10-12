-- @testpoint: 创建临时视图,分别添加参数temp和temporary（退出会话，临时视图不存在）
--建表
drop table if exists table_view_005;
create table table_view_005(id int,name varchar(20));
--创建视图
drop view if exists temp_view_005 cascade;
create temp view temp_view_005 as select * from table_view_005;
--查询视图
select * from temp_view_005;
--插入数据
insert into table_view_005 values(1,'hello'),(2,'world');
insert into table_view_005 values(2344,'数据库'),(2,'测试');
--替换已有临时视图，添加or replace选项
create or replace temporary view temp_view_005 as select * from table_view_005;
--查询视图
select * from temp_view_005;
--删除视图
drop view temp_view_005;
--删表
drop table table_view_005;
