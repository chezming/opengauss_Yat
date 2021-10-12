--  @testpoint:openGauss保留关键字symmetric同时作为表名和列名带引号，并进行dml操作,symmetric列的值最终显示为1000
drop table if exists "symmetric";
create table "symmetric"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"symmetric" varchar(100) default 'symmetric'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "symmetric"(c_id,"symmetric") values(1,'hello');
insert into "symmetric"(c_id,"symmetric") values(2,'china');
update "symmetric" set "symmetric"=1000 where "symmetric"='hello';
delete from "symmetric" where "symmetric"='china';
select "symmetric" from "symmetric" where "symmetric"!='hello' order by "symmetric";

drop table "symmetric";