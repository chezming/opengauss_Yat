--  @testpoint:openGauss关键字Key_Type(非保留)，同时作为表名和列名带引号，并进行dml操作,Key_Type列的值最终显示为1000

drop table if exists "Key_Type";
create table "Key_Type"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"Key_Type" varchar(100) default 'Key_Type'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "Key_Type"(c_id,"Key_Type") values(1,'hello');
insert into "Key_Type"(c_id,"Key_Type") values(2,'china');
update "Key_Type" set "Key_Type"=1000 where "Key_Type"='hello';
delete from "Key_Type" where "Key_Type"='china';
select "Key_Type" from "Key_Type" where "Key_Type"!='hello' order by "Key_Type";

drop table "Key_Type";
