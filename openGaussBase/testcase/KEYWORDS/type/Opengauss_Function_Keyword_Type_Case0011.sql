--  @testpoint:openGauss关键字type(非保留)，同时作为表名和列名带引号，并进行dml操作,type列的值最终显示为1000

drop table if exists "type" CASCADE;
create table "type"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"type" varchar(100) default 'type'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "type"(c_id,"type") values(1,'hello');
insert into "type"(c_id,"type") values(2,'china');
update "type" set "type"=1000 where "type"='hello';
delete from "type" where "type"='china';
select "type" from "type" where "type"!='hello' order by "type";

drop table "type";

