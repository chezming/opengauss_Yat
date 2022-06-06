-- @testpoint: 测试创建哈希索引时，是否支持fillfactor及fillfactor参数边界值情况，部分step合理报错

--创建表
drop table if exists t_hash_index_0063;
create table t_hash_index_0063
(
    id01 varchar,
    id02 char(20) not null
) 
with(orientation=row);

--创建哈希索引(是否支持fillfactor)
create index i_hash_index_0063_01 on t_hash_index_0063 using hash(id01) with(fillfactor=70);

--创建哈希索引(fillfactor参数不在正常范围内)
create index i_hash_index_0063_02 on t_hash_index_0063 using hash(id02) with(fillfactor=101);
create index i_hash_index_0063_03 on t_hash_index_0063 using hash(id02) with(fillfactor=9);

--创建哈希索引(fillfactor参数边界值)
create index i_hash_index_0063_04 on t_hash_index_0063 using hash(id02) with(fillfactor=99);
create index i_hash_index_0063_05 on t_hash_index_0063 using hash(id02) with(fillfactor=11);

--删除哈希索引
drop index if exists i_hash_index_0063_01;
drop index if exists i_hash_index_0063_02;
drop index if exists i_hash_index_0063_03;
drop index if exists i_hash_index_0063_04;
drop index if exists i_hash_index_0063_05;

--删除表、表空间
drop table t_hash_index_0063 cascade;
