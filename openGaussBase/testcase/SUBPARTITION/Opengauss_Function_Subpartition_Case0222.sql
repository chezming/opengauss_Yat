-- @testpoint: range_list二级分区表：truncate/delete,部分测试点合理报错

--step1: 创建表空间; expect:成功
drop table if exists t_subpartition_0222;
drop tablespace if exists ts_subpartition_0222;
create tablespace ts_subpartition_0222 relative location 'subpartition_tablespace/subpartition_tablespace_0222';

--test1: truncate  table
--step2: 创建二级分区表; expect:成功
create table if not exists t_subpartition_0222
(
    col_1 int ,
    col_2 int ,
    col_3 varchar2 ( 30 ) not null ,
    col_4 int 
)tablespace ts_subpartition_0222
partition by range (col_1) subpartition by list (col_2)
(
  partition p_range_1 values less than( -10 )
  (
    subpartition p_list_1_1 values ( '-1','-2','-3','-4','-5'),
    subpartition p_list_1_2 values ( default )
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
--step3: 插入数据; expect:成功
insert into t_subpartition_0222 values(1,11,1,1),(4,41,4,4),(5,54,5,5),(8,87,8,8),(9,19,9,9);
--step4: 查询数据; expect:成功,有数据
select * from t_subpartition_0222;
--step5: 清空表数据; expect:成功
truncate t_subpartition_0222;
--step6: 查询数据; expect:成功,无数据
select * from t_subpartition_0222;

--test2: truncate  partition
--step7: 插入数据; expect:成功
insert into t_subpartition_0222 values(-11,11,1,1),(4,41,4,4),(5,54,5,5),(8,87,8,8),(9,19,9,9);
--step8: 查询指定一级分区数据; expect:成功,有数据
select * from t_subpartition_0222 partition(p_range_1);
--step9: 查询指定一级分区数据; expect:成功,有数据
select * from t_subpartition_0222 partition(p_range_2);
--step10: 清空指定一级分区数据; expect:成功
alter table t_subpartition_0222 truncate partition p_range_1;
--step11: 清空指定一级分区数据; expect:成功
alter table t_subpartition_0222 truncate partition p_range_2;
--step12: 查询指定一级分区数据; expect:成功,无数据
select * from t_subpartition_0222 partition(p_range_1);
--step13: 查询指定一级分区数据; expect:成功,无数据
select * from t_subpartition_0222 partition(p_range_2);

--test3: truncate  subpartition
--step14: 插入数据; expect:成功
insert into t_subpartition_0222 values(1,7,1,1),(4,8,4,4),(5,54,5,5),(8,87,8,8),(9,19,9,9);
--step15: 查询指定一级分区数据; expect:成功,有数据
select * from t_subpartition_0222 subpartition(p_list_2_1);
--step16: 查询指定一级分区数据; expect:成功,有数据
select * from t_subpartition_0222 subpartition(p_list_2_2);
--step17: 清空多个二级分区数据; expect:合理报错
alter table t_subpartition_0222 truncate subpartition p_list_2_1,p_list_2_2;
--step18: 清空指定二级分区数据; expect:成功
alter table t_subpartition_0222 truncate subpartition p_list_2_1;
--step19: 清空指定二级分区数据; expect:成功
alter table t_subpartition_0222 truncate subpartition p_list_2_2;
--step20: 查询指定一级分区数据; expect:成功,无数据
select * from t_subpartition_0222 subpartition(p_list_2_1);
--step21: 查询指定一级分区数据; expect:成功,无数据
select * from t_subpartition_0222 subpartition(p_list_2_2);

--test4: delete table
--step22: 插入数据; expect:成功
insert into t_subpartition_0222 values(-11,11,1,1),(4,41,4,4),(5,54,5,5),(28,87,8,8),(39,19,9,9);
insert into t_subpartition_0222 values(1,11,1,1),(4,41,4,4),(5,54,5,5),(8,87,8,8),(9,19,9,9);
insert into t_subpartition_0222 values(11,1,1,1),(14,1,4,4),(15,5,5,5),(18,8,8,8),(19,1,9,9);
--step23: 查询数据; expect:成功,有数据
select * from t_subpartition_0222;
--step24: 删除表数据; expect:成功
delete from  t_subpartition_0222;
--step25: 查询数据; expect:成功,无数据
select * from t_subpartition_0222;
--step26: 查询数据; expect:成功,无数据
select * from t_subpartition_0222 subpartition(p_list_1_2);
--step27: 查询数据; expect:成功,无数据
select * from t_subpartition_0222 subpartition(p_list_2_2);

--test5: delete  where
--step28: 插入数据; expect:成功
insert into t_subpartition_0222 values(1,11,1,1),(4,41,4,4),(5,54,5,5),(8,87,8,8),(9,19,9,9);
insert into t_subpartition_0222 values(11,1,1,1),(14,1,4,4),(15,5,5,5),(18,8,8,8),(19,1,9,9);
--step29: 查询数据; expect:成功,有数据
select * from t_subpartition_0222;
--step30: 删除指定条件的数据; expect:成功
delete from  t_subpartition_0222 where col_1 >18 ;
delete from  t_subpartition_0222 where col_2 <10 and col_3>5;
delete from  t_subpartition_0222 where col_2 <50 and col_3>5;
--step31: 删除指定条件的数据; expect:成功
delete  t_subpartition_0222 where col_2-100>10;
delete  t_subpartition_0222 where col_2-100>10;
delete  t_subpartition_0222 where col_2/5>1;
--step32: 查询数据; expect:成功
select * from t_subpartition_0222;
--step33: 查询数据; expect:成功,无数据
select * from t_subpartition_0222 subpartition(p_list_1_1);
--step34: 查询数据; expect:成功,无数据
select * from t_subpartition_0222 subpartition(p_list_1_2);
--step35: 查询数据; expect:成功,无数据
select * from t_subpartition_0222 subpartition(p_list_2_1);
--step36: 查询数据; expect:成功
select * from t_subpartition_0222 subpartition(p_list_2_2);

--step37: 创建普通表; expect:成功
drop table if exists t_subpartition_0222_01;
create table if not exists t_subpartition_0222_01
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int
)tablespace ts_subpartition_0222;
--step38: 插入数据; expect:成功
insert into t_subpartition_0222_01 values(1,11,1,1),(4,41,4,4),(5,54,5,5),(8,87,8,8),(9,19,9,9);
--step39: 删除指定条件的数据; expect:成功
delete from t_subpartition_0222 where col_3 in (select col_1 from t_subpartition_0222_01);
delete from t_subpartition_0222 aa where aa.col_2 in (select col_1 from t_subpartition_0222_01);
--step40: 删除指定分区的数据; expect:成功
delete from t_subpartition_0222 partition(p_range_5) where  col_1='9';
delete from t_subpartition_0222 subpartition(p_list_4_1) where  col_1='8';

--step41: 清理环境; expect:成功
drop table if exists t_subpartition_0222_01;
drop table if exists t_subpartition_0222;
drop tablespace if exists ts_subpartition_0222;