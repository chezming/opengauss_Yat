-- @testpoint: 数字操作符@(绝对值)，入参为整数类型
drop table if exists data_01;
create table data_01 (clo1 int,clo2 SMALLINT);
insert into data_01 values (255, -25);
select @ clo1, @ clo2 from data_01;
SELECT  @124, @ -45 AS RESULT;
drop table if exists data_01;