--  @testpoint:openGauss保留关键字true同时作为表名和列名带引号，并进行dml操作,true列的值最终显示为1000
drop table if exists "true";
create table "true"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"true" varchar(100) default 'true'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "true"(c_id,"true") values(1,'hello');
insert into "true"(c_id,"true") values(2,'china');
update "true" set "true"=1000 where "true"='hello';
delete from "true" where "true"='china';
select "true" from "true" where "true"!='hello' order by "true";

drop table "true";