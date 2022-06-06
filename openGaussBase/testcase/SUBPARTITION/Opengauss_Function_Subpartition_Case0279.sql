-- @testpoint: range_range二级分区表：rename约束/字段/分区/modify_clause,部分测试点合理报错

--step1: 创建表空间; expect:成功
drop table if exists t_subpartition_0279;
drop tablespace if exists ts_subpartition_0279;
create tablespace ts_subpartition_0279 relative location 'subpartition_tablespace/subpartition_tablespace_0279';

--test1: alter table rename --约束
--step2: 创建表空间; expect:成功
create   table if not exists t_subpartition_0279
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
	check (col_4 is not null)
)tablespace ts_subpartition_0279
partition by range (col_1) subpartition by range (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_range_1_1 values less than( 5 ),
    subpartition p_range_1_2 values less than( maxvalue )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_range_2_1 values less than( 5 ),
    subpartition p_range_2_2 values less than( 10 )
  )
) enable row movement;
--step3: 修改二级分区表，重命名约束; expect:成功
alter table t_subpartition_0279 rename  constraint t_subpartition_0279_col_4_check to drop_check;
--step4: 插入数据; expect:合理报错
insert into t_subpartition_0279 values(1,1,1,null);

--test2: alter table rename --字段
--step5: 创建二级分区表; expect:成功
drop table if exists t_subpartition_0279;
create   table if not exists t_subpartition_0279
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
	check (col_4 is not null)
)tablespace ts_subpartition_0279
partition by range (col_1) subpartition by range (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_range_1_1 values less than( 5 ),
    subpartition p_range_1_2 values less than( maxvalue )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_range_2_1 values less than( 5 ),
    subpartition p_range_2_2 values less than( 10 )
  )
) enable row movement;
--step6: 修改二级分区表，重命名非分区键; expect:成功
alter table t_subpartition_0279 rename column col_4 to col_4444;
--step7: 修改二级分区表，重命名分区键; expect:成功
alter table t_subpartition_0279 rename column col_2 to col_22222;
--step8: 原二级分区键创建唯一索引; expect:合理报错
 create unique index on t_subpartition_0279(col_2);

--test3: alter table rename --分区
--step9: 修改二级分区表，重命名二级分区; expect:合理报错
alter table t_subpartition_0279 rename partition p_range_2_2 to p_range_2_2222222;
--step10: 修改二级分区表，重命名一级分区; expect:合理报错
alter table t_subpartition_0279 rename partition p_range_2 to p_range_222222222_2;
--step11: 查看分区数据; expect:成功
select relname, parttype, partstrategy, boundaries from pg_partition where partstrategy !='n' and parentid = (select oid from pg_class where relname = 't_subpartition_0279') order by relname;
select a.relname,a.parttype,a.partstrategy,a.indisusable from pg_partition a,(select oid from pg_partition
where parentid = (select oid from pg_class where relname = 't_subpartition_0279')) b where a.parentid = b.oid order by a.relname;

--test4: alter table modify_clause
--step12: 创建表空间; expect:成功
drop table if exists t_subpartition_0279;
create   table if not exists t_subpartition_0279
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
	check (col_4 is not null)
)tablespace ts_subpartition_0279
partition by range (col_1) subpartition by range (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_range_1_1 values less than( 5 ),
    subpartition p_range_1_2 values less than( maxvalue )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_range_2_1 values less than( 5 ),
    subpartition p_range_2_2 values less than( 10 )
  )
) enable row movement;
--step13: 分区键创建唯一索引; expect:成功
 create index on t_subpartition_0279(col_1) local ;
--step14: 修改指定一级分区索引不可用; expect:合理报错
alter table t_subpartition_0279 modify partition p_range_2 unusable local indexes;
 
--step15: 清理环境; expect:成功
drop table if exists t_subpartition_0279;
drop tablespace if exists ts_subpartition_0279;