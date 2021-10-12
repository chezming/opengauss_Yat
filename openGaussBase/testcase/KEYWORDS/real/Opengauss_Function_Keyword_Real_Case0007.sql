--  @testpoint:openGauss关键字real(非保留)，作为列名带引号并且更新时使用该列，建表成功，real的值更新为100

drop table if exists real_test;
create table real_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer, 
	c_real real, c_double real, 
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38), 
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"real" varchar(100) default 'real'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

insert into real_test(c_id,"real") values(1,'hello');
update real_test set "real"=100;
select * from real_test order by "real";

drop table real_test;