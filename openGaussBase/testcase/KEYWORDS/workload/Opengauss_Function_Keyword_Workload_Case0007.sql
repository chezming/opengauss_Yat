--  @testpoint:openGauss关键字workload(非保留)，作为列名带引号并且更新时使用该列，建表成功，workload的值更新为100

drop table if exists explain_test;
create table explain_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer, 
	c_real real, c_double real, 
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38), 
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"workload" varchar(100) default 'workload'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

insert into explain_test(c_id,"workload") values(1,'hello');
update explain_test set "workload"=100;
select * from explain_test order by "workload";

drop table explain_test;
