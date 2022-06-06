-- @testpoint: 更改分区表所属表空间,合理报错

--step1:创建表空间，expect成功
drop tablespace if exists ts_partition_list_0020_01;
drop tablespace if exists ts_partition_list_0020_02;
create tablespace ts_partition_list_0020_01 relative location 'tablespace/part_tablespace01';
create tablespace ts_partition_list_0020_02 relative location 'tablespace/part_tablespace02';

--step2:创建list分区表,指定表空间为ts_partition_list_0020_01,expect成功
drop table if exists t_partition_list_0020;
create table t_partition_list_0020(p_id int,p_name varchar,p_age int)
tablespace ts_partition_list_0020_01
partition by list(p_id)
(partition part_1 values(10),
 partition part_2 values(20),
 partition part_3 values(30));

--step3:更改分区表所属表空间,expect失败
ALTER TABLE  t_partition_list_0020 SET TABLESPACE ts_partition_list_0020_02;

--step4:清理环境，expect成功
drop table t_partition_list_0020;
drop tablespace ts_partition_list_0020_01;
drop tablespace ts_partition_list_0020_02;
