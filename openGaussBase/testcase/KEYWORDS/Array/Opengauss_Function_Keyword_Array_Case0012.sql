--  @testpoint:openGauss保留关键字Array同时作为表名和列名带引号,并使用该列结合limit排序,Array列的值按字母大小排序且只显示前2条数据
drop table if exists "Array";
create table "Array"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"Array" varchar(100) default 'Array'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--清理表数据
delete from "Array";

--插入数据
insert into "Array"(c_id,"Array") values(1,'hello');
insert into "Array"(c_id,"Array") values(2,'china');
insert into "Array"(c_id,"Array") values(3,'gauss');

--查看表数据
select "Array" from "Array" where "Array"!='hello' order by "Array" limit 2 ;

--清理环境
drop table "Array";