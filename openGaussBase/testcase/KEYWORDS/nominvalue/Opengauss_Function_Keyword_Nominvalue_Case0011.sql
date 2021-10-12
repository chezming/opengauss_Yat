--  @testpoint:openGauss关键字nominvalue(非保留)，同时作为表名和列名带引号，并进行dml操作,nominvalue列的值最终显示为1000

drop table if exists "nominvalue";
create table "nominvalue"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"nominvalue" varchar(100) default 'nominvalue'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "nominvalue"(c_id,"nominvalue") values(1,'hello');
insert into "nominvalue"(c_id,"nominvalue") values(2,'china');
update "nominvalue" set "nominvalue"=1000 where "nominvalue"='hello';
delete from "nominvalue" where "nominvalue"='china';
select "nominvalue" from "nominvalue" where "nominvalue"!='hello' order by "nominvalue";

drop table "nominvalue";

