-- @testpoint: 测试存储过程返回值类型——bigint

--创建存储过程
create or replace procedure proc_return_value_012(p1 bigint)  as
v_num bigint;
begin
    if(p1>=0)
    then
		v_num:=p1+1;
        raise info 'v_num=:%',v_num;
    else
		v_num:=p1-1;
        raise info 'v_num=:%',v_num;
    end if;
end;
/
--调用存储过程
declare
    v1 bigint:=9223372036854775806;
begin
    proc_return_value_012(v1);
end;
/
--调用存储过程
declare
    v2 bigint:=-9223372036854775807;
begin
    proc_return_value_012(v2);
end;
/
--清理环境
drop procedure proc_return_value_012;
