--  @testpoint:openGauss关键字class_origin(非保留),作为列名带双引号，class_origin大小写混合，建表成功
--创建表
drop table if exists class_origin_test;
create table class_origin_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"Class_origin" char(50)
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--查询表内容
select * from class_origin_test;

--清理环境
drop table class_origin_test;

--openGauss关键字class_origin(非保留,作为列名带双引号，class_origin大小写匹配，建表成功
drop table if exists class_origin_test;
create table class_origin_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"class_origin" char(50)
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--查询表内容
select * from class_origin_test;

--清理环境
drop table class_origin_test;