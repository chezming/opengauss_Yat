-- @testpoint: 结合日期函数，有效边界值测试

drop table if exists test_timestamp01;
create table test_timestamp01 (name timestamp);
insert into test_timestamp01 values (to_timestamp('0001-01-01 00:00:00.000000','yyyy-mm-dd hh24:mi:ss.ff'));
insert into test_timestamp01 values (to_timestamp('9999-12-31 23:59:59.999999','yyyy-mm-dd hh24:mi:ss.ff'));
select * from test_timestamp01;
drop table if exists test_timestamp01;