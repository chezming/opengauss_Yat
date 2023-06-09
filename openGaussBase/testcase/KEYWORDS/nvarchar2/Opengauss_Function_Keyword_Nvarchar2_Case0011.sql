--  @testpoint:openGauss关键字nvarchar2(非保留)，同时作为表名和列名带引号，并进行dml操作,nvarchar2列的值最终显示为1000

drop table if exists "nvarchar2";
create table "nvarchar2"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"nvarchar2" varchar(100) default 'nvarchar2'
)
PARTITION BY RANGE (c_integer)
(
	partition P_20180121 values less than (0),
	partition P_20190122 values less than (50000),
	partition P_20200123 values less than (100000),
	partition P_max values less than (maxvalue)
);



insert into "nvarchar2"(c_id,"nvarchar2") values(1,'hello');
insert into "nvarchar2"(c_id,"nvarchar2") values(2,'china');
update "nvarchar2" set "nvarchar2"=1000 where "nvarchar2"='hello';
delete from "nvarchar2" where "nvarchar2"='china';
select "nvarchar2" from "nvarchar2" where "nvarchar2"!='hello' order by "nvarchar2";

drop table "nvarchar2";

