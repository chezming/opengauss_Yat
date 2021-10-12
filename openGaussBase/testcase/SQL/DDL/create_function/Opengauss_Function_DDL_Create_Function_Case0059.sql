-- @testpoint: 创建函数时指定参数的数据类型是浮点类型
--指定参数的数据类型为REAL
drop FUNCTION if EXISTS z_testfun9;
CREATE FUNCTION z_testfun9 (c_REAL REAL) RETURNS REAL   AS $$
        BEGIN
                RETURN c_REAL ;
        END;
$$ LANGUAGE plpgsql;
/
--proallargtypes字段为空
select proname,proallargtypes from pg_proc where proname='z_testfun9';
--不进行精度检测
call z_testfun9(10.365456);
drop FUNCTION z_testfun9;


--指定参数的数据类型为FLOAT4
drop FUNCTION if EXISTS h_testfun9;
CREATE FUNCTION h_testfun9 (c_FLOAT4 FLOAT4) RETURNS FLOAT4   AS $$
        BEGIN
                RETURN c_FLOAT4 ;
        END;
$$ LANGUAGE plpgsql;
/
--proallargtypes字段为空
select proname,proallargtypes from pg_proc where proname='h_testfun9';
--不进行精度检测
call h_testfun9(10.365456);
drop FUNCTION h_testfun9;

--指定参数的数据类型为DOUBLE PRECISION
drop FUNCTION if EXISTS z_testfun8;
CREATE FUNCTION z_testfun8 (c_DOUBLE_PRECISION INOUT DOUBLE PRECISION) RETURNS DOUBLE PRECISION   AS $$
        BEGIN
                RETURN c_DOUBLE_PRECISION ;
        END;
$$ LANGUAGE plpgsql;
/
--proallargtypes字段不为空
select proname,proallargtypes from pg_proc where proname='z_testfun8';
--不进行精度检测
call z_testfun8(10.365456);
drop FUNCTION z_testfun8;
--指定参数的数据类型为FLOAT8
drop FUNCTION if EXISTS z_testfun7;
CREATE FUNCTION z_testfun7 (c_FLOAT8  FLOAT8) RETURNS FLOAT8   AS $$
        BEGIN
                RETURN c_FLOAT8;
        END;
$$ LANGUAGE plpgsql;
/
--proargtypes字段为空
select proname,proallargtypes from pg_proc where proname='z_testfun7';
--不进行精度检测
call z_testfun7(10.365456);
drop FUNCTION z_testfun7;

--指定参数的数据类型为FLOAT(3)
drop FUNCTION if EXISTS z_testfun6;
CREATE FUNCTION z_testfun6 (c_FLOAT  FLOAT(3)) RETURNS FLOAT(3)   AS $$
        BEGIN
                RETURN c_FLOAT;
        END;
$$ LANGUAGE plpgsql;
/
--proargtypes字段为空
select proname,proallargtypes from pg_proc where proname='z_testfun6';
--不进行精度检测
call z_testfun6(10.3214);
call z_testfun6(10.5);
drop FUNCTION z_testfun6;

--指定参数的数据类型为BINARY_DOUBLE
drop FUNCTION if EXISTS z_testfun5;
CREATE FUNCTION z_testfun5 (c_BINARY_DOUBLE BINARY_DOUBLE) RETURNS BINARY_DOUBLE   AS $$
        BEGIN
                RETURN c_BINARY_DOUBLE;
        END;
$$ LANGUAGE plpgsql;
/
--proargtypes字段为空
select proname,proallargtypes from pg_proc where proname='z_testfun5';
call z_testfun5 (321.321);
drop FUNCTION  z_testfun5;

--指定参数的数据类型为DEC
drop FUNCTION if EXISTS z_testfun4;
CREATE FUNCTION z_testfun4 (c_DEC DEC(10,4)) RETURNS DEC  AS $$
        BEGIN
                RETURN c_DEC;
        END;
$$ LANGUAGE plpgsql;
/
--proallargtypes字段为空
select proname,proallargtypes from pg_proc where proname='z_testfun4';
--不进行精度检测
call z_testfun4(10.3214);
drop FUNCTION  z_testfun4;

--指定参数的数据类型为INTEGER(6,3)
drop FUNCTION if EXISTS z_testfun3;
CREATE FUNCTION z_testfun3 (c_INTEGER INOUT INTEGER(6,3)) RETURNS INTEGER(6,3)  AS $$
        BEGIN
                RETURN c_INTEGER;
        END;
$$ LANGUAGE plpgsql;
/
--proallargtypes字段不为空
select proname,proallargtypes from pg_proc where proname='z_testfun3';
--不进行精度检测
call z_testfun3(123.123654);
drop FUNCTION  z_testfun3;

