--  @testpoint: reindex：行存drop掉之后重新reindex：合理报错

--建普通表
DROP TABLE if EXISTS test_index_table_157 CASCADE;
create table test_index_table_157(
c_int int
) WITH (ORIENTATION = row) partition by range(c_int)(
partition p1 values less than (100),
partition p2 values less than (1000),
partition p3 values less than (5000),
partition p4 values less than (10001)
);

--建索引
drop index if exists index_157_01;
create index index_157_01 on test_index_table_157(c_int) local (PARTITION p1,PARTITION p2,PARTITION p3,PARTITION p4);
select relname from pg_class where relname like 'index_157_%' order by relname;
drop index if exists index_157_01;
REINDEX INDEX  index_157_01;

--清理环境
DROP TABLE if EXISTS test_index_table_157 CASCADE;