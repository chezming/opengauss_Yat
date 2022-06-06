-- @testpoint: Hash分区表与普通表交换数据（对应信息严格一致）

--step1：创建hash分区表 expect：成功
drop table if exists t_partition_hash_0077_01;
create table t_partition_hash_0077_01(
id int,
name varchar(100),
age int)
partition by hash(id)
(partition p1,
 partition p2);

--step2：插入数据 expect：成功插入四条数据
insert into t_partition_hash_0077_01 values( 1,  '张三', 25);
insert into t_partition_hash_0077_01 values( 2,  '张三', 26);
insert into t_partition_hash_0077_01 values( 3,  '张三', 27);
insert into t_partition_hash_0077_01 values( 4,  '张三', 28);

--step3：创建普通表 expect：成功
drop table if exists t_partition_hash_0077_02;
create table t_partition_hash_0077_02(
id int,
name varchar(100),
age int);

--step4：交换数据 expect：分区表p1分区与普通表交换信息成功
alter table t_partition_hash_0077_01 exchange partition (p1) with table t_partition_hash_0077_02;

--step5：查看数据 expect：普通表中包含分区表p1分区的两条数据
select * from t_partition_hash_0077_02;

--step6：清理环境 expect：成功
drop table if exists t_partition_hash_0077_01;
drop table if exists t_partition_hash_0077_02;