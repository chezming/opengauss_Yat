--  @testpoint:openGauss关键字schema_name(非保留)，同时作为表名和列名带引号，并进行dml操作,schema_name列的值最终显示为1000

drop table if exists "schema_name" CASCADE;
create table "schema_name"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"schema_name" varchar(100) default 'schema_name'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "schema_name"(c_id,"schema_name") values(1,'hello');
insert into "schema_name"(c_id,"schema_name") values(2,'china');
update "schema_name" set "schema_name"=1000 where "schema_name"='hello';
delete from "schema_name" where "schema_name"='china';
select "schema_name" from "schema_name" where "schema_name"!='hello' order by "schema_name";

drop table "schema_name";
