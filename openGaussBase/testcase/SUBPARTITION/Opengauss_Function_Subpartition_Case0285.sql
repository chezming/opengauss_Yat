-- @testpoint: range_range二级分区表：select join

--step1: 创建表空间; expect:成功
drop table if exists t_subpartition_0285;
drop table if exists t_subpartition_0285_01;
drop tablespace if exists ts_subpartition_0285;
create tablespace ts_subpartition_0285 relative location 'subpartition_tablespace/subpartition_tablespace_0285';

--test1: select join
--step2: 创建二级分区表1; expect:成功
create table t_subpartition_0285_01
(
    col_1 int  not null ,
    col_2 int  not null ,
    col_3 int not null ,
    col_4 int
)
partition by range (col_1) subpartition by list (col_2)
(
  partition p_range_1 values less than( 10 )
  (
    subpartition p_range_1_1 values ( '1','2','3','4','5','6','7'),
    subpartition p_range_1_2 values ( default )
  ),
  partition p_range_2 values less than( 20 )
  (
    subpartition p_range_2_1 values ( '1','2','3','4','5','6','7'),
    subpartition p_range_2_2 values ( default )
  )
) enable row movement;
--step3: 插入数据; expect:成功
insert into t_subpartition_0285_01 values(1,11,1,1),(4,41,4,4),(5,54,5,5),(8,87,8,8),(9,19,9,9);
insert into t_subpartition_0285_01 values(1,8,1,1),(4,7,4,4),(5,8,5,5),(8,9,8,8),(9,9,9,9);
--step4: 创建二级分区表2; expect:成功
drop table if exists t_subpartition_0285;
create   table if not exists t_subpartition_0285
(
    col_1 int ,
    col_2 int  ,
	col_3 varchar2 ( 30 ) not null ,
    col_4 int
)tablespace ts_subpartition_0285
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
--step5: 插入数据; expect:成功
insert into t_subpartition_0285 values(1,1,1,1),(4,1,4,4),(5,5,5,5),(8,8,8,8),(9,9,9,9);
insert into t_subpartition_0285 values(1,11,1,1),(4,41,4,4),(5,54,5,5),(8,87,8,8),(9,19,9,9);
insert into t_subpartition_0285 values(11,1,1,1),(14,1,4,4),(15,5,5,5),(18,8,8,8),(19,1,9,9);

--step6: inner join查询数据; expect:成功
select bb.col_3 from (
select t_subpartition_0285.col_1,t_subpartition_0285.col_2,t_subpartition_0285.col_3,t_subpartition_0285.col_4 from t_subpartition_0285 inner join t_subpartition_0285_01
on t_subpartition_0285.col_1 = t_subpartition_0285_01.col_1
where t_subpartition_0285.col_2 >10) aa
inner join  t_subpartition_0285_01 bb
on aa.col_2 = bb.col_4;
--step7: left join查询数据; expect:成功
select bb.col_3 from (
select t_subpartition_0285.col_1,t_subpartition_0285.col_2,t_subpartition_0285.col_3,t_subpartition_0285.col_4 from t_subpartition_0285 LEFT join t_subpartition_0285_01
on t_subpartition_0285.col_1 = t_subpartition_0285_01.col_1
where t_subpartition_0285.col_2 >10) aa
LEFT join  t_subpartition_0285_01 bb
on aa.col_1 = bb.col_2 order by 1 limit 2 offset 3;
--step8: right join查询数据; expect:成功
select bb.col_3 from (
select t_subpartition_0285.col_1,t_subpartition_0285.col_2,t_subpartition_0285.col_3,t_subpartition_0285.col_4 from t_subpartition_0285 RIGHT join t_subpartition_0285_01
on t_subpartition_0285.col_1 = t_subpartition_0285_01.col_1
where t_subpartition_0285.col_2 >10) aa
RIGHT join  t_subpartition_0285_01 bb
on aa.col_1 = bb.col_2 order by 1 limit 2 offset 3;
--step9: full  join查询数据; expect:成功
select bb.col_3 from (
select t_subpartition_0285.col_1,t_subpartition_0285.col_2,t_subpartition_0285.col_3,t_subpartition_0285.col_4 from t_subpartition_0285 FULL join t_subpartition_0285_01
on t_subpartition_0285.col_1 = t_subpartition_0285_01.col_1
where t_subpartition_0285.col_2 >10) aa
FULL join  t_subpartition_0285_01 bb
on aa.col_1 = bb.col_2 order by 1 limit 2 offset 3;
--step10: anti-join查询数据; expect:成功
select * from t_subpartition_0285 where not exists
(select t_subpartition_0285.col_1 from t_subpartition_0285 FULL join t_subpartition_0285_01
on t_subpartition_0285.col_1 = t_subpartition_0285_01.col_1
where t_subpartition_0285.col_2 >10) order by 1 limit 2 ;
--step11: semi-join查询数据; expect:成功
select * from t_subpartition_0285 where  exists
(select t_subpartition_0285.col_1 from t_subpartition_0285 FULL join t_subpartition_0285_01
on t_subpartition_0285.col_1 = t_subpartition_0285_01.col_1
where t_subpartition_0285.col_2 >10) order by 1 limit 2 ;
--step12: cross join查询数据; expect:成功
select * from t_subpartition_0285 where  exists
(select t_subpartition_0285.col_1 from t_subpartition_0285 CROSS join t_subpartition_0285_01
where t_subpartition_0285.col_2 >10) order by 1 limit 2 ;

