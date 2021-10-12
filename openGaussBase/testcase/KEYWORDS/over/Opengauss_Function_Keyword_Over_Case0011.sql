--  @testpoint:openGauss关键字over(非保留)，同时作为表名和列名带引号，并进行dml操作,over列的值最终显示为1000

drop table if exists "over";
create table "over"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"over" varchar(100) default 'over'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "over"(c_id,"over") values(1,'hello');
insert into "over"(c_id,"over") values(2,'china');
update "over" set "over"=1000 where "over"='hello';
delete from "over" where "over"='china';
select "over" from "over" where "over"!='hello' order by "over";

drop table "over";
