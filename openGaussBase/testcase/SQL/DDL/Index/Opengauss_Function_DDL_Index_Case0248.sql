-- @testpoint: 行分区表创建btree表达式索引,合理报错

--1.创建表
create table test_index_table_248(id int,name varchar) WITH (ORIENTATION = row)
PARTITION BY RANGE(id)(
        PARTITION P1 VALUES LESS THAN(100),
        PARTITION P2 VALUES LESS THAN(1000),
        PARTITION P3 VALUES LESS THAN(MAXVALUE))
;
--2.插入数据
insert into test_index_table_248 values (generate_series(1,2000),'test');
--3.创建索引
create index exp_local on test_index_table_248 using btree((id+2)) local (partition P1, partition P2, partition P3);
--4.解析索引
SET ENABLE_SEQSCAN=off;
explain select  * from test_index_table_248 where (id+2)>300;
--5.查询结果
SET ENABLE_SEQSCAN=off;
select  count(*) from test_index_table_248 where (id+2)>300;
--6.创建全局索引
create index exp_global on test_index_table_248 using btree((id+2)) global;
--解析索引
SET ENABLE_SEQSCAN=off;
explain select  * from test_index_table_248 where id>300;
--7.查询结果
SET ENABLE_SEQSCAN=off;
select  count(*) from test_index_table_248 where id>300;

--tearDown
drop table if exists test_index_table_248 cascade;