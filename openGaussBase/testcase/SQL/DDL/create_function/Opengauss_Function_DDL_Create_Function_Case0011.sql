--  @testpoint:函数名称有效值测试，以小写字母开头，函数创建成功
drop FUNCTION if EXISTS test_func1(integer, integer);
CREATE FUNCTION test_func1(integer, integer) RETURNS integer
    AS 'select $1 + $2;'
    LANGUAGE SQL
    IMMUTABLE
    RETURNS NULL ON NULL INPUT;
 /
select proname from pg_proc where proname='test_func1';
drop function test_func1;