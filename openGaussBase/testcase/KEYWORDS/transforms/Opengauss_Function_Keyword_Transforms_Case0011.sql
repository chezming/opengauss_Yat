--  @testpoint:openGauss关键字transforms(非保留)，同时作为表名和列名带引号，并进行dml操作,transforms列的值最终显示为1000

drop table if exists "transforms" CASCADE;
create table "transforms"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"transforms" varchar(100) default 'transforms'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "transforms"(c_id,"transforms") values(1,'hello');
insert into "transforms"(c_id,"transforms") values(2,'china');
update "transforms" set "transforms"=1000 where "transforms"='hello';
delete from "transforms" where "transforms"='china';
select "transforms" from "transforms" where "transforms"!='hello' order by "transforms";

drop table "transforms";
