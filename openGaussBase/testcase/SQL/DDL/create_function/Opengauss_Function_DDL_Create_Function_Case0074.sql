--  @testpoint:创建函数给参数指定默认值，使用:!=合理报错
drop FUNCTION if EXISTS w_testfun4;
CREATE FUNCTION w_testfun4 (c_int int :!=  0)  RETURNS int  AS $$
        BEGIN
                RETURN (c_int);
        END;
$$ LANGUAGE plpgsql;
/