--  @testpoint:创建函数省略参数SECURITY INVOKER
drop FUNCTION if EXISTS v_testfun6(c_int int);
CREATE FUNCTION v_testfun6 (c_int int) RETURNS int  AS $$
        BEGIN
                RETURN (c_int);
        END;
$$ LANGUAGE plpgsql
STRICT;
/


call v_testfun6(999);
drop FUNCTION v_testfun6;