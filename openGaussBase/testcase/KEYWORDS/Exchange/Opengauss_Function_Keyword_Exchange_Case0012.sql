--  @testpoint:openGauss关键字exchange(非保留)同时作为表名和列名带引号,并使用该列结合limit排序,exchange列的值按字母大小排序且只显示前2条数据

drop table if exists "exchange";
create table "exchange"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"exchange" varchar(100) default 'exchange'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);
delete from "exchange";
insert into "exchange"(c_id,"exchange") values(1,'hello');
insert into "exchange"(c_id,"exchange") values(2,'china');
insert into "exchange"(c_id,"exchange") values(3,'gauss');
select "exchange" from "exchange" where "exchange"!='hello' order by "exchange" limit 2 ;

drop table "exchange";

