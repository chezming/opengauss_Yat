--  @testpoint:openGauss关键字partitions(非保留)，同时作为表名和列名带引号，并进行dml操作,partitions列的值最终显示为1000

drop table if exists "partitions";
create table "partitions"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"partitions" varchar(100) default 'partitions'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "partitions"(c_id,"partitions") values(1,'hello');
insert into "partitions"(c_id,"partitions") values(2,'china');
update "partitions" set "partitions"=1000 where "partitions"='hello';
delete from "partitions" where "partitions"='china';
select "partitions" from "partitions" where "partitions"!='hello' order by "partitions";

drop table "partitions";

