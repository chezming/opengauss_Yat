-- @testpoint: 测试指定分区索引名与否对重建分区哈希索引的影响（后跟index关键字），部分step合理报错

--创建分区行存表
drop table if exists t_hash_index_0047;
create table t_hash_index_0047(id01 float(4),id02 char) with(orientation=row)
partition by range(id02)
(
    partition p01 values less than('g'),
    partition p02 values less than('n'),
    partition p03 values less than('z')
);

--创建哈希索引分区（指定分区名称）
create index i_hash_index_0047 on t_hash_index_0047 using hash(id02) local
(
    partition index_p01,
    partition index_p02,
    partition index_p03
);

--重建分区哈希索引（未指定分区名称）
reindex index i_hash_index_0047;

--重建分区哈希索引（指定分区名称）
reindex index i_hash_index_0047 partition index_p01;


--删除哈希索引
drop index i_hash_index_0047;

--删除表、表空间；
drop table t_hash_index_0047 cascade;