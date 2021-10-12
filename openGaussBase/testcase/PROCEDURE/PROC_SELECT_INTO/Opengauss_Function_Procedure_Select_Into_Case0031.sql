-- @testpoint: 测试利用select into语句给integer类型的变量赋值

--前置：创建表及插入数据
drop table if exists proc_select_into_02;
create table proc_select_into_02(c_int int ,c_integer integer not null ,c_bigint bigint,c_number number default 0.2332,c_number1 number(12,2),c_number2 number(12,6),c_double binary_double,c_decimal decimal,c_decimal1 decimal(8,2),c_decimal2 decimal(8,4),c_real real,c_char char(4000),c_varchar varchar(4000),c_varchar2 varchar2(4000),c_varchar1 varchar(100),c_char1 char(100),c_numeric numeric,c_date date,c_timestamp timestamp,c_timestamp1 timestamp(6),c_bool bool) ;


--创建存储过程
create or replace procedure proc_select_into_002(p_integer out integer)
as
begin
select c_integer into p_integer from proc_select_into_02 where c_int=12;
raise info 'p_integer:%',p_integer;
exception
when no_data_found then   raise info 'no_data_found';
end;
/
--调用存储过程
declare
v_integer int;
begin
proc_select_into_002(v_integer);
end;
/
--清理环境
drop table proc_select_into_02;
drop procedure proc_select_into_002;