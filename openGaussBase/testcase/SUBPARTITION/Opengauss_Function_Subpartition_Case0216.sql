-- @testpoint: range_list二级分区表修改：drop分区键和非分区键/drop分区,部分测试点合理报错

--step1: 创建表空间; expect:成功
drop table if exists t_subpartition_0216;
drop tablespace if exists ts_subpartition_0216;
create tablespace ts_subpartition_0216 relative location 'subpartition_tablespace/subpartition_tablespace_0216';

--test1: alter table drop --字段(分区键和非分区键)
--step2: 创建表空间; expect:成功
create table if not exists t_subpartition_0216
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)tablespace ts_subpartition_0216
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
insert into t_subpartition_0216 values(1,11,1,1),(4,41,4,4),(5,54,5,5),(8,87,8,8),(9,19,9,9);
--step4: 修改二级分区表,删除非分区键; expect:成功
alter table t_subpartition_0216 drop column col_4;
--step5: 修改二级分区表,删除一级分区键; expect:合理报错
alter table t_subpartition_0216 drop column col_1;
--step6: 修改二级分区表,删除二级分区键; expect:合理报错
alter table t_subpartition_0216 drop column col_2;

--test2: alter table drop --分区
--step7: 创建二级分区表; expect:成功
drop table if exists t_subpartition_0216;
create table if not exists t_subpartition_0216
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)tablespace ts_subpartition_0216
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
--step8: 插入数据; expect:成功
insert into t_subpartition_0216 values(1,11,1,1),(4,41,4,4),(5,54,5,5),(8,87,8,8),(9,19,9,9);
--step9: 修改二级分区表,删除一级分区; expect:成功
alter table t_subpartition_0216 drop partition p_range_1;
--step10: 修改二级分区表,删除二级分区; expect:成功
alter table t_subpartition_0216 drop subpartition p_list_2_1;

--step11: 清理环境; expect:成功
drop table if exists t_subpartition_0216;
drop tablespace if exists ts_subpartition_0216;