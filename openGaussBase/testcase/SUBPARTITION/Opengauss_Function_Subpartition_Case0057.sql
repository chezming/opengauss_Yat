-- @testpoint: list_list二级分区表：序列--分区列序列

--step1: 创建表空间; expect:成功
drop table if exists t_subpartition_0057;
drop tablespace if exists ts_subpartition_0057;
create tablespace ts_subpartition_0057 relative location 'subpartition_tablespace/subpartition_tablespace_0057';

--test1: 序列--分区列序列
--step2: 创建序列; expect:成功
drop sequence if exists seql_subpartition_0057;
create sequence seql_subpartition_0057 cache 100;
--step3: 创建二级分区表，将序列值作为分区键的默认值，使该字段具有唯一标识属性; expect:成功
create table if not exists t_subpartition_0057
(
    col_1 int not null default nextval('seql_subpartition_0057'),
    col_2 int  not null default nextval('seql_subpartition_0057'),
    col_3 varchar2 ( 30 ) not null ,
    col_4 int
)tablespace ts_subpartition_0057
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
--step4: 指定序列与列的归属关系; expect:成功
alter sequence seql_subpartition_0057 owned by t_subpartition_0057.col_2;
alter sequence seql_subpartition_0057 owned by t_subpartition_0057.col_1;
--step5: 插入数据; expect:成功
insert into t_subpartition_0057(col_1,col_3,col_4) values(-11,1,1),(4,1,4),(5,5,5),(8,8,8),(9,9,9);
insert into t_subpartition_0057(col_2,col_3,col_4) values(-11,1,1),(4,1,4),(5,5,5),(8,8,8),(9,9,9);
insert into t_subpartition_0057(col_1,col_3,col_4) values(-11,1,1),(4,1,4),(5,5,5),(8,8,8),(9,9,9);
insert into t_subpartition_0057(col_2,col_3,col_4) values(-11,1,1),(4,1,4),(5,5,5),(8,8,8),(9,9,9);

--step6: 查询表数据; expect:成功，有数据
select * from t_subpartition_0057 ;
--step7: 查询指定二级分区数据; expect:成功，有数据
select * from t_subpartition_0057 subpartition(p_list_3_2);
--step8: 清空指定二级分区数据; expect:成功
alter table t_subpartition_0057 truncate subpartition p_list_3_2;
--step9: 查询指定二级分区数据; expect:成功，无数据
select * from t_subpartition_0057 subpartition(p_list_3_2);
--step10: 插入数据; expect:成功
insert into t_subpartition_0057(col_1,col_3,col_4) values(-11,1,1),(4,1,4),(5,5,5),(8,8,8),(9,9,9);
insert into t_subpartition_0057(col_2,col_3,col_4) values(-11,1,1),(4,1,4),(5,5,5),(8,8,8),(9,9,9);
--step11: 查询数据; expect:成功
select * from t_subpartition_0057 ;
--step12: 查询指定二级分区数据; expect:成功
select * from t_subpartition_0057 subpartition(p_list_5_2);
--step13: 查询指定二级分区数据; expect:成功
select * from t_subpartition_0057 subpartition(p_list_5_1);

--step14: 删除表; expect:成功
drop table if exists t_subpartition_0057;
drop tablespace if exists ts_subpartition_0057;