-- @testpoint: Hash分区表中查看分区信息

--step1：创建hash分区表 expect：成功
drop table if exists t_partition_hash_0081_01;
create table t_partition_hash_0081_01(
id int,
name varchar(100),
age int)
partition by hash(id)
(partition p1,
 partition p2);

--step2：插入数据 expect：成功插入四条数据
insert into t_partition_hash_0081_01 values( 1,  '张三', 25);
insert into t_partition_hash_0081_01 values( 2,  '张三', 26);
insert into t_partition_hash_0081_01 values( 3,  '张三', 27);
insert into t_partition_hash_0081_01 values( 4,  '张三', 28);

--step3：查看分区信息 expect：成功
select t1.relname, partstrategy from pg_partition t1, pg_class t2
where t1.parentid = t2.oid and t2.relname = 't_partition_hash_0081_01'
and t1.parttype = 'p' order by t1.relname asc;

--step4：清理环境 expect：成功
drop table if exists t_partition_hash_0081_01;