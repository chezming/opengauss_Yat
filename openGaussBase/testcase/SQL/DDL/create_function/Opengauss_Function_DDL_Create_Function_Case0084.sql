--  @testpoint:创建函数，指定参数模式是IN，省略RETURNS子句,合理报错
drop FUNCTION if EXISTS x_testfun4;
CREATE FUNCTION x_testfun4 (c_int IN int   )    AS $$
        BEGIN
                RETURN (c_int);
        END;
$$ LANGUAGE plpgsql;
/