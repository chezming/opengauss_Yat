--  @testpoint:删除存在的函数添加IF EXISTS 子句并且省略函数参数，执行删除操作
drop FUNCTION if EXISTS u_testfun25;
CREATE FUNCTION u_testfun25 ( INOUT c_int int) RETURNS int  AS $$
        BEGIN
                RETURN (c_int);
        END;
$$ LANGUAGE plpgsql;
/
select proname from pg_proc where proname='u_testfun25';
--添加IF EXISTS 子句并且省略添加函数参数，删除成功
drop FUNCTION if EXISTS u_testfun25;