--test2: netloop join
--step13: 设置相关参数; expect:成功
SET enable_nestloop TO true;
SET enable_hashjoin TO false;
SET enable_mergejoin TO  false;
--step14: netloop join查询数据; expect:成功
select bb.col_3 from (
select t_subpartition_0285.col_1,t_subpartition_0285.col_2,t_subpartition_0285.col_3,t_subpartition_0285.col_4 from t_subpartition_0285 FULL join t_subpartition_0285_01
on t_subpartition_0285.col_1 = t_subpartition_0285_01.col_1
where t_subpartition_0285.col_2 >10) aa
FULL join  t_subpartition_0285_01 bb
on aa.col_1 = bb.col_2 order by 1 limit 2 offset 3;
--step15: explain analyze  netloop join查询数据的执行计划; expect:成功,确认使用nest loop join
explain analyze select bb.col_3 from (
select t_subpartition_0285.col_1,t_subpartition_0285.col_2,t_subpartition_0285.col_3,t_subpartition_0285.col_4 from t_subpartition_0285 FULL join t_subpartition_0285_01
on t_subpartition_0285.col_1 = t_subpartition_0285_01.col_1
where t_subpartition_0285.col_2 >10) aa
FULL join  t_subpartition_0285_01 bb
on aa.col_1 = bb.col_2 order by 1 limit 2 offset 3;

--test3: hash join
--step16: 设置相关参数; expect:成功
SET enable_nestloop TO false;
SET enable_hashjoin TO true;
SET enable_mergejoin TO  false;
--step17: explain analyze  hash join查询数据的执行计划; expect:成功,确认使用hash join
explain analyze select bb.col_3 from (
select t_subpartition_0285.col_1,t_subpartition_0285.col_2,t_subpartition_0285.col_3,t_subpartition_0285.col_4 from t_subpartition_0285 FULL join t_subpartition_0285_01
on t_subpartition_0285.col_1 = t_subpartition_0285_01.col_1
where t_subpartition_0285.col_2 >10) aa
FULL join  t_subpartition_0285_01 bb
on aa.col_1 = bb.col_2 order by 1 limit 2 offset 3;

--test4: merge join
--step18: 设置相关参数; expect:成功
SET enable_nestloop TO false;
SET enable_hashjoin TO false;
SET enable_mergejoin TO  true;
--step19: explain analyze  merge join查询数据的执行计划; expect:成功,确认使用merge join
explain analyze select bb.col_3 from (
select t_subpartition_0285.col_1,t_subpartition_0285.col_2,t_subpartition_0285.col_3,t_subpartition_0285.col_4 from t_subpartition_0285 FULL join t_subpartition_0285_01
on t_subpartition_0285.col_1 = t_subpartition_0285_01.col_1
where t_subpartition_0285.col_2 >10) aa
FULL join  t_subpartition_0285_01 bb
on aa.col_1 = bb.col_2 order by 1 limit 2 offset 3;

--step20: 清理环境; expect:成功
drop table if exists t_subpartition_0285;
drop table if exists t_subpartition_0285_01;
drop tablespace if exists ts_subpartition_0285;