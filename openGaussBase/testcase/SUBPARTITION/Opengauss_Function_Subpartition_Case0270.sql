-- @testpoint: range_range二级分区表：分区名称为超长/重复,部分测试点合理报错

--step1: 创建表空间; expect:成功
drop table if exists t_subpartition_0270;
drop tablespace if exists ts_subpartition_0270;
create tablespace ts_subpartition_0270 relative location 'subpartition_tablespace/subpartition_tablespace_0270';
drop tablespace if exists ts_subpartition_0270_01;
create tablespace ts_subpartition_0270_01 relative location 'subpartition_tablespace/subpartition_tablespace_0270_01';
--test1: 分区名称-名称超长
--step2: 创建二级分区表,二级分区名称超长; expect:成功
create   table if not exists t_subpartition_0270
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0270
partition by range (col_1) subpartition by range (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_range_1_21111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111 values less than( 5 ),
    subpartition p_range_1_2 values less than( maxvalue )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_range_2_1 values less than( 5 ),
    subpartition p_range_2_2 values less than( 10 )
  )
) enable row movement;
--step3: 查询分区信息; expect:成功
select relname, parttype, partstrategy, indisusable from pg_partition where parentid = (select oid from pg_class where relname = 't_subpartition_0270') order by relname;
select a.relname,a.parttype,a.partstrategy,a.indisusable from pg_partition a,(select oid from pg_partition
where parentid = (select oid from pg_class where relname = 't_subpartition_0270')) b where a.parentid = b.oid order by a.relname;
--step4: 插入数据; expect:成功
insert into t_subpartition_0270 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
--step5: 查询一级分区数据; expect:成功
select * from t_subpartition_0270 partition(p_range_1);
--step6: 查询超长名称的二级分区数据; expect:成功
select * from t_subpartition_0270 subpartition(p_range_1_21111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111);

--test2: 分区名称-名称重复
--step7: 创建二级分区表,同一级分区中的二级分区名称重复; expect:合理报错
drop table if exists t_subpartition_0270;
create   table if not exists t_subpartition_0270
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0270
partition by range (col_1) subpartition by range (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_range_1_2 values less than( 5 ),
    subpartition p_range_1_2 values less than( maxvalue )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_range_2_1 values less than( 5 ),
    subpartition p_range_2_2 values less than( 10 )
  )
) enable row movement;
--step8: 创建二级分区表,二级分区名称和同一一级分区名称重复; expect:合理报错
drop table if exists t_subpartition_0270;
create   table if not exists t_subpartition_0270
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0270
partition by range (col_1) subpartition by range (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_range_1 values less than( 5 ),
    subpartition p_range_1_2 values less than( maxvalue )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_range_2_1 values less than( 5 ),
    subpartition p_range_2_2 values less than( 10 )
  )
) enable row movement;
--step9: 创建二级分区表,二级分区名称和不同一级分区名称重复; expect:合理报错
drop table if exists t_subpartition_0270;
create   table if not exists t_subpartition_0270
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0270
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
    subpartition p_range_1 values less than( 10 )
  )
) enable row movement;
--step10: 创建二级分区表,一级分区名称重复; expect:合理报错
drop table if exists t_subpartition_0270;
create   table if not exists t_subpartition_0270
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0270
partition by range (col_1) subpartition by range (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_range_1_1 values less than( 5 ),
    subpartition p_range_1_2 values less than( maxvalue )
  ),
  partition p_range_1 values less than( 20 )
  (
    subpartition p_range_2_1 values less than( 5 ),
    subpartition t_subpartition_0270 values less than( 10 )
  )
) enable row movement;
--step11: 创建二级分区表,二级分区名称和表名重复; expect:成功
drop table if exists t_subpartition_0270;
create   table if not exists t_subpartition_0270
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0270
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
    subpartition t_subpartition_0270 values less than( 10 )
  )
) enable row movement;
--step12: 查询数据; expect:成功
select relname, parttype, partstrategy, indisusable from pg_partition where parentid = (select oid from pg_class where relname = 't_subpartition_0270') order by relname;
select a.relname,a.parttype,a.partstrategy,a.indisusable from pg_partition a,(select oid from pg_partition
where parentid = (select oid from pg_class where relname = 't_subpartition_0270')) b where a.parentid = b.oid order by a.relname;
--step13: 插入数据; expect:成功
insert into t_subpartition_0270 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);

--step14: 清理环境; expect:成功
drop table if exists t_subpartition_0270;
drop tablespace if exists ts_subpartition_0270;