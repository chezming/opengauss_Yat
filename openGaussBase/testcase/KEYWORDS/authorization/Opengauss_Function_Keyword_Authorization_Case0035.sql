--  @testpoint:列名为authorization，并且定义authorization列default值,应该报错
drop table if exists tt;
create  table tt(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_dauthorizatione date, c_dauthorizationetime date, c_timestamp timestamp,
	authorization text  default 'gauss'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

