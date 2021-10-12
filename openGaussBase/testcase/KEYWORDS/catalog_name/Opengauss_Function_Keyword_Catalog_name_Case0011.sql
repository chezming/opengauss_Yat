--  @testpoint:openGauss关键字catalog_name(非保留)，同时作为表名和列名带引号，并进行dml操作,catalog_name列的值最终显示为1000
--创建表
drop table if exists "catalog_name";
create table "catalog_name"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"catalog_name" varchar(100) default 'catalog_name'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--向表中插入数据
insert into "catalog_name"(c_id,"catalog_name") values(1,'hello');
insert into "catalog_name"(c_id,"catalog_name") values(2,'china');

--查看表内容
select * from "catalog_name";

--更新表数据
update "catalog_name" set "catalog_name"=1000 where "catalog_name"='hello';

--删除表数据
delete from "catalog_name" where "catalog_name"='china';

--查询表内容
select "catalog_name" from "catalog_name" where "catalog_name"!='hello' order by "catalog_name";

--清理环境
drop table "catalog_name";