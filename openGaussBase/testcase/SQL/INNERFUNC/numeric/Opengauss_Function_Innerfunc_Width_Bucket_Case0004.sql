-- @testpoint: width_bucket函数op处于右边界
drop table if exists data_01;
create table data_01 (clo1 int,clo2 int);
insert into data_01 values (5,-2);
select width_bucket(clo1,2,5,5) from data_01;
select width_bucket(clo2,-3,-2,5) from data_01;
drop table if exists data_01;