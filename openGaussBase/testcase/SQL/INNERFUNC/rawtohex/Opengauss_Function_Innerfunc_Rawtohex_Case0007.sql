-- @testpoint: rawtohex函数作为自定义函数的返回值
DROP FUNCTION IF EXISTS F_TEST_RAWTOHEX;
CREATE OR REPLACE FUNCTION F_TEST_RAWTOHEX(A char) RETURN FLOAT
IS
BEGIN
	RETURN rawtohex(A);
END;
/
SELECT F_TEST_RAWTOHEX('aa');
DROP FUNCTION F_TEST_RAWTOHEX;