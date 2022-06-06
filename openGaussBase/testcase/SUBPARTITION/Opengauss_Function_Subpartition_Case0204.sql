-- @testpoint: range_list二级分区表：分区名称为超长/重复,部分测试点合理报错

--step1: 创建表空间; expect:成功
drop table if exists t_subpartition_0204;
drop tablespace if exists ts_subpartition_0204;
create tablespace ts_subpartition_0204 relative location 'subpartition_tablespace/subpartition_tablespace_0204';
drop tablespace if exists ts_subpartition_0204_01;
create tablespace ts_subpartition_0204_01 relative location 'subpartition_tablespace/subpartition_tablespace_0204_01';
--test1: 分区名称-名称超长
--step2: 创建二级分区表,二级分区名称超长; expect:成功
create   table if not exists t_subpartition_0204
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int
)
tablespace ts_subpartition_0204
partition by range (col_1) subpartition by list (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_list_1_1 values ( '1','2','3','4','5'),
    subpartition  dddddddddddddddddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa555555555555555555555523333333333333333333333333333saaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa55555555555555555555555555555555 values ( default )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_list_2_1 values ( '6','7','8','9','10'),
    subpartition p_list_2_2 values ( default )
  ),
   partition p_range_3 values less than( 30 )
   (
    subpartition p_list_3_1 values ( default )
  ),
   partition p_range_4 values less than( 40 )
   (
    subpartition p_list_4_1 values ( default )
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step3: 查询分区信息; expect:成功
select relname, parttype, partstrategy, indisusable from pg_partition where parentid = (select oid from pg_class where relname = 't_subpartition_0204') order by relname;
select a.relname,a.parttype,a.partstrategy,a.indisusable from pg_partition a,(select oid from pg_partition
where parentid = (select oid from pg_class where relname = 't_subpartition_0204')) b where a.parentid = b.oid order by a.relname;
--step4: 插入数据; expect:成功
insert into t_subpartition_0204 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
--step5: 查询一级分区数据; expect:成功
select * from t_subpartition_0204 partition(p_range_1);
--step6: 查询超长名称的二级分区数据; expect:成功
select * from t_subpartition_0204 subpartition(dddddddddddddddddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa555555555555555555555523333333333333333333333333333saaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa55555555555555555555555555555555);

--test2: 分区名称-名称重复
--step7: 创建二级分区表,不同一级分区中的二级分区名称重复; expect:合理报错
drop table if exists t_subpartition_0204;
create   table if not exists t_subpartition_0204
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0204
partition by range (col_1) subpartition by list (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_list_1_1 values ( '1','2','3','4','5'),
    subpartition  p_range_1_1 values ( default )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_list_2_1 values ( '6','7','8','9','10'),
    subpartition p_list_2_2 values ( default )
  ),
   partition p_range_3 values less than( 30 )
   (
    subpartition p_range_1_1 values ( default )
  ),
   partition p_range_4 values less than( 40 )
   (
    subpartition p_list_4_1 values ( default )
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step8: 创建二级分区表,二级分区名称和一级分区名称重复; expect:合理报错
drop table if exists t_subpartition_0204;
create   table if not exists t_subpartition_0204
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0204
partition by range (col_1) subpartition by list (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_list_1_1 values ( '1','2','3','4','5'),
    subpartition  p_range_1 values ( default )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_list_2_1 values ( '6','7','8','9','10'),
    subpartition p_list_2_2 values ( default )
  ),
   partition p_range_3 values less than( 30 )
   (
    subpartition p_list_3_1 values ( default )
  ),
   partition p_range_4 values less than( 40 )
   (
    subpartition p_list_1 values ( default )
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step9: 创建二级分区表,二级分区名和列名重复; expect:成功
drop table if exists t_subpartition_0204;
create   table if not exists t_subpartition_0204
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0204
partition by range (col_1) subpartition by list (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_list_1_1 values ( '1','2','3','4','5'),
    subpartition  col_4 values ( default )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_list_2_1 values ( '6','7','8','9','10'),
    subpartition p_list_2_2 values ( default )
  ),
   partition p_range_3 values less than( 30 )
   (
    subpartition p_list_3_1 values ( default )
  ),
   partition p_range_4 values less than( 40 )
   (
    subpartition p_list_4_1 values ( default )
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step10: 创建二级分区表,二级分区名为"table"; expect:成功
drop table if exists t_subpartition_0204;
create   table if not exists t_subpartition_0204
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0204
partition by range (col_1) subpartition by list (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_list_1_1 values ( '1','2','3','4','5'),
    subpartition "table"   values ( default )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_list_2_1 values ( '6','7','8','9','10'),
    subpartition p_list_2_2 values ( default )
  ),
   partition p_range_3 values less than( 30 )
   (
    subpartition p_list_3_1 values ( default )
  ),
   partition p_range_4 values less than( 40 )
   (
    subpartition p_list_4_1 values ( default )
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step11: 创建二级分区表,二级分区名和表名重复; expect:成功
drop table if exists t_subpartition_0204;
create   table if not exists t_subpartition_0204
(
    col_1 int ,
    col_2 int  ,
	col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0204
partition by range (col_1) subpartition by list (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_list_1_1 values ( '1','2','3','4','5'),
    subpartition t_subpartition_0204   values ( default )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_list_2_1 values ( '6','7','8','9','10'),
    subpartition p_list_2_2 values ( default )
  ),
   partition p_range_3 values less than( 30 )
   (
    subpartition p_list_3_1 values ( default )
  ),
   partition p_range_4 values less than( 40 )
   (
    subpartition p_list_4_1 values ( default )
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;
--step12: 查询数据; expect:成功
select relname, parttype, partstrategy, indisusable from pg_partition where parentid = (select oid from pg_class where relname = 't_subpartition_0204') order by relname;
select a.relname,a.parttype,a.partstrategy,a.indisusable from pg_partition a,(select oid from pg_partition
where parentid = (select oid from pg_class where relname = 't_subpartition_0204')) b where a.parentid = b.oid order by a.relname;
--step13: 插入数据; expect:成功
insert into t_subpartition_0204 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
--step14: 查询特殊二级分区名数据; expect:成功
select * from t_subpartition_0204 subpartition(t_subpartition_0204);
--step15: 使用错误的关键字查询表数据; expect:成功，实际查询所有的数据
select * from t_subpartition_0204 subpartitn(t_subpartition_0204);

--step16: 清理环境; expect:成功
drop table if exists t_subpartition_0204;
drop tablespace if exists ts_subpartition_0204;
drop tablespace if exists ts_subpartition_0204_01;