-- @testpoint: reltime时间间隔与负数相除
drop table if exists test_date01;
create table test_date01 (col1 reltime);
insert into test_date01 values ('-365');
select col1 / double precision '1.5' from test_date01;
select col1/2  from test_date01;
drop table if exists test_date01;