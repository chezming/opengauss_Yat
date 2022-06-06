-- @testpoint: range_list二级分区表：索引列数超过/等于31,部分测试点合理报错

--step1: 创建表空间; expect:成功
drop table if exists t_subpartition_0253;
drop tablespace if exists ts_subpartition_0253;
create tablespace ts_subpartition_0253 relative location 'subpartition_tablespace/subpartition_tablespace_0253';
--step2: 创建表空间; expect:成功
create table t_subpartition_0253
(
    col_1 int ,
    col_2 int ,
    col_3 varchar2 ( 30 ) ,
    col_4 int ,
    col_5 int ,
    col_6 int ,
    col_7 int ,
    col_8 int ,
    col_9 int ,
    col_10 int ,
    col_11 int ,
    col_12 int ,
    col_13 int ,
    col_14 int ,
    col_15 int ,
    col_16 int ,
    col_17 int ,
    col_18 int ,
    col_19 int ,
    col_20 int ,
    col_21 int ,
    col_22 int ,
    col_23 int ,
    col_24 int ,
    col_25 int ,
    col_26 int ,
    col_27 int ,
    col_28 int ,
    col_29 int ,
    col_30 int ,
    col_31 int ,
    col_32 int
)
tablespace ts_subpartition_0253
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
  )
) enable row movement;
--test1:  索引列数超过31
--step3: 创建索引,索引列数超过31; expect:合理报错
create unique index on t_subpartition_0253(col_1,col_2,col_3 ,col_4,col_5 ,col_6 ,col_7 ,col_8 ,col_9,col_10,col_11,col_12,col_13,col_14,col_15,col_16,col_17,col_18,col_19,col_20,col_21,col_22,col_23,col_24,col_25,col_26,col_27,col_28,col_29,col_30,col_31,col_32,col_33,col_34,col_35,col_36);
--step4: 创建索引,索引列数为31; expect:成功
create unique index on t_subpartition_0253(col_1,col_2,col_3 ,col_4,col_5 ,col_6 ,col_7 ,col_8 ,col_9,col_10,col_11,col_12,col_13,col_14,col_15,col_16,col_17,col_18,col_19,col_20,col_21,col_22,col_23,col_24,col_25,col_26,col_27,col_28,col_29,col_30,col_31);
--step5: 查看执行计划; expect:成功
explain select col_1,col_2,col_3 ,col_4,col_5 ,col_6 ,col_7 ,col_8 ,col_9,col_10,col_11,col_12,col_13,col_14,col_15,col_16,col_17,col_18,col_19,col_20,col_21,col_22,col_23,col_24,col_25,col_26,col_27,col_28,col_29,col_30,col_31 from t_subpartition_0253 where col_2 in  (
select col_1 from t_subpartition_0253  where col_1 >10 and col_1<100
) and col_2 = 100 order by 1 limit 100;

--step6: 清理环境; expect:成功
drop table if exists t_subpartition_0253;
drop tablespace if exists ts_subpartition_0253;