--  @testpoint:openGauss关键字space(非保留)，同时作为表名和列名带引号，并进行dml操作,space列的值最终显示为1000

drop table if exists "space" CASCADE;
create table "space"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"space" varchar(100) default 'space'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "space"(c_id,"space") values(1,'hello');
insert into "space"(c_id,"space") values(2,'china');
update "space" set "space"=1000 where "space"='hello';
delete from "space" where "space"='china';
select "space" from "space" where "space"!='hello' order by "space";

drop table "space";

