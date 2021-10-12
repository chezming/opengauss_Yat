--  @testpoint:openGauss关键字free(非保留)，同时作为表名和列名带引号，并进行dml操作,free列的值最终显示为1000

drop table if exists "free";
create table "free"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"free" varchar(100) default 'free'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "free"(c_id,"free") values(1,'hello');
insert into "free"(c_id,"free") values(2,'china');
update "free" set "free"=1000 where "free"='hello';
delete from "free" where "free"='china';
select "free" from "free" where "free"!='hello' order by "free";

drop table "free";
