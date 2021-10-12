--  @testpoint:函数参数有三个，全部不指定参数模式，查看函数参数模式默认值是否为IN
DROP FUNCTION if EXISTS h_testfun (i integer,j integer,k integer);
    CREATE  FUNCTION h_testfun (i integer,j integer,k integer) RETURNS integer AS $$
        BEGIN
                RETURN i + j+k;
        END;
$$ LANGUAGE plpgsql;
/
--查询pg_proc表proallargtypes字段为空，即三个参数的默认模式都是IN
select proallargtypes from pg_proc where proname='h_testfun';
drop function  h_testfun;