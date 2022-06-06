-- @testpoint: range_range二级分区表：分区名称为数字开头/关键字,部分测试点合理报错

--test1: 分区名称-数字开头
--step1: 创建二级分区表,分区名称为数字开头; expect:合理报错
drop table if exists t_subpartition_0269;
drop tablespace if exists ts_subpartition_0269;
create tablespace ts_subpartition_0269 relative location 'subpartition_tablespace/subpartition_tablespace_0269';
create   table if not exists t_subpartition_0269
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0269
partition by range (col_1) subpartition by range (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition '111' values less than( 5 ),
    subpartition p_range_1_2 values less than( maxvalue )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_range_2_1 values less than( 5 ),
    subpartition p_range_2_2 values less than( 10 )
  )
) enable row movement;


--test2: 分区名称-数据库关键字命名
--step2: 创建二级分区表，数据库关键字命名二级分区; expect:成功
drop table if exists t_subpartition_0269;
create   table if not exists t_subpartition_0269
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0269
partition by range (col_1) subpartition by range (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition postgres values less than( 5 ),
    subpartition p_range_1_2 values less than( maxvalue )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_range_2_1 values less than( 5 ),
    subpartition p_range_2_2 values less than( 10 )
  )
) enable row movement;
--step3: 查询分区情况; expect:成功
select relname,parttype,partstrategy,indisusable,interval from pg_partition where parentid = (select oid from pg_class where relname = 't_subpartition_0269') order by relname;
select a.relname,a.parttype,a.partstrategy,a.indisusable from pg_partition a,(select oid from pg_partition
where parentid = (select oid from pg_class where relname = 't_subpartition_0269')) b where a.parentid = b.oid order by a.relname;
--step4: 插入数据; expect:成功
insert into t_subpartition_0269 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
--step5: 查询普通一级分区数据数据; expect:成功
select * from t_subpartition_0269 partition(p_range_1);
--step6: 查询关键字二级分区数据; expect:成功
select * from t_subpartition_0269 subpartition(postgres);

--step7: 创建二级分区表，数据库关键字命名二级分区; expect:成功
drop table if exists t_subpartition_0269;
create   table if not exists t_subpartition_0269
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0269
partition by range (col_1) subpartition by range (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition opengauss values less than( 5 ),
    subpartition p_range_1_2 values less than( maxvalue )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_range_2_1 values less than( 5 ),
    subpartition p_range_2_2 values less than( 10 )
  )
) enable row movement;
--step8: 查询分区情况; expect:成功
select relname,parttype,partstrategy,indisusable,interval from pg_partition where parentid = (select oid from pg_class where relname = 't_subpartition_0269') order by relname;
select a.relname,a.parttype,a.partstrategy,a.indisusable from pg_partition a,(select oid from pg_partition
where parentid = (select oid from pg_class where relname = 't_subpartition_0269')) b where a.parentid = b.oid order by a.relname;
--step9: 插入数据; expect:成功
insert into t_subpartition_0269 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
--step10: 查询普通一级分区数据数据; expect:成功
select * from t_subpartition_0269 partition(p_range_1);
--step11: 查询关键字二级分区数据; expect:成功
select * from t_subpartition_0269 subpartition(opengauss);



--step12: 清理环境; expect:成功
drop table if exists t_subpartition_0269;
drop tablespace if exists ts_subpartition_0269;
