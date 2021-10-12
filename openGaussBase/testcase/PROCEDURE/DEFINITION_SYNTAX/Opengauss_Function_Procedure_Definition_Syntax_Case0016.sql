-- @testpoint: 存储过程声明语法 定义变量 REAL

--创建存储过程
CREATE OR REPLACE PROCEDURE Proc_Syntax_016()
IS
DECLARE
emp_id REAL := 12.33;
begin
emp_id := 12.33*3;
raise info ':%',emp_id;
end;
/

--调用存储过程
call Proc_Syntax_016();

--清理环境
DROP PROCEDURE Proc_Syntax_016;