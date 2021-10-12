--  @testpoint:openGauss关键字concurrently(非保留)，同时作为表名和列名带引号，并进行dml操作,concurrently列的值最终显示为1000

drop table if exists "concurrently";
create table "concurrently"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"concurrently" varchar(100) default 'concurrently'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "concurrently"(c_id,"concurrently") values(1,'hello');
insert into "concurrently"(c_id,"concurrently") values(2,'china');
update "concurrently" set "concurrently"=1000 where "concurrently"='hello';
delete from "concurrently" where "concurrently"='china';
select "concurrently" from "concurrently" where "concurrently"!='hello' order by "concurrently";

drop table "concurrently";
