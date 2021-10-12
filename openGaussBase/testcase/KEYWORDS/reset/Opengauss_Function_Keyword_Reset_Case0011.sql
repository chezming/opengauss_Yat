--  @testpoint:openGauss关键字reset(非保留)，同时作为表名和列名带引号，并进行dml操作,reset列的值最终显示为1000

drop table if exists "reset";
create table "reset"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"reset" varchar(100) default 'reset'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "reset"(c_id,"reset") values(1,'hello');
insert into "reset"(c_id,"reset") values(2,'china');
update "reset" set "reset"=1000 where "reset"='hello';
delete from "reset" where "reset"='china';
select "reset" from "reset" where "reset"!='hello' order by "reset";

drop table "reset";
