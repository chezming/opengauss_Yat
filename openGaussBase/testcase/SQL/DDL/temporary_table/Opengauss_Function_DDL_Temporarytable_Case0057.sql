-- @testpoint: 创建本地临时表，不使用if not exists，存在同名表，合理报错
--建表
drop table if exists temp_table_057;
create local temporary table if not  exists temp_table_057(
  t1 int,
  t2 blob
  );
--创建同名表，报错
create local temporary table  temp_table_057(
  t1 int,
  t2 blob
  );
--创建同名表
create temporary table if not  exists temp_table_057(
  t1 int,
  t2 blob
  );
--查询
select count(*) from temp_table_057;
--删表
drop table temp_table_057;