-- @testpoint: select语句绑定clob类型的参数

--创建存储过程
create or replace procedure pro_016()
as
    sqlstat varchar(500);
	v1 clob;
	r1 clob;
begin
    sqlstat := 'select :p1';
    execute immediate sqlstat into r1 using v1;
    raise info 'result:%',v1;
end;
/
--调用存储过程
call pro_016();

--清理环境
drop procedure pro_016;