--  @testpoint:openGauss关键字binary_double(非保留,作为列名带双引号，binary_double大小写混合，建表成功
--创建表
drop table if exists binary_double_test;
create table binary_double_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"Binary_double" char(50)
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--查询表内容
select * from binary_double_test;

--清理环境
drop table binary_double_test;

--openGauss关键字binary_double(非保留,作为列名带双引号，binary_double大小写匹配，建表成功
drop table if exists binary_double_test;
create table binary_double_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"binary_double" char(50)
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--查询表内容
select * from binary_double_test;

--清理环境
drop table binary_double_test;