-- @testpoint: 数字操作符<<(二进制左移), 0左移或者左移0位
drop table if exists data_01;
create table data_01 (clo1 int,clo2 int);
insert into data_01 values (0, -32767);
select  clo1<<5 , clo2 <<0 from data_01;
SELECT 1<<0 AS RESULT;
drop table if exists data_01;