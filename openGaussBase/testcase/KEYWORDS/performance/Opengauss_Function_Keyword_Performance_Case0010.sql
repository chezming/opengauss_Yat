--  @testpoint:openGauss保留关键字performance同时作为表名和列名带引号，建表成功
drop table if exists "performance";
create table "performance"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"performance" varchar(100) default 'performance'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--查看表数据
select "performance" from "performance";

--清理环境
drop table "performance";