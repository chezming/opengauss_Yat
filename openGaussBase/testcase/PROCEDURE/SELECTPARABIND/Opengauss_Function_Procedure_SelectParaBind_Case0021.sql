-- @testpoint: 参数名大于64，自动截断

--创建测试表
drop table if exists all_datatype_tbl;
create table all_datatype_tbl(
	c_id integer,
	c_boolean boolean,
	c_integer integer, c_bigint bigint,
	c_real real,
	c_decimal decimal(38), c_number number(38),
	c_charppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp char(64) default null, c_varchar varchar(50), c_clob clob,
    c_blob blob,
	 c_timestamp timestamp, c_interval interval day to second);

--创建存储过程
create or replace procedure pro_02
as
begin
   insert into all_datatype_tbl(c_charppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp) values ('aaaa');
end;
/
--调用存储过程
call pro_02();

--查看表数据
select c_charppppppppppppppppppppppppppppppppppppppppppppppppppppppppp from all_datatype_tbl;

--清理环境
drop procedure pro_02;
drop table all_datatype_tbl;


