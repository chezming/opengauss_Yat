-- @testpoint: range_list二级分区表：with_query insert字段类型不符/update更新,部分测试点合理报错

--step1: 创建表空间; expect:成功
drop table if exists t_subpartition_0221;
drop table if exists t_subpartition_0221_01;
drop tablespace if exists ts_subpartition_0221;
create tablespace ts_subpartition_0221 relative location 'subpartition_tablespace/subpartition_tablespace_0221';

--test1: insert --with_query  insert(字段类型不符)
--step2: 创建二级分区表; expect:成功
create table if not exists t_subpartition_0221
(
    col_1 int ,
    col_2 int ,
    col_3 varchar2 ( 30 ) not null ,
    col_4 int 
)tablespace ts_subpartition_0221
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
--step3: 创建普通表; expect:成功
drop table if exists t_subpartition_0221_01;
create table if not exists t_subpartition_0221_01
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)tablespace ts_subpartition_0221;
--step4: 普通表插入数据; expect:成功
insert into t_subpartition_0221_01 values(1,11,1,1),(4,41,4,4),(5,54,5,5),(8,87,8,8),(9,19,9,9);
--step5: 查询临时表数据,插入到二级分区表; expect:成功
with with_t as (select 1,11,1,1) insert into t_subpartition_0221 (select * from with_t);
--step6: 查询普通表的数据,插入到二级分区表; expect:成功
insert into t_subpartition_0221 select * from t_subpartition_0221_01;
--step7: 查询二级分区表数据; expect:成功,有数据
select * from t_subpartition_0221;

--test2: update--更新非分区列
--step8: 创建二级分区表; expect:成功
drop table if exists t_subpartition_0221;
create table if not exists t_subpartition_0221
(
    col_1 int ,
    col_2 int ,
    col_3 varchar2 ( 30 ) not null ,
    col_4 int 
)tablespace ts_subpartition_0221
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
--step9: 插入数据; expect:成功
insert into t_subpartition_0221 values(-11,11,1,1),(4,41,4,4),(5,54,5,5),(28,87,8,8),(39,19,9,9);

--step10: 更新不同列数据; expect:成功
update t_subpartition_0221 set col_4=80 where col_1=4;
update t_subpartition_0221 set col_1=9 where col_3>8 and col_2 between 9 and 199;
--step11: 查询二级分区数据; expect:成功
select * from t_subpartition_0221 subpartition(p_list_2_2);
--step12: 更新非分区列的数据为一级分区键数据; expect:成功
update t_subpartition_0221 set col_4=col_1 where col_1<5;
--step13: 查询数据; expect:成功,col_4=col_1
select * from t_subpartition_0221 where col_1<5;
--step14: 更新非分区列的数据为一级分区键数据+二级分区键数据; expect:成功
update t_subpartition_0221 set col_4=col_1+ col_2 where col_1<5;
--step15: 查询数据; expect:成功,col_4=col_1+ col_2
select * from t_subpartition_0221 where col_1<5;

--test3: update--更新至一级分区外
--step16: 插入数据; expect:成功
insert into t_subpartition_0221 values(1,6,1,1),(4,7,4,4),(5,8,5,5);
--step17: 查询二级分区数据; expect:成功,3条数据
select * from t_subpartition_0221 subpartition(p_list_2_1);
--step18: 更新分区列的数据至原分区外; expect:成功
update t_subpartition_0221 set col_1=80,col_2=8 where col_1=1;
--step19: 查询二级分区数据; expect:成功,2条数据
select * from t_subpartition_0221 subpartition(p_list_2_1);
--step20: 查询二级分区数据; expect:成功,1条数据
select * from t_subpartition_0221 subpartition(p_range_5_subpartdefault1);

--test4: update--更新至一级分区内-二级分区内
--step21: 更新分区列的数据至一级分区内-二级分区内; expect:成功
update t_subpartition_0221 set col_1=1000,col_2=80 where col_1=80;
--step22: 查询数据; expect:成功,数据更新
select * from t_subpartition_0221 subpartition(p_range_5_subpartdefault1);
--step23: 查询数据; expect:成功
select * from t_subpartition_0221;
--step24: 更新分区列的数据至一级分区内-二级分区内; expect:成功
update t_subpartition_0221 set col_2=1842647 where col_2=80;
--step25: 查询数据; expect:成功
select * from t_subpartition_0221;
--step26: 查询数据; expect:成功,数据更新
select * from t_subpartition_0221 subpartition(p_range_5_subpartdefault1);

--test5: update--更新至一级分区内-二级分区外
--step27: 查询数据; expect:成功
select * from t_subpartition_0221 subpartition(p_list_2_1);
--step28: 查询数据; expect:成功
select * from t_subpartition_0221 subpartition(p_list_2_2);
--step29: 更新分区列的数据至一级分区内-二级分区外; expect:成功
update t_subpartition_0221 set col_1=5,col_2=9 where col_2=41;
--step30: 查询数据; expect:成功,数据更新
select * from t_subpartition_0221 subpartition(p_list_2_1);
--step31: 查询数据; expect:成功,数据更新
select * from t_subpartition_0221 subpartition(p_list_2_2);

--test6: returning
--step32: 更新数据返回指定数据; expect:成功
update t_subpartition_0221 set col_4=col_1 where col_1=5 returning (col_1,col_4);
--step33: 插入数据返回指定数据; expect:成功
insert into t_subpartition_0221 values (10000,10000,10000,10000)  returning (col_1,col_4);
insert into t_subpartition_0221 values (10000,10000,10000,10000)  returning *;
--step34: 删除数据返回指定数据; expect:成功
delete t_subpartition_0221 where col_1=5 returning (col_1,col_4);

--step35: 清理环境; expect:成功
drop table if exists t_subpartition_0221;
drop table if exists t_subpartition_0221_01;
drop tablespace if exists ts_subpartition_0221;