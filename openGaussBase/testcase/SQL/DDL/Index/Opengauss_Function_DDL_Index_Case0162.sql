--  @testpoint: partition_name：分区的名称

--建普通表
DROP TABLE if EXISTS test_index_table_162 CASCADE;
create table test_index_table_162(
c_int int
) WITH (ORIENTATION = row) partition by range(c_int)(
partition p1 values less than (100),
partition p2 values less than (1000),
partition p3 values less than (5000),
partition p4 values less than (10001)
);

--建local索引
drop index if exists index_162_01;
create index index_162_01 on test_index_table_162(c_int) local (PARTITION p1,PARTITION p2,PARTITION p3,PARTITION p4);
select relname from pg_class where relname like 'index_162_%' order by relname;
explain select * from test_index_table_162 where c_int > 500 group by c_int;

--reindex
alter index index_162_01 MODIFY PARTITION p2 UNUSABLE;
explain select * from test_index_table_162 where c_int > 500 group by c_int;
REINDEX table test_index_table_162 PARTITION p2;
explain select * from test_index_table_162 where c_int > 500 group by c_int;
alter index index_162_01 MODIFY PARTITION p2 UNUSABLE;
explain select * from test_index_table_162 where c_int > 500 group by c_int;
REINDEX table test_index_table_162 PARTITION p2 FORCE;
explain select * from test_index_table_162 where c_int > 500 group by c_int;

--清理环境
DROP TABLE if EXISTS test_index_table_162 CASCADE;