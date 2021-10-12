--  @testpoint:openGauss关键字destructor(非保留)，同时作为表名和列名带引号，并进行dml操作,destructor列的值最终显示为1000

drop table if exists "destructor";
create table "destructor"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"destructor" varchar(100) default 'destructor'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "destructor"(c_id,"destructor") values(1,'hello');
insert into "destructor"(c_id,"destructor") values(2,'china');
update "destructor" set "destructor"=1000 where "destructor"='hello';
delete from "destructor" where "destructor"='china';
select "destructor" from "destructor" where "destructor"!='hello' order by "destructor";

drop table "destructor";

