-- @testpoint: 数字操作符+，最大值相加
drop table if exists data_01;
create table data_01 (clo1 BIGINT,clo2 BIGINT);
select clo1 + clo2 from data_01;
drop table if exists data_01;