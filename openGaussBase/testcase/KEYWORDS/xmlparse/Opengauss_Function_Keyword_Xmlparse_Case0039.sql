--  @testpoint:关键字xmlparse，用作函数名(合理报错)


create function xmlparse(num1 integer,num2 integer)
return integer
as
begin
    return num1+num2;
end;
/

select * from xmlparse(1,2);