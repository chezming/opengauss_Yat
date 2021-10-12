-- @testpoint: pg_stat_get_partition_tuples_updated(oid)查询相应分区表中已更新行的数量。
alter system set autovacuum to off;
drop table if exists sales;
select pg_stat_reset();
--创建表sales
CREATE TABLE sales
(prod_id NUMBER(6),
 cust_id NUMBER,
 time_id DATE,
 channel_id CHAR(1),
 promo_id NUMBER(6),
 quantity_sold NUMBER(3),
 amount_sold NUMBER(10,2)
)
PARTITION BY RANGE (time_id)
INTERVAL('1 day')
( PARTITION p1 VALUES LESS THAN ('2018-01-01 00:00:00'),
  PARTITION p2 VALUES LESS THAN ('2019-12-31 00:00:00')
);
SELECT pg_sleep(2);
select pg_stat_get_partition_tuples_updated(a.oid) from pg_partition  a, pg_class b where a.relname = 'p1' and b.oid=a.parentid and b.relname='sales';
SELECT pg_sleep(2);
select pg_stat_get_partition_tuples_updated(a.oid) from pg_partition  a, pg_class b where a.relname = 'p2' and b.oid=a.parentid and b.relname='sales';
-- 数据插入分区p1、p2
INSERT INTO sales VALUES(1, 12, '2017-01-10 00:00:00', 'a', 1, 1, 1);
INSERT INTO sales VALUES(1, 12, '2019-05-01 10:00:00', 'b', 1, 1, 1);
SELECT pg_sleep(2);
select pg_stat_get_partition_tuples_updated(a.oid) from pg_partition  a, pg_class b where a.relname = 'p1' and b.oid=a.parentid and b.relname='sales';
SELECT pg_sleep(2);
select pg_stat_get_partition_tuples_updated(a.oid) from pg_partition  a, pg_class b where a.relname = 'p2' and b.oid=a.parentid and b.relname='sales';
-- 更新数据 相同的update计两次
update sales set time_id = '2017-12-10 00:00:00' where channel_id = 'a';
update sales set time_id = '2017-12-10 00:00:00' where channel_id = 'a';
SELECT pg_sleep(2);
select pg_stat_get_partition_tuples_updated(a.oid) from pg_partition  a, pg_class b where a.relname = 'p1' and b.oid=a.parentid and b.relname='sales';
update sales set time_id = '2019-06-01 10:00:00' where channel_id = 'b';
SELECT pg_sleep(2);
select pg_stat_get_partition_tuples_updated(a.oid) from pg_partition  a, pg_class b where a.relname = 'p1' and b.oid=a.parentid and b.relname='sales';
select pg_stat_get_partition_tuples_updated(a.oid) from pg_partition  a, pg_class b where a.relname = 'p2' and b.oid=a.parentid and b.relname='sales';
drop table sales cascade;
alter system set autovacuum to on;