--  @testpoint:openGauss关键字Datetime_Interval_Code(非保留),作为列名带双引号，Datetime_Interval_Code大小写混合，建表成功

drop table if exists Datetime_Interval_Code_test;
create table Datetime_Interval_Code_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"Datetime_Interval_Code" char(50)
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

select * from Datetime_Interval_Code_test;
drop table Datetime_Interval_Code_test;
--openGauss关键字datetime_interval_code(非保留),作为列名带双引号，datetime_interval_code大小写匹配，建表成功

drop table if exists Datetime_Interval_Code_test;
create table Datetime_Interval_Code_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"datetime_interval_code" char(50)
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

select * from Datetime_Interval_Code_test;
drop table Datetime_Interval_Code_test;