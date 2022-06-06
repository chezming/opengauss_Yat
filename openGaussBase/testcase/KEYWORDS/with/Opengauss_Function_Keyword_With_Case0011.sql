--  @testpoint:openGauss保留关键字with同时作为表名和列名带引号，并进行dml操作,with列的值最终显示为1000
drop table if exists "with";
create table "with"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"with" varchar(100) default 'with'
)
PARTITION BY RANGE (c_integer)
(
	partition P_20180121 values less than (0),
	partition P_20190122 values less than (50000),
	partition P_20200123 values less than (100000),
	partition P_max values less than (maxvalue)
);

--插入数据
insert into "with"(c_id,"with") values(1,'hello');
insert into "with"(c_id,"with") values(2,'china');

--更新表数据
update "with" set "with"=1000 where "with"='hello';

--清理表数据
delete from "with" where "with"='china';

--查看表数据
select "with" from "with" where "with"!='hello' order by "with";

--清理环境
drop table "with";