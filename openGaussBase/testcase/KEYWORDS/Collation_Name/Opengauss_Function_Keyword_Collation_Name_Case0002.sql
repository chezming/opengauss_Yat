--  @testpoint:openGauss关键字Collation_Name(非保留),作为列名带双引号，Collation_Name大小写混合，建表成功

drop table if exists Collation_Name_test;
create table Collation_Name_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"Collation_Name" char(50)
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

select * from Collation_Name_test;
drop table Collation_Name_test;
--openGauss关键字Collation_Name(非保留),作为列名带双引号，Collation_Name大小写匹配，建表成功

drop table if exists Collation_Name_test;
create table Collation_Name_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"collation_name" char(50)
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

select * from Collation_Name_test;
drop table Collation_Name_test;