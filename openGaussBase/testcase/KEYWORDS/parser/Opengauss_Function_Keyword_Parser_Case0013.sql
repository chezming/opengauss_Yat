--  @testpoint:openGauss关键字parser(非保留)，同时作为表名和列名带引号，与union结合查询合并两个SELECT 语句查询

drop table if exists "parser";
create table "parser"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"parser" varchar(100) default 'parser'
)
PARTITION BY RANGE (c_integer)
(
	partition P_20180121 values less than (0),
	partition P_20190122 values less than (50000),
	partition P_20200123 values less than (100000),
	partition P_max values less than (maxvalue)
);

insert into "parser"(c_id,"parser") values(1,'hello');
insert into "parser"(c_id,"parser") values(2,'china');
insert into "parser"(c_id,"parser") values(3,'gauss');
---两个select语句合并查询，查询结果显示hello、china、gauss，对括号中的select子句取limit 2
select "parser" from "parser" where "parser"='hello'
union all (select "parser" from "parser" where "parser"!='hello' order by "parser" limit 2);

drop table "parser";