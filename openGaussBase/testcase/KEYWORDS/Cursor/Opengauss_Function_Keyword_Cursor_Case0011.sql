--  @testpoint:openGauss关键字cursor(非保留)，同时作为表名和列名带引号，并进行dml操作,cursor列的值最终显示为1000

drop table if exists "cursor";
create table "cursor"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"cursor" varchar(100) default 'cursor'
)
PARTITION BY RANGE (c_integer)
(
	partition P_20180121 values less than (0),
	partition P_20190122 values less than (50000),
	partition P_20200123 values less than (100000),
	partition P_max values less than (maxvalue)
);



insert into "cursor"(c_id,"cursor") values(1,'hello');
insert into "cursor"(c_id,"cursor") values(2,'china');
update "cursor" set "cursor"=1000 where "cursor"='hello';
delete from "cursor" where "cursor"='china';
select "cursor" from "cursor" where "cursor"!='hello' order by "cursor";

drop table "cursor";

