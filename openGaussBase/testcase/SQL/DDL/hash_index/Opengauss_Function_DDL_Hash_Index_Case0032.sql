-- @testpoint: 测试新名称缺省与否对修改哈希索引的影响，部分step合理报错

--创建表
drop table if exists t_hash_index_0032;
create table t_hash_index_0032(id01 int,id02 char) with (orientation=row);

--创建哈希索引
create index i_hash_index_0032_01 on t_hash_index_0032 using hash(id01);
create index i_hash_index_0032_02 on t_hash_index_0032 using hash(id02);

--修改哈希索引(新名称未缺省)
alter index if exists i_hash_index_0032_01 rename to i_hash_index_0032_03;
--修改哈希索引(新名称缺省)
alter index if exists i_hash_index_0032_02 rename to   ;

--删除哈希索引
drop index if exists i_hash_index_0032_01;
drop index if exists i_hash_index_0032_02;
drop index if exists i_hash_index_0032_03;

--删除表、表空间
drop table t_hash_index_0032 cascade;
