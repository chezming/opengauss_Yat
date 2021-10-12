--  @testpoint:openGauss关键字log(非保留)，同时作为表名和列名带引号，并进行dml操作,log列的值最终显示为1000

drop table if exists "log";
create table "log"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"log" varchar(100) default 'log'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "log"(c_id,"log") values(1,'hello');
insert into "log"(c_id,"log") values(2,'china');
update "log" set "log"=1000 where "log"='hello';
delete from "log" where "log"='china';
select "log" from "log" where "log"!='hello' order by "log";

drop table "log";
