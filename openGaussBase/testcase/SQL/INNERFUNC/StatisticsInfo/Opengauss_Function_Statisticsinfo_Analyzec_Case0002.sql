-- @testpoint: pg_stat_get_analyze_count(oid)函数的异常校验，合理报错
drop table if exists t1;
select pg_stat_reset();
create table t1(id int);
analyze t1;
SELECT pg_sleep(1);
-- testpoint:空值、多参、少参、oid错误
select pg_stat_get_analyze_count('') from pg_class  a where a.relname = 't1';
select pg_stat_get_analyze_count(a.oid,a.oid) = 1 from pg_class  a where a.relname = 't1';
select pg_stat_get_analyze_count() from pg_class  a where a.relname = 't1';
select pg_stat_get_analyze_count('&^%%^');
drop table t1 cascade;