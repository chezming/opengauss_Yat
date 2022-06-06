-- @testpoint: 创建local索引并向list分区表中插入数据，通过索引检索表中数据

--step1:创建list分区表,expect成功
drop table if exists t_partition_list_0035;
create table t_partition_list_0035(p_id int,p_name varchar,p_age int)
partition by list(p_id)
(partition p1 values(10),
 partition p2 values(20),
 partition p3 values(30),
 partition p4 values(40));

--step2:插入数据,expect成功
BEGIN
  for i in 1..20 LOOP
    insert into t_partition_list_0035 values(10),(20),(30),(40);
  end LOOP;
end;
/

--step3:创建local索引,expect成功
drop index if exists partition_index_01;
create index partition_index_01 on t_partition_list_0035(p_id) local;

--step4:通过索引检索表中数据,expect成功
explain select * from t_partition_list_0035 where p_id =10 ;

--step4:清理数据,expect成功
drop index if exists partition_index_01;
drop table if exists t_partition_list_0035;
