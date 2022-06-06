-- @testpoint: pg_stat_get_db_blocks_hit(oid)函数的异常校验，合理报错
-- 先清理环境
drop table if exists sales;
select pg_stat_reset();
--创建表sales
CREATE TABLE sales
(prod_id numeric(6),
 cust_id numeric,
 time_id DATE,
 channel_id CHAR(1),
 promo_id numeric(6),
 quantity_sold numeric(3),
 amount_sold numeric(10,2)
);
INSERT INTO sales VALUES(1, 12, '2018-01-10 00:00:00', 'a', 1, 1, 1);
-- testpoint:空值、多参、少参、oid错误
select pg_stat_get_db_blocks_hit('') from PG_DATABASE a where a.datname = CURRENT_CATALOG;
select pg_stat_get_db_blocks_hit(a.oid,a.oid) = 1 from PG_DATABASE a where a.datname = CURRENT_CATALOG;
select pg_stat_get_db_blocks_hit() from PG_DATABASE a where a.datname = CURRENT_CATALOG;
select pg_stat_get_db_blocks_hit(99999999999999999999);
select pg_stat_get_db_blocks_hit('&^%%^');
-- 恢复环境
drop table sales cascade;