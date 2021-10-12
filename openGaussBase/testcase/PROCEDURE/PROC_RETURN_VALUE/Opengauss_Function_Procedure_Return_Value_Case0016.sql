-- @testpoint: 测试存储过程返回值类型——char/varchar

--创建存储过程
create or replace procedure proc_return_value_016(p1 varchar)  as
v_char1 varchar(20);    
begin
    v_char1:=p1;
    raise info 'v_char1=:%',v_char1;
    exception
    when no_data_found
    then raise info 'no_data_found';
end;
/
--调用存储过程
declare
v1 varchar(200):='qwerttttyuioppppasdf';
begin
proc_return_value_016(v1);
end;
/
--清理环境
drop procedure proc_return_value_016;