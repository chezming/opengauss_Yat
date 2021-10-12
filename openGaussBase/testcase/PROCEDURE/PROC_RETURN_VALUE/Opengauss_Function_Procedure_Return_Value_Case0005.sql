-- @testpoint: 测试存储过程返回值类型——int，能正常返回的int、real类型

drop table if exists table_002;
create table table_002(
  t1 int,
  t2 integer not null,
  t3 real,
  t4 int,
  t5 real,
  t6 number,
  t7 int,
  t8 int,
  t9 number(12,6),
  t10 number,
  t11 int,
  t12 int,
  t13 int
) ;

create unique index  indx_t21 on table_002(t1);
create index indx_t22 on table_002(t2,t12);

--创建存储过程
create or replace procedure proc_return_value_005  as
v1 int;
v2 int;
v3 integer;
v4 int;
v5 int;
v6 int;
v7 int;
v8 int;
v9 int;
v10 int;
v11 int;
v12 int;
v13 int;
begin
    select t1 into v1 from table_002;
    select t2 into v2 from table_002;
    select t3 into v3 from table_002;
    select t4 into v4 from table_002;
    select t5 into v5 from table_002;
    select t6 into v6 from table_002;
    select t7 into v7 from table_002;
    select t8 into v8 from table_002;
    select t9 into v9 from table_002;
    select t10 into v10 from table_002;
    select t11 into v11 from table_002;
    select t12 into v12 from table_002;
    select t13 into v13 from table_002;
    raise info 'v1=:%',v1;
    raise info 'v2=:%',v2;
    raise info 'v3=:%',v3;
    raise info 'v4=:%',v4;
    raise info 'v5=:%',v5;
    raise info 'v6=:%',v6;
    raise info 'v7=:%',v7;
    raise info 'v8=:%',v8;
    raise info 'v9=:%',v9;
    raise info 'v10=:%',v10;
    raise info 'v11=:%',v11;
    raise info 'v12=:%',v12;
    raise info 'v13=:%',v13;
    exception
    when no_data_found
    then raise info 'no_data_found';
end;
/
--调用存储过程
begin
    proc_return_value_005();
end;
/
--清理环境
drop procedure proc_return_value_005;
drop table table_002;