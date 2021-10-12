--  @testpoint:openGauss关键字simple(非保留)，同时作为表名和列名带引号，并进行dml操作,simple列的值最终显示为1000

drop table if exists "simple" CASCADE;
create table "simple"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"simple" varchar(100) default 'simple'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "simple"(c_id,"simple") values(1,'hello');
insert into "simple"(c_id,"simple") values(2,'china');
update "simple" set "simple"=1000 where "simple"='hello';
delete from "simple" where "simple"='china';
select "simple" from "simple" where "simple"!='hello' order by "simple";

drop table "simple";

