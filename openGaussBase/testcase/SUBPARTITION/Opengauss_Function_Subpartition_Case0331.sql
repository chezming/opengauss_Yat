-- @testpoint: range_hash二级分区表：modify_clause/exchange/merge into/move/insert on duplicate key update,部分测试点合理报错

--step1: 创建表空间; expect:成功
drop table if exists t_subpartition_0331;
drop tablespace if exists ts_subpartition_0331;
create tablespace ts_subpartition_0331 relative location 'subpartition_tablespace/subpartition_tablespace_0331';

--test1: alter table modify_clause
--step2: 创建二级分区表; expect:成功
create   table if not exists t_subpartition_0331
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
	check (col_4 is not null)
)tablespace ts_subpartition_0331
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
	subpartition t_subpartition_0331
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step3: 创建索引; expect:成功
create index on t_subpartition_0331(col_1) local ;
--step4: 修改索引不可用; expect:合理报错
alter table t_subpartition_0331 modify partition p_range_2 unusable local indexes;

--test2: alter table exchange
--step5: 创建二级分区表; expect:成功
drop table if exists t_subpartition_0331;
create   table if not exists t_subpartition_0331
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
	check (col_4 is not null)
)tablespace ts_subpartition_0331
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
	subpartition t_subpartition_0331
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step6: 创建普通表; expect:成功
drop table if exists t_subpartition_0331_01;
create   table if not exists t_subpartition_0331_01
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
	check (col_4 is not null)
)tablespace ts_subpartition_0331;
--step7: 普通表插入数据; expect:成功
insert into t_subpartition_0331_01 values(1,11,1,1),(4,41,4,4),(5,54,5,5),(8,87,8,8),(9,19,9,9);
--step8: 把普通表的数据迁移到二级分区表; expect:合理报错
alter table t_subpartition_0331 exchange partition (p_range_1) with table t_subpartition_0331_01 without validation;
--step9: 查询二级分区表数据; expect:成功，无数据
select * from t_subpartition_0331;
--step10: 查询普通表数据; expect:成功，有数据
select * from t_subpartition_0331_01;

--test3: alter table  merge into
--step11: 修改二级分区表，把多个一级分区合并为一个一级分区; expect:合理报错
alter table t_subpartition_0331 merge partitions p_range_1,p_range_2 into partition p_range_8;

--test4: alter table  move
--step12: 创建表空间; expect:成功
drop tablespace if exists ts_subpartition_0331_01;
create tablespace ts_subpartition_0331_01 relative location 'subpartition_tablespace/subpartition_tablespace_0331_01';
--step13: 修改二级分区表，移动一级分区到新的表空间; expect:合理报错
alter table t_subpartition_0331 move partition p_range_2 tablespace ts_subpartition_0331_01;

--test5: alter table  add partition
--step14: 修改二级分区表，添加和原有一级分区同名的一级分区; expect:合理报错
alter table t_subpartition_0331 add partition p_range_3 values less than( 30 ); 

--step15: 创建二级分区表; expect:成功
drop table if exists t_subpartition_0331 cascade;
create   table if not exists t_subpartition_0331
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
	check (col_4 is not null)
)tablespace ts_subpartition_0331
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
	subpartition t_subpartition_0331
  )
) enable row movement;
--step16: 修改分区范围; expect:合理报错
alter table t_subpartition_0331 add partition p_range_3 values less than( 50 );
--step17: 查询分区信息; expect:成功
select relname,parttype,partstrategy,indisusable,interval from pg_partition where parentid = (select oid from pg_class where relname = 't_subpartition_0331') order by relname;
select a.relname,a.parttype,a.partstrategy,a.indisusable from pg_partition a,(select oid from pg_partition
where parentid = (select oid from pg_class where relname = 't_subpartition_0331')) b where a.parentid = b.oid order by a.relname;

--step18: 清理环境; expect:成功
drop table if exists t_subpartition_0331_01;
drop table if exists t_subpartition_0331 cascade;
drop tablespace if exists ts_subpartition_0331;
drop tablespace if exists ts_subpartition_0331_01;