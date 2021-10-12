--  @testpoint:openGauss关键字Key(非保留)，同时作为表名和列名带引号，并进行dml操作,Key列的值最终显示为1000

drop table if exists "Key";
create table "Key"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"Key" varchar(100) default 'Key'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "Key"(c_id,"Key") values(1,'hello');
insert into "Key"(c_id,"Key") values(2,'china');
update "Key" set "Key"=1000 where "Key"='hello';
delete from "Key" where "Key"='china';
select "Key" from "Key" where "Key"!='hello' order by "Key";

drop table "Key";

