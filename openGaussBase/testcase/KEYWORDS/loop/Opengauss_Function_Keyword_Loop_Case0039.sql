-- @testpoint: 列名和表名为aloop，并且定义loop列default值
drop table if exists loop;
create table loop(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	loop text  default 'gauss'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

insert into loop(c_id,loop) values(1,'123');
insert into loop(c_id) values(2);
select * from loop order by 1;
--清理环境
drop table if exists loop cascade;