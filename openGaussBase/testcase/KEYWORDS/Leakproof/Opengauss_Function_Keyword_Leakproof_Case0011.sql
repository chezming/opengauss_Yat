--  @testpoint:openGauss关键字Leakproof(非保留)，同时作为表名和列名带引号，并进行dml操作,Leakproof列的值最终显示为1000

drop table if exists "Leakproof";
create table "Leakproof"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"Leakproof" varchar(100) default 'Leakproof'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "Leakproof"(c_id,"Leakproof") values(1,'hello');
insert into "Leakproof"(c_id,"Leakproof") values(2,'china');
update "Leakproof" set "Leakproof"=1000 where "Leakproof"='hello';
delete from "Leakproof" where "Leakproof"='china';
select "Leakproof" from "Leakproof" where "Leakproof"!='hello' order by "Leakproof";

drop table "Leakproof";
