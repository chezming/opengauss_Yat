-- @testpoint: 调用函数，不添加分隔符，使用参数名 参数值格式按顺序传递，合理报错
drop FUNCTION if EXISTS func_add_sql014;
CREATE FUNCTION func_add_sql014(num1 integer, num2 integer) RETURN integer
AS
BEGIN
RETURN num1 + num2;
END;
/
--调用函数，使用参数名 参数值格式按顺序传递，合理报错
CALL func_add_sql014(num1 1, num2 3);
drop FUNCTION func_add_sql014;