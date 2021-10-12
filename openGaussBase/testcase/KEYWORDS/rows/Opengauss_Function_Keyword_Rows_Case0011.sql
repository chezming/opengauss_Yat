--  @testpoint:openGauss关键字rows(非保留)，同时作为表名和列名带引号，并进行dml操作,rows列的值最终显示为1000

drop table if exists "rows" CASCADE;
create table "rows"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"rows" varchar(100) default 'rows'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "rows"(c_id,"rows") values(1,'hello');
insert into "rows"(c_id,"rows") values(2,'china');
update "rows" set "rows"=1000 where "rows"='hello';
delete from "rows" where "rows"='china';
select "rows" from "rows" where "rows"!='hello' order by "rows";

drop table "rows";
