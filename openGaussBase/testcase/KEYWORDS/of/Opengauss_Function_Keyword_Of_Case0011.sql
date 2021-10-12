--  @testpoint:openGauss关键字of(非保留)，同时作为表名和列名带引号，并进行dml操作,of列的值最终显示为1000

drop table if exists "of";
create table "of"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"of" varchar(100) default 'of'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "of"(c_id,"of") values(1,'hello');
insert into "of"(c_id,"of") values(2,'china');
update "of" set "of"=1000 where "of"='hello';
delete from "of" where "of"='china';
select "of" from "of" where "of"!='hello' order by "of";

drop table "of";
