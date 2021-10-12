-- @testpoint: pg_stat_get_xact_tuples_inserted(oid)返回当前事务中表里插入的行数
alter system set autovacuum to off;
begin;
/
drop table if exists sales;
--创建表sales
CREATE TABLE sales
(prod_id NUMBER(6),
 cust_id NUMBER,
 time_id DATE,
 channel_id CHAR(1),
 promo_id NUMBER(6),
 quantity_sold NUMBER(3),
 amount_sold NUMBER(10,2)
);
SELECT pg_sleep(1);
select pg_stat_get_xact_tuples_inserted(a.oid) from PG_CLASS a where a.relname = 'sales';
-- 数据插入sales 1
INSERT INTO sales VALUES(1, 12, '2019-01-10 00:00:00', 'a', 1, 1, 1);
SELECT pg_sleep(1);
select pg_stat_get_xact_tuples_inserted(a.oid) from PG_CLASS a where a.relname = 'sales';
-- 数据插入sales 1
INSERT INTO sales VALUES(1, 12, '2019-02-01 00:00:00', 'b', 1, 1, 1);
SELECT pg_sleep(1);
select pg_stat_get_xact_tuples_inserted(a.oid) from PG_CLASS a where a.relname = 'sales';
-- 再添加数据 6
INSERT INTO sales VALUES(1, 12, '2019-02-05 00:00:00', 'c', 1, 1, 1);
INSERT INTO sales VALUES(1, 12, '2019-02-03 00:00:00', 'd', 1, 1, 1);
INSERT INTO sales VALUES(1, 12, '2019-02-05 00:00:00', 'e', 1, 1, 1);
INSERT INTO sales VALUES(1, 12, '2019-02-03 00:00:00', 'f', 1, 1, 1);
SELECT pg_sleep(1);
select pg_stat_get_xact_tuples_inserted(a.oid) from PG_CLASS a where a.relname = 'sales';
-- 删除数据   还是6,因为函数记录的是insert的次数
delete  from  sales  where channel_id = 'e';
SELECT pg_sleep(1);
select pg_stat_get_xact_tuples_inserted(a.oid) from PG_CLASS a where a.relname = 'sales';
-- 更新数据
update sales set time_id = '2017-12-10 00:00:00' where channel_id = 'a';
SELECT pg_sleep(1);
select pg_stat_get_xact_tuples_inserted(a.oid)  from PG_CLASS a where a.relname = 'sales';
end;
select pg_stat_get_xact_tuples_inserted(a.oid)  from PG_CLASS a where a.relname = 'sales';
drop table sales cascade;
alter system set autovacuum to on;