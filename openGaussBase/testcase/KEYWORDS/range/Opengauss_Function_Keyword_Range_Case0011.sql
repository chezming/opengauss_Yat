--  @testpoint:openGauss关键字range(非保留)，同时作为表名和列名带引号，并进行dml操作,range列的值最终显示为1000

drop table if exists "range";
create table "range"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"range" varchar(100) default 'range'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "range"(c_id,"range") values(1,'hello');
insert into "range"(c_id,"range") values(2,'china');
update "range" set "range"=1000 where "range"='hello';
delete from "range" where "range"='china';
select "range" from "range" where "range"!='hello' order by "range";

drop table "range";

