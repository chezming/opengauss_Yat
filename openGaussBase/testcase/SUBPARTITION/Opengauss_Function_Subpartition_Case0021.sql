-- @testpoint: list_list二级分区表:check约束/index_parameters(unique),部分测试点合理报错

--test1: check约束
--step1: 创建二级分区表; expect:成功
drop table if exists t_subpartition_0021;
create   table if not exists t_subpartition_0021
(
    col_1 int  ,
    col_2 int  not null ,
	col_3 int not null ,
    col_4 int   ,
	check (col_1 > col_2 and col_4 is null)
)
partition by list (col_1) subpartition by list (col_2)
(
  partition p_list_1 values(-1,-2,-3,-4,-5,-6,-7,-8,-9,-10 )
  (
    subpartition p_list_1_1 values ( 0,-1,-2,-3,-4,-5,-6,-7,-8,-9 ),
    subpartition p_list_1_2 values ( default )
  ),
  partition p_list_2 values(0,1,2,3,4,5,6,7,8,9)
  (
    subpartition p_list_2_1 values ( 0,1,2,3,4,5,6,7,8,9 ),
    subpartition p_list_2_2 values ( default ),
	subpartition p_list_2_3 values ( 10,11,12,13,14,15,16,17,18,19),
	subpartition p_list_2_4 values ( 20,21,22,23,24,25,26,27,28,29 ),
	subpartition p_list_2_5 values ( 30,31,32,33,34,35,36,37,38,39 )
  ),
  partition p_list_3 values(10,11,12,13,14,15,16,17,18,19)
  (
    subpartition p_list_3_2 values ( default )
  ),
  partition p_list_4 values(default ),
  partition p_list_5 values(20,21,22,23,24,25,26,27,28,29)
  (
    subpartition p_list_5_1 values ( 0,1,2,3,4,5,6,7,8,9 ),
    subpartition p_list_5_2 values ( default ),
	subpartition p_list_5_3 values ( 10,11,12,13,14,15,16,17,18,19),
	subpartition p_list_5_4 values ( 20,21,22,23,24,25,26,27,28,29 ),
	subpartition p_list_5_5 values ( 30,31,32,33,34,35,36,37,38,39 )
  ),
  partition p_list_6 values(30,31,32,33,34,35,36,37,38,39),
  partition p_list_7 values(40,41,42,43,44,45,46,47,48,49)
  (
    subpartition p_list_7_1 values ( default )
  )
) enable row movement;
--step2: 插入不符合check约束(col_1 > col_2)的数据; expect:合理报错
insert into t_subpartition_0021 values(2,1,1),(5,5,5);
--step3: 插入符合check约束"t_subpartition_0021_check"的数据; expect:成功
insert into t_subpartition_0021 values(2,1,1),(6,5,5);
--step4: 插入不符合check约束(col_4 is null)的数据; expect:合理报错
insert into t_subpartition_0021 values(2,1,1,1),(6,5,5,5);

--test2: index_parameters：unique
--step5: 创建二级分区表; expect:成功
drop table if exists t_subpartition_0021;
create   table if not exists t_subpartition_0021
(
    col_1 int  ,
    col_2 int  not null ,
	col_3 int not null ,
    col_4 int   ,
	unique (col_1,col_2)
)
partition by list (col_1) subpartition by list (col_2)
(
  partition p_list_1 values(-1,-2,-3,-4,-5,-6,-7,-8,-9,-10 )
  (
    subpartition p_list_1_1 values ( 0,-1,-2,-3,-4,-5,-6,-7,-8,-9 ),
    subpartition p_list_1_2 values ( default )
  ),
  partition p_list_2 values(0,1,2,3,4,5,6,7,8,9)
  (
    subpartition p_list_2_1 values ( 0,1,2,3,4,5,6,7,8,9 ),
    subpartition p_list_2_2 values ( default ),
	subpartition p_list_2_3 values ( 10,11,12,13,14,15,16,17,18,19),
	subpartition p_list_2_4 values ( 20,21,22,23,24,25,26,27,28,29 ),
	subpartition p_list_2_5 values ( 30,31,32,33,34,35,36,37,38,39 )
  ),
  partition p_list_3 values(10,11,12,13,14,15,16,17,18,19)
  (
    subpartition p_list_3_2 values ( default )
  ),
  partition p_list_4 values(default ),
  partition p_list_5 values(20,21,22,23,24,25,26,27,28,29)
  (
    subpartition p_list_5_1 values ( 0,1,2,3,4,5,6,7,8,9 ),
    subpartition p_list_5_2 values ( default ),
	subpartition p_list_5_3 values ( 10,11,12,13,14,15,16,17,18,19),
	subpartition p_list_5_4 values ( 20,21,22,23,24,25,26,27,28,29 ),
	subpartition p_list_5_5 values ( 30,31,32,33,34,35,36,37,38,39 )
  ),
  partition p_list_6 values(30,31,32,33,34,35,36,37,38,39),
  partition p_list_7 values(40,41,42,43,44,45,46,47,48,49)
  (
    subpartition p_list_7_1 values ( default )
  )
) enable row movement;
--step6: 插入符合(col_1,col_2)唯一约束的数据; expect:成功
insert into t_subpartition_0021 values(1,1,1,1),(5,5,5,5);
--step7: 查询数据; expect:成功
select * from t_subpartition_0021;
--step8: 插入不符合(col_1,col_2)唯一约束的数据; expect:合理报错
insert into t_subpartition_0021 values(1,1,1,1),(5,5,5,5);

--step9:  删除表; expect:成功
drop table if exists t_subpartition_0021;