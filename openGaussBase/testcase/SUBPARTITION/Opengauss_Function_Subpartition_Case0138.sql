-- @testpoint: list_hash二级分区表:null/not null,部分测试点合理报错

--test1: 列约束not null
--step1: 创建二级分区表，二级分区键包含列约束not null; expect:成功
drop table if exists t_subpartition_0138;
create  table if not exists t_subpartition_0138
(
  col_1 int ,
  col_2 int not null ,
    col_3 int not null ,
  col_4 int
)
partition by list (col_1) subpartition by hash (col_2)
(
 partition p_list_1 values (-1,-2,-3,-4,-5,-6,-7,-8,-9,-10 )
 (
  subpartition p_hash_1_1 ,
  subpartition p_hash_1_2 ,
  subpartition p_hash_1_3
 ),
 partition p_list_2 values (1,2,3,4,5,6,7,8,9,10 )
 (
  subpartition p_hash_2_1 ,
  subpartition p_hash_2_2 ,
  subpartition p_hash_2_3 ,
  subpartition p_hash_2_4 ,
  subpartition p_hash_2_5
 ),
 partition p_list_3 values (11,12,13,14,15,16,17,18,19,20),
 partition p_list_4 values (21,22,23,24,25,26,27,28,29,30 )
 (
  subpartition p_hash_4_1
 ),
 partition p_list_5 values (default)
 (
  subpartition p_hash_5_1
 ),
 partition p_list_6 values (31,32,33,34,35,36,37,38,39,40)
 (
  subpartition p_hash_6_1 ,
  subpartition p_hash_6_2 ,
  subpartition p_hash_6_3
 )
) enable row movement ;
--step2: 非空约束列插入空数据; expect:合理报错
insert into t_subpartition_0138(col_1,col_2) values(1,1),(5,5);

--test2: 列约束null
--step3: 创建二级分区表，二级分区键包含列约束null; expect:成功
drop table if exists t_subpartition_0138;
create  table if not exists t_subpartition_0138
(
  col_1 int ,
  col_2 int null ,
    col_3 int ,
  col_4 int
)
partition by list (col_1) subpartition by hash (col_2)
(
 partition p_list_1 values (-1,-2,-3,-4,-5,-6,-7,-8,-9,-10 )
 (
  subpartition p_hash_1_1 ,
  subpartition p_hash_1_2 ,
  subpartition p_hash_1_3
 ),
 partition p_list_2 values (1,2,3,4,5,6,7,8,9,10 )
 (
  subpartition p_hash_2_1 ,
  subpartition p_hash_2_2 ,
  subpartition p_hash_2_3 ,
  subpartition p_hash_2_4 ,
  subpartition p_hash_2_5
 ),
 partition p_list_3 values (11,12,13,14,15,16,17,18,19,20),
 partition p_list_4 values (21,22,23,24,25,26,27,28,29,30 )
 (
  subpartition p_hash_4_1
 ),
 partition p_list_5 values (default)
 (
  subpartition p_hash_5_1
 ),
 partition p_list_6 values (31,32,33,34,35,36,37,38,39,40)
 (
  subpartition p_hash_6_1 ,
  subpartition p_hash_6_2 ,
  subpartition p_hash_6_3
 )
) enable row movement ;
--step4: 空约束列插入空数据; expect:合理报错，插入的分区键值没在分区范围内
insert into t_subpartition_0138(col_1,col_3,col_4) values(1,1,1),(5,5,5);
--step5: 非空约束列插入空数据; expect:成功
insert into t_subpartition_0138(col_2,col_3,col_4) values(1,1,1),(5,5,5);
--step6: 查询全部数据; expect:成功，2条数据
select * from t_subpartition_0138;
--step7: 查询二级分区数据; expect:成功，2条数据
select * from t_subpartition_0138 subpartition(p_hash_5_1);
--step8: 查询数据; expect:成功
select * from t_subpartition_0138 partition(p_list_5);

--step9: 清理环境; expect:成功
drop table if exists t_subpartition_0138;