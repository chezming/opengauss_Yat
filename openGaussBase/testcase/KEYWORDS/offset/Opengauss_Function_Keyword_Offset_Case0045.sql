-- @testpoint: 表名和列名同时出现关键字offset，与dml结合
drop table if exists "offset";
create table "offset"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"offset" varchar(100) default 'offset'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);
insert into "offset"(c_id,"offset") values(1,'world');
insert into "offset"(c_id,"offset") values(2,'china');
update "offset" set "offset"=1000 where "offset"='world';
delete from "offset" where "offset"='china';
select "offset" from "offset" where "offset"!='world' order by "offset";
--清理环境
drop table if exists "offset";