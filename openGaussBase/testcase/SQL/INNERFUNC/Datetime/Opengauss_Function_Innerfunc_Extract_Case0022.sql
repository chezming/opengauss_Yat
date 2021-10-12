-- @testpoint: EXTRACT函数传入source为timestamp with time zone，获取自1970-01-01 00:00:00-00 UTC以来的秒数
drop table if exists test_date01;
create table test_date01 (clo1 timestamp with time zone);
insert into test_date01 values ('9999-01-01 00:00:00-08');
select EXTRACT(EPOCH FROM clo1) from test_date01;
SELECT EXTRACT(EPOCH FROM timestamp with time zone '0001-01-01 00:00:00-01');
SELECT EXTRACT(EPOCH FROM timestamp with time zone '9999-01-01 00:00:00+08');
SELECT EXTRACT(EPOCH FROM timestamp with time zone '9999-01-02 00:00:00 pst');
drop table if exists test_date01;