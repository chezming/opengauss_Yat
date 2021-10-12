--  @testpoint:openGauss关键字equals(非保留)，同时作为表名和列名带引号，并进行dml操作,equals列的值最终显示为1000

drop table if exists "equals";
create table "equals"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"equals" varchar(100) default 'equals'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "equals"(c_id,"equals") values(1,'hello');
insert into "equals"(c_id,"equals") values(2,'china');
update "equals" set "equals"=1000 where "equals"='hello';
delete from "equals" where "equals"='china';
select "equals" from "equals" where "equals"!='hello' order by "equals";

drop table "equals";
