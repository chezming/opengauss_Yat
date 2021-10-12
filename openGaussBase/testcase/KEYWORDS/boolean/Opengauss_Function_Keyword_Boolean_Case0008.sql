--  @testpoint:openGauss关键字boolean(非保留)，作为列名带引号并且删除时使用该列,建表成功，boolean列值是'hello'的删除成功
--创建表
drop table if exists boolean_test;
create table boolean_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer, 
	c_real real, c_double real, 
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38), 
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"boolean" varchar(100) default 'boolean'
) 
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--向表中插入数据
insert into boolean_test(c_id,"boolean") values(1,'hello');

--查询表内容
select * from boolean_test;

--向表中插入数据
insert into boolean_test(c_id) values(2);

--删除表数据
delete from boolean_test where "boolean"='hello';

--查询表内容
select * from boolean_test order by "boolean";

--清理环境
drop table boolean_test;
