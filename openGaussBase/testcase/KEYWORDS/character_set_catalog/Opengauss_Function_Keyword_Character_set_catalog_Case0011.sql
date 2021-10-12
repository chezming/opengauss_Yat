--  @testpoint:openGauss关键字character_set_catalog(非保留)，同时作为表名和列名带引号，并进行dml操作,character_set_catalog列的值最终显示为1000
--创建表
drop table if exists "character_set_catalog";
create table "character_set_catalog"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"character_set_catalog" varchar(100) default 'character_set_catalog'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--向表中插入数据
insert into "character_set_catalog"(c_id,"character_set_catalog") values(1,'hello');
insert into "character_set_catalog"(c_id,"character_set_catalog") values(2,'china');

--查看表内容
select * from "character_set_catalog";

--更新表数据
update "character_set_catalog" set "character_set_catalog"=1000 where "character_set_catalog"='hello';

--删除表数据
delete from "character_set_catalog" where "character_set_catalog"='china';

--查询表内容
select "character_set_catalog" from "character_set_catalog" where "character_set_catalog"!='hello' order by "character_set_catalog";

--清理环境
drop table "character_set_catalog";
