--  @testpoint:openGauss关键字Int(非保留)，同时作为表名和列名带引号，并进行dml操作,Int列的值最终显示为1000

drop table if exists "Int";
create table "Int"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"Int" varchar(100) default 'Int'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "Int"(c_id,"Int") values(1,'hello');
insert into "Int"(c_id,"Int") values(2,'china');
update "Int" set "Int"=1000 where "Int"='hello';
delete from "Int" where "Int"='china';
select "Int" from "Int" where "Int"!='hello' order by "Int";

drop table "Int";

