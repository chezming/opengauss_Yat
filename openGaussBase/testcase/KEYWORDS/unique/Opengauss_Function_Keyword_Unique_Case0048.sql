-- @testpoint: 删除时，使用unique
drop table if exists zsharding_tbl;
create table zsharding_tbl(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"unique" varchar(100) default 'unique'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

insert into zsharding_tbl(c_id,"unique") values(1,'world');
insert into zsharding_tbl(c_id) values(2);
delete from zsharding_tbl where "unique"='world';
select * from zsharding_tbl order by "unique";

--清理环境
drop table if exists zsharding_tbl;