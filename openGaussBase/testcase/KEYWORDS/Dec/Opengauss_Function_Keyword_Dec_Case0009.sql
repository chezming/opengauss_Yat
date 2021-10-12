--  @testpoint:openGauss关键字dec(非保留)，作为列名带引号并且排序时使用该列,建表成功，dec列按字母大小排序

drop table if exists dec_test;
create table dec_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer, 
	c_real real, c_double real, 
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38), 
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"dec" varchar(100) default 'dec'
) 
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

insert into dec_test(c_id,"dec") values(1,'hello');
select * from dec_test order by "dec";
drop table dec_test;
