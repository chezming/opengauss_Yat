--  @testpoint:openGauss保留关键字column同时作为表名和列名带引号,并使用该列结合limit排序,column列的值按字母大小排序且只显示前2条数据
drop table if exists "column";
create table "column"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"column" varchar(100) default 'column'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);
delete from "column";
insert into "column"(c_id,"column") values(1,'hello');
insert into "column"(c_id,"column") values(2,'china');
insert into "column"(c_id,"column") values(3,'gauss');
select "column" from "column" where "column"!='hello' order by "column" limit 2 ;

drop table "column";