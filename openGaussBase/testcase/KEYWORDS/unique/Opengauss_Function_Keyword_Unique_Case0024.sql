--  @testpoint:opengauss关键字unique(保留)，作为存储过程名

--关键字不带引号-失败
drop procedure if exists unique;
create procedure unique(
section     number(6),
salary_sum out number(8,2),
staffs_count out integer)
is
begin
   select sum(salary), count(*) into salary_sum, staffs_count from staffs where section_id = section;
end;
/

--关键字带双引号-成功
drop procedure if exists "unique";
create procedure "unique"(
section     number(6),
salary_sum out number(8,2),
staffs_count out integer)
is
begin
   select sum(salary), count(*) into salary_sum, staffs_count from staffs where section_id = section;
end;
/
drop procedure "unique";
--关键字带单引号-合理报错
drop procedure if exists 'unique';
create procedure 'unique'(
section     number(6),
salary_sum out number(8,2),
staffs_count out integer)
is
begin
   select sum(salary), count(*) into salary_sum, staffs_count from staffs where section_id = section;
end;
/

--关键字带反引号-合理报错
drop procedure if exists `unique`;
create procedure `unique`(
section     number(6),
salary_sum out number(8,2),
staffs_count out integer)
is
begin
   select sum(salary), count(*) into salary_sum, staffs_count from staffs where section_id = section;
end;
/

