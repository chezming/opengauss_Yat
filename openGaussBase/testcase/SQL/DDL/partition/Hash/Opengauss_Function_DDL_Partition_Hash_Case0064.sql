-- @testpoint: Hash分区表结合 with 子句（COMPRESSION=YES）合理报错

--step1：创建hash分区表 expect：合理报错
drop table if exists t_partition_hash_0064_01;
create table t_partition_hash_0064_01
(id                         number(7),
 use_filename               varchar2(20)
)with(compression=yes)
partition by hash(id)
(partition p1,
 partition p2);