--  @testpoint:参数列表中仅出现参数值,参数值的排列顺序和函数定义时一致
drop FUNCTION if EXISTS func_add_sql017;
CREATE FUNCTION func_add_sql017(num1 integer, num2 char) RETURN char
AS
BEGIN
RETURN (num1,num2);
END;
/
--调用函数，参数按顺序传递，调用成功
CALL func_add_sql017(999,'hello');
drop FUNCTION func_add_sql017;