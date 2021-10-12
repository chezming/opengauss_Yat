-- @testpoint: pg_partition_indexes_size(oid,oid)指定OID代表的分区的索引使用的磁盘空间。其中，第一个oid为表的OID，第二个oid为分区的OID

create table test (a int)
with(orientation = column)
partition by range (a)
(
        partition test_p1 values less than (88),
        partition test_p2 values less than (99)
);
create index test_index on test (a) local;

insert into test values (59);
insert into test values (69);
insert into test values (90);

select pg_partition_indexes_size(a.oid, b.oid) from pg_class a, pg_partition b where a.oid=b.parentid and a.relname='test' and b.relname='test_p1';
select pg_partition_indexes_size(a.oid, b.oid) from pg_class a, pg_partition b where a.oid=b.parentid and a.relname='test' and b.relname='test_p2';

drop table test;