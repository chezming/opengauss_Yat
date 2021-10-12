--  @testpoint:创建函数给参数指定参数模式为VARIADIC并且指定默认值，使用=
drop FUNCTION if EXISTS w_testfun1;
CREATE FUNCTION w_testfun1 (c_int VARIADIC int[] = array[1,2,3,4])  RETURNS int[]  AS $$
        BEGIN
                RETURN (c_int);
        END;
$$ LANGUAGE plpgsql;
/
--调用函数，给参数不传值，使用默认值
call w_testfun1 ();
drop FUNCTION w_testfun1;