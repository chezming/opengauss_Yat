--  @testpoint:openGauss关键字character_set_schema(非保留)，作为列名带引号并且删除时使用该列,建表成功，character_set_schema列值是'hello'的删除成功
--创建表
drop table if exists character_set_schema_test;
create table character_set_schema_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer, 
	c_real real, c_double real, 
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38), 
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"character_set_schema" varchar(100) default 'character_set_schema'
) 
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--向表中插入数据
insert into character_set_schema_test(c_id,"character_set_schema") values(1,'hello');

--查询表内容
select * from character_set_schema_test;

--向表中插入数据
insert into character_set_schema_test(c_id) values(2);

--删除表数据
delete from character_set_schema_test where "character_set_schema"='hello';

--查询表内容
select * from character_set_schema_test order by "character_set_schema";

--清理环境
drop table character_set_schema_test;