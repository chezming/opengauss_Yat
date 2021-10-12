--  @testpoint:openGauss关键字exec(非保留)，同时作为表名和列名带引号，并进行dml操作,exec列的值最终显示为1000

drop table if exists "exec";
create table "exec"(
	c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer,
	c_real real, c_double real,
	c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
	c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
	c_date date, c_datetime date, c_timestamp timestamp,
	"exec" varchar(100) default 'exec'
)
PARTITION BY RANGE (c_integer)
(
	partition P_max values less than (maxvalue)
);



insert into "exec"(c_id,"exec") values(1,'hello');
insert into "exec"(c_id,"exec") values(2,'china');
update "exec" set "exec"=1000 where "exec"='hello';
delete from "exec" where "exec"='china';
select "exec" from "exec" where "exec"!='hello' order by "exec";

drop table "exec";

