--  @testpoint:创建函数指定参数模式是INOUT，proargtypes字段显示参数的数据类型
drop FUNCTION if EXISTS w_testfunb;
CREATE FUNCTION w_testfunb (c_int INOUT int )  RETURNS int  AS $$
        BEGIN
                RETURN (c_int);
        END;
$$ LANGUAGE plpgsql;
/

select proname,proargtypes from pg_proc where proname='w_testfunb';
drop FUNCTION  w_testfunb;