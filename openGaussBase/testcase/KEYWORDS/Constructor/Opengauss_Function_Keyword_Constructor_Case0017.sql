-- @testpoint: openGauss关键字constructor(非保留)，作为列名不带引号，使用时带单引号或反引号，大小写不匹配(合理报错)
----openGauss关键字constructor作为列名不带引号

drop table if exists constructor_test;
create table constructor_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	constructor char(50)
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);
insert into constructor_test(c_id,'constructor') values(2,'china');
insert into constructor_test(c_id,`constructor`) values(2,'china');
drop table if exists constructor_test;
