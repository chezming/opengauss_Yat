--  @testpoint:openGauss保留关键字Collation同时作为表名和列名带引号，并进行dml操作,Collation列的值最终显示为1000
drop table if exists "Collation";
create table "Collation"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"Collation" varchar(100) default 'Collation'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--插入数据
insert into "Collation"(c_id,"Collation") values(1,'hello');
insert into "Collation"(c_id,"Collation") values(2,'china');

--更新表数据
update "Collation" set "Collation"=1000 where "Collation"='hello';

--清理表数据
delete from "Collation" where "Collation"='china';

--查看表数据
select "Collation" from "Collation" where "Collation"!='hello' order by "Collation";

--清理环境
drop table "Collation";