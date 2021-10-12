--  @testpoint:openGauss关键字abort(非保留)，作为列名带引号并且排序时使用该列,建表成功，abort列按字母大小排序
--创建表
drop table if exists abort_test;
create table abort_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer, 
	c_real real, c_double real, 
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38), 
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"abort" varchar(100) default 'abort'
) 
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);

--向表中插入数据
insert into abort_test(c_id,"abort") values(1,'hello');

--查询表内容
select * from abort_test order by "abort";

--清理环境
drop table abort_test;
