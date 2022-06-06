-- @testpoint: List分区表结合like including reloptions参数

--step1:创建list分区表;expect:成功
drop table if exists t_partition_list_0057_01;
create table t_partition_list_0057_01
(id                         number(7)  constraint t_partition_list_0057_01_id_nn not null,
 use_filename               varchar2(20),
 filename                   varchar2(255),
 text                       varchar2(2000))
 with (fillfactor = 50)
partition by list(id)
(partition p1 values(10),
 partition p2 values(20));


--step2:插入数据;expect:成功
insert into t_partition_list_0057_01 values(10,'李','李四','数学老师');

--step3:复制表结合like including reloptions参数;expect:成功
create table t_partition_list_0057_02(like  t_partition_list_0057_01 INCLUDING RELOPTIONS);

--step4:插入数据;expect:成功
insert into t_partition_list_0057_02 values(10,'李','李四','数学老师');

--step5:清理环境;expect:成功
drop table t_partition_list_0057_01;
drop table t_partition_list_0057_02;
