--  @testpoint:openGauss关键字overlay(非保留)，同时作为表名和列名带引号，并进行dml操作,overlay列的值最终显示为1000

drop table if exists "overlay";
create table "overlay"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"overlay" varchar(100) default 'overlay'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "overlay"(c_id,"overlay") values(1,'hello');
insert into "overlay"(c_id,"overlay") values(2,'china');
update "overlay" set "overlay"=1000 where "overlay"='hello';
delete from "overlay" where "overlay"='china';
select "overlay" from "overlay" where "overlay"!='hello' order by "overlay";

drop table "overlay";

