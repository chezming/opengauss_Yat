-- @testpoint: 测试存储过程中if判断条件为null

--创建存储过程
CREATE OR REPLACE PROCEDURE PROC_IF_ELSE_00_07
AS
begin
    if(null)
    then
        raise info 'The condition is true';
    else
        raise info 'The condition is false';
    end if;
end ;
/
--调用存储过程
Call PROC_IF_ELSE_00_07();

--清理环境
drop PROCEDURE PROC_IF_ELSE_00_07;