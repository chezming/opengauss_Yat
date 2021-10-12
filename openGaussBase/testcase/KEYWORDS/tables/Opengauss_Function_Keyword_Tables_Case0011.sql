--  @testpoint:openGauss关键字tables(非保留)，同时作为表名和列名带引号，并进行dml操作,tables列的值最终显示为1000

drop table if exists "tables" CASCADE;
create table "tables"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"tables" varchar(100) default 'tables'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "tables"(c_id,"tables") values(1,'hello');
insert into "tables"(c_id,"tables") values(2,'china');
update "tables" set "tables"=1000 where "tables"='hello';
delete from "tables" where "tables"='china';
select "tables" from "tables" where "tables"!='hello' order by "tables";

drop table "tables";
