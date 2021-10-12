-- @testpoint: 结合不同表类型，创建hash分区表，不支持的表类型合理报错

--普通行存hash分区表
drop table if exists partition_hash_tab01;
create table partition_hash_tab01(p_id int,p_name varchar,p_age int)
partition by hash(p_id)
(partition part_1,
 partition part_2,
 partition part_3);

--普通列存hash分区表，不支持合理报错
drop table if exists partition_hash_tab02;
create table partition_hash_tab02(p_id int,p_name varchar,p_age int)
with (orientation = column)
partition by hash(p_id)
(partition part_1,
 partition part_2,
 partition part_3);

--本地临时行存hash分区表，不支持合理报错
drop table if exists partition_hash_tab03;
create local temporary table partition_hash_tab03(p_id int,p_name varchar,p_age int)
partition by hash(p_id)
(partition part_1,
 partition part_2,
 partition part_3);

--全局临时行存hash分区表，不支持合理报错
drop table if exists partition_hash_tab04;
create global temporary table partition_hash_tab04(p_id int,p_name varchar,p_age int)
partition by hash(p_id)
(partition part_1,
 partition part_2,
 partition part_3);

--清理环境
drop table if exists partition_hash_tab01;
drop table if exists partition_hash_tab02;
drop table if exists partition_hash_tab03;
drop table if exists partition_hash_tab04;

