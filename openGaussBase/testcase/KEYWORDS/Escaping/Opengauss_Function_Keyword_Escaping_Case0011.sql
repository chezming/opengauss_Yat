--  @testpoint:openGauss关键字escaping(非保留)，同时作为表名和列名带引号，并进行dml操作,escaping列的值最终显示为1000

drop table if exists "escaping";
create table "escaping"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"escaping" varchar(100) default 'escaping'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "escaping"(c_id,"escaping") values(1,'hello');
insert into "escaping"(c_id,"escaping") values(2,'china');
update "escaping" set "escaping"=1000 where "escaping"='hello';
delete from "escaping" where "escaping"='china';
select "escaping" from "escaping" where "escaping"!='hello' order by "escaping";

drop table "escaping";
