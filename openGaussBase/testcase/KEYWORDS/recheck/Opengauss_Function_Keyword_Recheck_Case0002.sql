--  @testpoint:openGauss鍏抽敭瀛梤echeck(闈炰繚鐣?浣滀负鍒楀悕甯﹀弻寮曞彿锛宺echeck澶у皬鍐欐贩鍚堬紝寤鸿〃鎴愬姛

drop table if exists recheck_test;
create table recheck_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"Recheck" char(50)
)
PARTITION BY RANGE (c_integer)
(
	partition P_20180121 values less than (0),
	partition P_20190122 values less than (50000),
	partition P_20200123 values less than (100000),
	partition P_max values less than (maxvalue)
);

select * from recheck_test;
drop table recheck_test;

--openGauss鍏抽敭瀛梤echeck(闈炰繚鐣?浣滀负鍒楀悕甯﹀弻寮曞彿锛宺echeck澶у皬鍐欏尮閰嶏紝寤鸿〃鎴愬姛
drop table if exists recheck_test;
create table recheck_test(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"recheck" char(50)
)
PARTITION BY RANGE (c_integer)
(
	partition P_20180121 values less than (0),
	partition P_20190122 values less than (50000),
	partition P_20200123 values less than (100000),
	partition P_max values less than (maxvalue)
);

select * from recheck_test;
drop table recheck_test;