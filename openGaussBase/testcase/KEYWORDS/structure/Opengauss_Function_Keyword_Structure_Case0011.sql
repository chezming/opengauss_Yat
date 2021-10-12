--  @testpoint:openGauss关键字structure(非保留)，同时作为表名和列名带引号，并进行dml操作,structure列的值最终显示为1000

drop table if exists "structure" CASCADE;
create table "structure"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"structure" varchar(100) default 'structure'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "structure"(c_id,"structure") values(1,'hello');
insert into "structure"(c_id,"structure") values(2,'china');
update "structure" set "structure"=1000 where "structure"='hello';
delete from "structure" where "structure"='china';
select "structure" from "structure" where "structure"!='hello' order by "structure";

drop table "structure";
