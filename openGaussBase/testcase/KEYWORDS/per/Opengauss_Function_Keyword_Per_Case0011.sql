--  @testpoint:openGauss关键字per(非保留)，同时作为表名和列名带引号，并进行dml操作,per列的值最终显示为1000

drop table if exists "per";
create table "per"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"per" varchar(100) default 'per'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "per"(c_id,"per") values(1,'hello');
insert into "per"(c_id,"per") values(2,'china');
update "per" set "per"=1000 where "per"='hello';
delete from "per" where "per"='china';
select "per" from "per" where "per"!='hello' order by "per";

drop table "per";

