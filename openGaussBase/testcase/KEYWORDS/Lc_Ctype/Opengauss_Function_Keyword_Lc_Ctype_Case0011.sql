--  @testpoint:openGauss关键字Lc_Ctype(非保留)，同时作为表名和列名带引号，并进行dml操作,Lc_Ctype列的值最终显示为1000

drop table if exists "Lc_Ctype";
create table "Lc_Ctype"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"Lc_Ctype" varchar(100) default 'Lc_Ctype'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "Lc_Ctype"(c_id,"Lc_Ctype") values(1,'hello');
insert into "Lc_Ctype"(c_id,"Lc_Ctype") values(2,'china');
update "Lc_Ctype" set "Lc_Ctype"=1000 where "Lc_Ctype"='hello';
delete from "Lc_Ctype" where "Lc_Ctype"='china';
select "Lc_Ctype" from "Lc_Ctype" where "Lc_Ctype"!='hello' order by "Lc_Ctype";

drop table "Lc_Ctype";

