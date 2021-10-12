--  @testpoint:openGauss关键字disconnect(非保留)，作为列名带引号并且更新时使用该列，建表成功，disconnect的值更新为100

drop table if exists disconnect_test;
create table disconnect_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer, 
	c_real real, c_double real, 
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38), 
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"disconnect" varchar(100) default 'disconnect'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

insert into disconnect_test(c_id,"disconnect") values(1,'hello');
update disconnect_test set "disconnect"=100;
select * from disconnect_test order by "disconnect";

drop table disconnect_test;