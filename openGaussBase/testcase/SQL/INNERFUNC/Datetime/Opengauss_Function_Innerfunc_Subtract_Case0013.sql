-- @testpoint: reltime类型时间间隔相减
drop table if exists test_date01;
create table test_date01 (col1 reltime);
insert into test_date01 values ('60');
select date '2019-1-6' -  col1  from test_date01;
drop table if exists test_date01;