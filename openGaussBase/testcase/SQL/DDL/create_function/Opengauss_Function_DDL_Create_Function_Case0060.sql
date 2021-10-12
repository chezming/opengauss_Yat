-- @testpoint: 创建函数指定参数的数据类型，遍历序列类型,合理报错
drop FUNCTION if exists h_testfun007;
--创建函数，指定参数类型为序列型，报错
CREATE  FUNCTION h_testfun007 (c_SMALLSERIAL SMALLSERIAL,c_SERIAL SERIAL,c_BIGSERIAL BIGSERIAL) RETURNS SERIAL   AS $$
        BEGIN
                RETURN c_SMALLSERIAL+c_SERIAL+c_BIGSERIAL ;
        END;
$$ LANGUAGE plpgsql;
/

