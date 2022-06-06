-- @testpoint: List分区表结合表约束check,list分区表结合列约束check，部分测试点合理报错

--step1:创建list分区表,结合表约束;expect:成功
drop table if exists t_partition_list_0069_01;
create table t_partition_list_0069_01
(id                int,
age                int,
number             int,
text               VARCHAR2(2000),
check(age>0 and number>0))
partition by list(id)
(partition p1 values(10),
 partition p2 values(20));

--step2:插入数据;expect:合理报错
insert into  t_partition_list_0069_01 values(10,10,10,'hahahahah');
insert into  t_partition_list_0069_01 values(10,-1,10,'hahahahah');
insert into  t_partition_list_0069_01 values(10,10,-10,'hahahahah');
insert into  t_partition_list_0069_01 values(10,-10,-10,'hahahahah');

--step3:查看数据
select * from t_partition_list_0069_01;

--step4:创建list分区表,结合列约束;expect:成功
drop table if exists t_partition_list_0069_02;
create table t_partition_list_0069_02
(id                int,
age                int check(age>0),
number             int,
text               varchar2(2000))
partition by list(id)
(partition p1 values(10),
 partition p2 values(20));

--step5:插入数据;expect:合理报错
insert into  t_partition_list_0069_02 values(10,10,10,'hahahahah');
insert into  t_partition_list_0069_02 values(10,-10,10,'hahahahah');
insert into  t_partition_list_0069_02 values(10,0,10,'hahahahah');

--step6:查看数据
select * from t_partition_list_0069_02;

--step7:清理环境
drop table if exists t_partition_list_0069_01;
drop table if exists t_partition_list_0069_02;


