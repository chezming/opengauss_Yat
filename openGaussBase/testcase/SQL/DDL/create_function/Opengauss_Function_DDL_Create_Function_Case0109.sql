--  @testpoint:创建函数添加参数COST，估计函数的执行成本是0,合理报错
drop FUNCTION if EXISTS u_testfun3(c_int int);
CREATE FUNCTION u_testfun3(c_int int) RETURNS int  AS $$
        BEGIN
                RETURN (c_int);
        END;
$$ LANGUAGE plpgsql
STRICT
COST 0;
/