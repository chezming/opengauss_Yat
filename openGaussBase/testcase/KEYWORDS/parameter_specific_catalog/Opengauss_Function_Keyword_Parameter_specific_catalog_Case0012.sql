--  @testpoint:openGauss关键字parameter_specific_catalog(非保留)同时作为表名和列名带引号,并使用该列结合limit排序,parameter_specific_catalog列的值按字母大小排序且只显示前2条数据

drop table if exists "parameter_specific_catalog";
create table "parameter_specific_catalog"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"parameter_specific_catalog" varchar(100) default 'parameter_specific_catalog'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);
delete from "parameter_specific_catalog";
insert into "parameter_specific_catalog"(c_id,"parameter_specific_catalog") values(1,'hello');
insert into "parameter_specific_catalog"(c_id,"parameter_specific_catalog") values(2,'china');
insert into "parameter_specific_catalog"(c_id,"parameter_specific_catalog") values(3,'gauss');
select "parameter_specific_catalog" from "parameter_specific_catalog" where "parameter_specific_catalog"!='hello' order by "parameter_specific_catalog" limit 2 ;

drop table "parameter_specific_catalog";

