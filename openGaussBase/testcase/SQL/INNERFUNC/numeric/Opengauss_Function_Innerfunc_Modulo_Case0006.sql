-- @testpoint: 数字操作符%(求余),货币类型求余，合理报错
drop table if exists data_01;
create table data_01 (clo1 money,clo2 money);
insert into data_01 values (12.34, 0.01);
select clo1 % 20 from data_01;
drop table if exists data_01;