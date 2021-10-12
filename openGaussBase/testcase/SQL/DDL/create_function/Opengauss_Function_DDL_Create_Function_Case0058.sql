-- @testpoint: 创建函数时参数或返回值带有精度，不进行精度检测

DROP FUNCTION if EXISTS h_testfun6 (c_NUMERIC NUMERIC,c_DECIMAL DECIMAL,c_NUMBER NUMBER);
CREATE  FUNCTION h_testfun6 (c_NUMERIC NUMERIC,c_DECIMAL DECIMAL,c_NUMBER NUMBER) RETURNS NUMBER  AS $$
        BEGIN
                RETURN c_NUMERIC + c_DECIMAL+c_NUMBER;
        END;
$$ LANGUAGE plpgsql;
/
--proallargtypes字段是空
select proname,proallargtypes from pg_proc where proname='h_testfun6';
--求和370368.369411，不进行精度检测
call h_testfun6(123456.12354,123456.122331,123456.12354);
drop function  h_testfun6;