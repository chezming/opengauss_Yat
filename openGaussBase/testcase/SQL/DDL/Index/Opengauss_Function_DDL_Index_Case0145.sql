--  @testpoint: MOVE PARTITION：分区索引已设置表空间，设置为原有空间

drop tablespace if exists test_space_145_01;
CREATE TABLESPACE test_space_145_01 RELATIVE LOCATION 'tablespace/tablespace_1';

DROP TABLE if EXISTS test_index_table_145 CASCADE;
create table test_index_table_145(
c_int int,
c_date date
) WITH (ORIENTATION = row) partition by range(c_date)(
partition p1 values less than ('1990-01-01 00:00:00'),
partition p2 values less than ('2020-01-01 00:00:00')
);

--建索引
drop index if exists index_145_01;
create index index_145_01 on test_index_table_145(c_date) local (PARTITION p1 TABLESPACE test_space_145_01,PARTITION p2 TABLESPACE test_space_145_01);
select relname from pg_class where relname like 'index_145_%' order by relname;

--MOVE PARTITION
select spcname from PG_TABLESPACE where oid in
(select distinct reltablespace from PG_PARTITION where parentid=
(select relfilenode from pg_class where relname='index_145_01'));
ALTER INDEX index_145_01 MOVE PARTITION p1 TABLESPACE test_space_145_01;
ALTER INDEX index_145_01 MOVE PARTITION p2 TABLESPACE test_space_145_01;
select spcname from PG_TABLESPACE where oid in
(select distinct reltablespace from PG_PARTITION where parentid=
(select relfilenode from pg_class where relname='index_145_01'));

--清理环境
DROP TABLE if EXISTS test_index_table_145 CASCADE;
drop tablespace if exists test_space_145_01;