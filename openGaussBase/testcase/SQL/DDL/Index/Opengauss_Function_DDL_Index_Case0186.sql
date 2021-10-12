--  @testpoint: 与join结合，on条件中使用索引

--建普通表
DROP TABLE if EXISTS test_index_table_186_01 CASCADE;
create table test_index_table_186_01(
c_int int
) WITH (ORIENTATION = row) partition by range(c_int)(
partition p1 values less than (100),
partition p2 values less than (1000),
partition p3 values less than (5000),
partition p4 values less than (10001)
);

drop index if exists index_186_01;
select relname from pg_class where relname like 'index_186_%' order by relname asc;
create index index_186_01 on test_index_table_186_01(c_int) local (partition p1,partition p2,partition p3,partition p4);
select relname from pg_class where relname like 'index_186_%' order by relname asc;
explain select * from test_index_table_186_01 where c_int >= 50 group by c_int;

DROP TABLE if EXISTS test_index_table_186_02 CASCADE;
create table test_index_table_186_02(
c_int int
) WITH (ORIENTATION = row) partition by range(c_int)(
partition p1 values less than (100),
partition p2 values less than (1000),
partition p3 values less than (5000),
partition p4 values less than (10001)
);

drop index if exists index_186_02;
select relname from pg_class where relname like 'index_186_%' order by relname asc;
create index index_186_02 on test_index_table_186_02(c_int) local (partition p1,partition p2,partition p3,partition p4);
select relname from pg_class where relname like 'index_186_%' order by relname asc;
explain select * from test_index_table_186_02 where c_int >= 50 group by c_int;

--join on
explain select * from test_index_table_186_01  a
join test_index_table_186_02  b
on a.c_int = b.c_int
where a.c_int >= 50;

--清理环境
DROP TABLE if EXISTS test_index_table_186_01 CASCADE;
DROP TABLE if EXISTS test_index_table_186_02 CASCADE;
