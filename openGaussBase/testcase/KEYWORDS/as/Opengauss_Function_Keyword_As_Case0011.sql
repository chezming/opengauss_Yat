--  @testpoint:openGauss保留关键字As同时作为表名和列名带引号，并进行dml操作,As列的值最终显示为1000
drop table if exists "As";
create table "As"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"As" varchar(100) default 'As'
)
PARTITION BY RANGE (c_integer)
(
	partition P_20180121 values less than (0),
	partition P_20190122 values less than (50000),
	partition P_20200123 values less than (100000),
	partition P_max values less than (maxvalue)
);

--插入数据
insert into "As"(c_id,"As") values(1,'hello');
insert into "As"(c_id,"As") values(2,'china');

--更新表数据
update "As" set "As"=1000 where "As"='hello';

--清理表数据
delete from "As" where "As"='china';

--查看表数据
select "As" from "As" where "As"!='hello' order by "As";

--清理环境
drop table "As";