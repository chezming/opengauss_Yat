--  @testpoint:openGauss关键字connection_name(非保留)，同时作为表名和列名带引号，并进行dml操作,connection_name列的值最终显示为1000

drop table if exists "connection_name";
create table "connection_name"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"connection_name" varchar(100) default 'connection_name'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "connection_name"(c_id,"connection_name") values(1,'hello');
insert into "connection_name"(c_id,"connection_name") values(2,'china');
update "connection_name" set "connection_name"=1000 where "connection_name"='hello';
delete from "connection_name" where "connection_name"='china';
select "connection_name" from "connection_name" where "connection_name"!='hello' order by "connection_name";

drop table "connection_name";

