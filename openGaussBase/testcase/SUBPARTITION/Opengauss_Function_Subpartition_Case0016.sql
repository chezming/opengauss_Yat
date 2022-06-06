-- @testpoint: 二级分区表基本功能测试：创建/插入/查询/索引/更新/split/truncate/删除,部分测试点合理报错

--test1: 基本操作：创建/插入/查询
--step1: 创建二级分区表; expect:成功
drop table if exists s_subpartition_0016;
create table s_subpartition_0016
(
    month_code varchar2 ( 30 ) not null ,
    dept_code  varchar2 ( 30 ) not null ,
    user_no    varchar2 ( 30 ) not null ,
    sales_amt  int
)
partition by range (month_code) subpartition by range (dept_code)
(
  partition p_201901 values less than( '201903' )
  (
    subpartition p_201901_a values less than( '2' ),
    subpartition p_201901_b values less than( maxvalue )
  ),
  partition p_201902 values less than( '201904' )
  (
    subpartition p_201902_a values less than( '2' ),
    subpartition p_201902_b values less than( '3' )
  )
) enable row movement;
--step2: 插入数据; expect:成功
insert into s_subpartition_0016 values('201902', '1', '1', 1),('201902', '2', '1', 1),('201902', '1', '1', 1);
insert into s_subpartition_0016 values('201903', '2', '1', 1),('201903', '1', '1', 1),('201903', '2', '1', 1);
--step3: 查询数据; expect:成功，6条数据
select * from s_subpartition_0016;
--step4: 查询一级分区数据; expect:成功，3条数据
select * from s_subpartition_0016 partition(p_201901);
--step5: 查询二级分区数据; expect:成功，2条数据
select * from s_subpartition_0016 subpartition (p_201901_a);
--step6: 查询二级分区数据; expect:成功，1条数据
select * from s_subpartition_0016 subpartition (p_201901_b);

--test2: 索引
--step7: 创建索引; expect:成功
drop index i_subpartition_0016;
create index i_subpartition_0016 on s_subpartition_0016(month_code) local;
--step8: 设置参数enable_seqscan = off; expect:成功
set enable_seqscan = off;
--step9: 查看索引; expect:成功
explain select * from s_subpartition_0016 where month_code = '201902';
--step10: 删除索引; expect:成功
drop index if exists i_subpartition_0016;

--test3: update数据
--step11: 查看二级分区数据; expect:成功，1条数据
select * from s_subpartition_0016 subpartition (p_201901_b);
--step12: 二级分区内更新数据; expect:成功
update s_subpartition_0016 set dept_code = 3 where month_code = '201902' and dept_code = '2';
--step13: 查看二级分区数据; expect:成功，1条数据
select * from s_subpartition_0016 subpartition (p_201901_b);
--step14: 跨二级分区更新数据; expect:成功
update s_subpartition_0016 set dept_code = 3 where month_code = '201902' and dept_code = '1';
--step15: 查看二级分区数据; expect:成功，0条数据
select * from s_subpartition_0016 subpartition (p_201901_a);
--step16: 查看二级分区数据; expect:成功，3条数据
select * from s_subpartition_0016 subpartition (p_201901_b);

--test4: split二级分区
--step17: split二级分区; expect:成功
alter table s_subpartition_0016 split subpartition p_201901_b at (3) into
(
	subpartition p_201901_c,
	subpartition p_201901_d
);
--step18: 查询修改前二级分区数据; expect:合理报错
select * from s_subpartition_0016 subpartition (p_201901_b);
--step19: 查询修改后二级分区数据; expect:成功，0条数据
select * from s_subpartition_0016 subpartition (p_201901_c);
--step20: 查询修改后二级分区数据; expect:成功，3条数据
select * from s_subpartition_0016 subpartition (p_201901_d);

--test5: truncate 二级分区
--step21: 查询二级分区数据; expect:成功，1条数据
select * from s_subpartition_0016 subpartition (p_201902_a);
--step22: 清空二级分区数据; expect:成功
alter table s_subpartition_0016 truncate subpartition p_201902_a;
--step23: 查询二级分区数据; expect:成功，0条数据
select * from s_subpartition_0016 subpartition (p_201902_a);

--test6: 删除数据
--step24: 查询二级分区数据; expect:成功，2条数据
select * from s_subpartition_0016 subpartition (p_201902_b);
--step25: 查询二级分区数据; expect:成功
delete from s_subpartition_0016 where month_code = '201903' and dept_code ='2';
--step26: 查询二级分区数据; expect:成功，0条数据
select * from s_subpartition_0016 subpartition (p_201902_b);

--step27: 删除表; expect:成功
drop table if exists s_subpartition_0016;

--test7: 扩展场景extended
--step28: 创建二级分区表，二级分区名相同; expect:合理报错
drop table if exists s_subpartition_0016;
create table s_subpartition_0016
(
    month_code varchar2 ( 30 ) not null ,
    dept_code  varchar2 ( 30 ) not null ,
    user_no    varchar2 ( 30 ) not null ,
    sales_amt  int
)
partition by list (month_code) subpartition by list (dept_code)
(
  partition p_201901 values ( '201902' )
  (
    subpartition p_201901_a values ( '1' ),
    subpartition p_201901_a values ( default )
  ),
  partition p_201902 values ( '201903' )
  (
    subpartition p_201902_a values ( '1' ),
    subpartition p_201902_b values ( '2' )
  )
) enable row movement;
error:  duplicate subpartition name: "p_201901_a"
--step29: 创建二级分区表，同一个一级分区中，二级分区的边界值能相同; expect:合理报错
drop table if exists s_subpartition_0016;
create table s_subpartition_0016
(
    month_code varchar2 ( 30 ) not null ,
    dept_code  varchar2 ( 30 ) not null ,
    user_no    varchar2 ( 30 ) not null ,
    sales_amt  int
)
partition by list (month_code) subpartition by list (dept_code)
(
  partition p_201901 values ( '201902' )
  (
    subpartition p_201901_a values ( '1' ),
    subpartition p_201901_b values ( default )
  ),
  partition p_201902 values ( '201903' )
  (
    subpartition p_201902_a values ( '1' ),
    subpartition p_201902_b values ( '1' )
  )
) enable row movement;
--step30: 创建二级分区是list分区; expect:成功
drop table if exists s_subpartition_0016;
create table s_subpartition_0016
(
    month_code varchar2 ( 30 ) not null ,
    dept_code  varchar2 ( 30 ) not null ,
    user_no    varchar2 ( 30 ) not null ,
    sales_amt  int
)
partition by list (month_code) subpartition by list (dept_code)
(
  partition p_201901 values ( '201902' )
  (
    subpartition p_201901_a values ( '1' ),
    subpartition p_201901_b values ( default )
  ),
  partition p_201902 values ( '201903' )
  (
    subpartition p_201902_a values ( '1' ),
    subpartition p_201902_b values ( '2' )
  )
) enable row movement;
--step31: 对非default分区作split操作; expect:合理报错
alter table s_subpartition_0016 split subpartition p_201901_a values (2) into
(
	subpartition p_201901_b,
	subpartition p_201901_c
);

--step33: 删除表; expect:成功
drop table if exists s_subpartition_0016;