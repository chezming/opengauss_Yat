--  @testpoint:定义函数名是least，调用函数时应该报错
CREATE FUNCTION least(num1 integer, num2 integer) RETURN integer
AS
BEGIN
RETURN num1 + num2;
END;
/
select least(1,2);