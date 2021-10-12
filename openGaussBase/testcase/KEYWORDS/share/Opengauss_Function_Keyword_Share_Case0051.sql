--  @testpoint:定义和使用share列带反引号
drop table if exists zsharding_tbl;
create table zsharding_tbl(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	`share` char(50)
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);


insert into zsharding_tbl(c_id,`share`) values(2,'china');
update zsharding_tbl set `share`=1000;
insert into zsharding_tbl(c_id,`share`) values(2,'china');
select `share` from zsharding_tbl order by `share`;