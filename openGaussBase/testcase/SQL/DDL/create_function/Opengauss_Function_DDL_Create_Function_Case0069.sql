--  @testpoint:创建函数指定参数数据类型是日期/时间类型

drop FUNCTION if EXISTS x_testfun7;
--创建函数，指定参数数据类型是time without time zone
CREATE FUNCTION x_testfun7 (c_time1 time without time zone ) RETURNS time  AS $$
        BEGIN
                RETURN (c_time1);
        END;
$$ LANGUAGE plpgsql;
/

call x_testfun7( '21:21:21');

drop FUNCTION x_testfun7;

--创建函数，指定参数数据类型是time  with time zone(调用函数也不带时区，在pg环境上测试一样)
drop FUNCTION if EXISTS x_testfun8;
CREATE FUNCTION x_testfun8 (c_time1 time with time zone ) RETURNS time  AS $$
        BEGIN
                RETURN (c_time1);
        END;
$$ LANGUAGE plpgsql;
/

call x_testfun8( '21:21:21');

drop FUNCTION x_testfun8;