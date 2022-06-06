-- @testpoint: Hash分区表结合 with 子句（ORIENTATION=ROW）

--step1：创建hash分区表 expect：成功
drop table if exists t_partition_hash_0065_01;
create table t_partition_hash_0065_01
(id                         number(7)
   constraint t_partition_hash_0065_01_id_nn not null,
 use_filename               varchar2(20),
 filename                   varchar2(255),
 text                       varchar2(2000)
  )with(orientation=row)
partition by hash(id)
(partition p1,
 partition p2);

--step2：插入数据 expect：成功插入一条数据
insert into t_partition_hash_0065_01 values(1,'李','李四','数学老师');

--step3：清理环境 expect：成功
drop table if exists t_partition_hash_0065_01;