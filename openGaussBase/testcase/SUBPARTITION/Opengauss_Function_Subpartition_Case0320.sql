-- @testpoint: range_hash二级分区表：分区名称为超长/重复,部分测试点合理报错

--step1: 创建表空间; expect:成功
drop table if exists t_subpartition_0320;
drop tablespace if exists ts_subpartition_0320;
create tablespace ts_subpartition_0320 relative location 'subpartition_tablespace/subpartition_tablespace_0320';
drop tablespace if exists ts_subpartition_0320_01;
create tablespace ts_subpartition_0320_01 relative location 'subpartition_tablespace/subpartition_tablespace_0320_01';
--test1: 分区名称-名称超长
--step2: 创建二级分区表,二级分区名称超长; expect:成功
create table if not exists t_subpartition_0320
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0320
partition by range (col_1) subpartition by hash (col_2)
(
  partition p_range_1 values less than( -10 )
  (
    subpartition p_hash_1_1 ,
    subpartition p_hash_1_2 ,
     subpartition p_hash_1_3
  ),
  partition p_range_2 values less than( 20 ),
  partition p_range_3 values less than( 30)
  (
    subpartition p_hash_3_1 ,
    subpartition p_hash_3_2 ,
    subpartition p_hash_3_3
  ),
    partition p_range_4 values less than( 50)
  (
    subpartition p_hash_1_333333333333333333333333333333333333333333cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step3: 查询分区信息; expect:成功
select relname, parttype, partstrategy, indisusable from pg_partition where parentid = (select oid from pg_class where relname = 't_subpartition_0320') order by relname;
select a.relname,a.parttype,a.partstrategy,a.indisusable from pg_partition a,(select oid from pg_partition
where parentid = (select oid from pg_class where relname = 't_subpartition_0320')) b where a.parentid = b.oid order by a.relname;
--step4: 插入数据; expect:成功
insert into t_subpartition_0320 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(49,9,9,9);
insert into t_subpartition_0320 values(-11,1,1,1),(-15,5,5,5),(-81,8,8,8),(-19,9,9,9);
--step5: 查询一级分区数据; expect:成功
select * from t_subpartition_0320 partition(p_range_1);
--step6: 查询超长名称的二级分区数据; expect:成功
select * from t_subpartition_0320 subpartition(p_hash_1_333333333333333333333333333333333333333333cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc);


--test2: 分区名称-名称重复
--step7: 创建二级分区表,同一级分区中的二级分区名称重复; expect:合理报错
drop table if exists t_subpartition_0320;
create table if not exists t_subpartition_0320
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0320
partition by range (col_1) subpartition by hash (col_2)
(
  partition p_range_1 values less than( -10 )
  (
    subpartition p_hash_1_1 ,
    subpartition p_hash_1_1 ,
     subpartition p_hash_1_3
  ),
  partition p_range_2 values less than( 20 ),
  partition p_range_3 values less than( 30)
  (
    subpartition p_hash_3_1 ,
    subpartition p_hash_3_2 ,
    subpartition p_hash_3_3
  ),
    partition p_range_4 values less than( 50)
  (
    subpartition p_hash_4_1 ,
    subpartition p_hash_4_2 ,
    subpartition p_hash_4_3
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step8: 创建二级分区表,一级分区名称重复; expect:合理报错
drop table if exists t_subpartition_0320;
create table if not exists t_subpartition_0320
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0320
partition by range (col_1) subpartition by hash (col_2)
(
  partition p_range_1 values less than( -10 )
  (
    subpartition p_hash_1_1 ,
    subpartition p_hash_1_2 ,
     subpartition p_hash_1_3
  ),
  partition p_range_1 values less than( 20 ),
  partition p_range_3 values less than( 30)
  (
    subpartition p_hash_3_1 ,
    subpartition p_hash_3_2 ,
    subpartition p_hash_3_3
  ),
    partition p_range_4 values less than( 50)
  (
    subpartition p_hash_4_1 ,
    subpartition p_hash_4_2 ,
    subpartition p_hash_1_2
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step9: 创建二级分区表,二级分区名称和不同一级分区名称重复; expect:合理报错
drop table if exists t_subpartition_0320;
create table if not exists t_subpartition_0320
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0320
partition by range (col_1) subpartition by hash (col_2)
(
  partition p_range_1 values less than( -10 )
  (
    subpartition p_hash_1_1 ,
    subpartition p_hash_1_2 ,
     subpartition p_hash_1_3
  ),
  partition p_range_2 values less than( 20 ),
  partition p_range_3 values less than( 30)
  (
    subpartition p_hash_3_1 ,
    subpartition p_hash_3_2 ,
    subpartition p_hash_3_3
  ),
    partition p_range_4 values less than( 50)
  (
    subpartition p_hash_4_1 ,
    subpartition p_hash_4_2 ,
    subpartition p_range_1
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step10: 创建二级分区表,二级分区名称和列名重复; expect:成功
drop table if exists t_subpartition_0320;
create table if not exists t_subpartition_0320
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0320
partition by range (col_1) subpartition by hash (col_2)
(
  partition p_range_1 values less than( -10 )
  (
    subpartition p_hash_1_1 ,
    subpartition p_hash_1_2 ,
     subpartition p_hash_1_3
  ),
  partition p_range_2 values less than( 20 ),
  partition p_range_3 values less than( 30)
  (
    subpartition p_hash_3_1 ,
    subpartition p_hash_3_2 ,
    subpartition p_hash_3_3
  ),
    partition p_range_4 values less than( 50)
  (
    subpartition p_hash_4_1 ,
    subpartition p_hash_4_2 ,
    subpartition col_4
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step11: 创建二级分区表,二级分区名称和表名重复; expect:成功
drop table if exists t_subpartition_0320;
create table if not exists t_subpartition_0320
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0320
partition by range (col_1) subpartition by hash (col_2)
(
  partition p_range_1 values less than( -10 )
  (
    subpartition p_hash_1_1 ,
    subpartition p_hash_1_2 ,
     subpartition p_hash_1_3
  ),
  partition p_range_2 values less than( 20 ),
  partition p_range_3 values less than( 30)
  (
    subpartition p_hash_3_1 ,
    subpartition p_hash_3_2 ,
    subpartition p_hash_3_3
  ),
    partition p_range_4 values less than( 50)
  (
    subpartition t_subpartition_0320
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step12: 查询分区数据; expect:成功
select relname, parttype, partstrategy, indisusable from pg_partition where parentid = (select oid from pg_class where relname = 't_subpartition_0320') order by relname;
select a.relname,a.parttype,a.partstrategy,a.indisusable from pg_partition a,(select oid from pg_partition
where parentid = (select oid from pg_class where relname = 't_subpartition_0320')) b where a.parentid = b.oid order by a.relname;
--step13: 插入数据; expect:成功
insert into t_subpartition_0320 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(49,9,9,9);
insert into t_subpartition_0320 values(-11,1,1,1),(-15,5,5,5),(-81,8,8,8),(-19,9,9,9);
insert into t_subpartition_0320 values(41,1,1,1),(45,5,5,5),(48,8,8,8),(49,9,9,9);
--step14: 查询特殊分区数据; expect:成功
select * from t_subpartition_0320 subpartition(t_subpartition_0320);
 --step15: 查询普通分区数据; expect:成功
select * from t_subpartition_0320 subpartitn(t_subpartition_0320);

--step16: 清理环境; expect:成功
drop table if exists t_subpartition_0320;
drop tablespace if exists ts_subpartition_0320;