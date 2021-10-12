--  @testpoint:openGauss关键字duplicate(非保留)，同时作为表名和列名带引号，并进行dml操作,duplicate列的值最终显示为1000

drop table if exists "duplicate";
create table "duplicate"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"duplicate" varchar(100) default 'duplicate'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "duplicate"(c_id,"duplicate") values(1,'hello');
insert into "duplicate"(c_id,"duplicate") values(2,'china');
update "duplicate" set "duplicate"=1000 where "duplicate"='hello';
delete from "duplicate" where "duplicate"='china';
select "duplicate" from "duplicate" where "duplicate"!='hello' order by "duplicate";

drop table "duplicate";
