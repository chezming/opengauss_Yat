-- @testpoint: openGauss保留关键字similar同时作为表名和列名带引号，并进行dml操作,similar列的值最终显示为1000
drop table if exists "similar";
create table "similar"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"similar" varchar(100) default 'similar'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--插入数据
insert into "similar"(c_id,"similar") values(1,'hello');
insert into "similar"(c_id,"similar") values(2,'china');

--更新表数据
update "similar" set "similar"=1000 where "similar"='hello';

--清理表数据
delete from "similar" where "similar"='china';

--查看表数据
select "similar" from "similar" where "similar"!='hello' order by "similar";

--清理环境
drop table "similar";