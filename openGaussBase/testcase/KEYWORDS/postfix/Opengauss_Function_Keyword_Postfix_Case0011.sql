--  @testpoint:openGauss关键字postfix(非保留)，同时作为表名和列名带引号，并进行dml操作,postfix列的值最终显示为1000

drop table if exists "postfix";
create table "postfix"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"postfix" varchar(100) default 'postfix'
)
PARTITION BY RANGE (c_integer)
(
	partition P_20180121 values less than (0),
	partition P_20190122 values less than (50000),
	partition P_20200123 values less than (100000),
	partition P_max values less than (maxvalue)
);



insert into "postfix"(c_id,"postfix") values(1,'hello');
insert into "postfix"(c_id,"postfix") values(2,'china');
update "postfix" set "postfix"=1000 where "postfix"='hello';
delete from "postfix" where "postfix"='china';
select "postfix" from "postfix" where "postfix"!='hello' order by "postfix";

drop table "postfix";

