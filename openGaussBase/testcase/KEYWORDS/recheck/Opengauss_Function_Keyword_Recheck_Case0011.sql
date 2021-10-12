--  @testpoint:openGauss关键字recheck(非保留)，同时作为表名和列名带引号，并进行dml操作,recheck列的值最终显示为1000

drop table if exists "recheck";
create table "recheck"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"recheck" varchar(100) default 'recheck'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "recheck"(c_id,"recheck") values(1,'hello');
insert into "recheck"(c_id,"recheck") values(2,'china');
update "recheck" set "recheck"=1000 where "recheck"='hello';
delete from "recheck" where "recheck"='china';
select "recheck" from "recheck" where "recheck"!='hello' order by "recheck";

drop table "recheck";
