--  @testpoint:openGauss关键字strip(非保留)，同时作为表名和列名带引号，并进行dml操作,strip列的值最终显示为1000

drop table if exists "strip" CASCADE;
create table "strip"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"strip" varchar(100) default 'strip'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "strip"(c_id,"strip") values(1,'hello');
insert into "strip"(c_id,"strip") values(2,'china');
update "strip" set "strip"=1000 where "strip"='hello';
delete from "strip" where "strip"='china';
select "strip" from "strip" where "strip"!='hello' order by "strip";

drop table "strip";

