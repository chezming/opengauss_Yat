--  @testpoint:openGauss保留关键字freeze作为列名

--Freeze作为列名大小写混合（合理报错）
drop table if exists test_tbl;
create table test_tbl(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	Freeze text
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--freeze作为列名,全小写（合理报错）
drop table if exists test_tbl;
create table test_tbl(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	freeze text
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);