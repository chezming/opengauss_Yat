--  @testpoint:创建函数，参数之间不使用逗号，合理报错
drop FUNCTION if EXISTS func_add_sqlb;
CREATE FUNCTION func_add_sqlb(integer integer) RETURNS integer
    AS 'select $1 + $2;'
    LANGUAGE SQL
    IMMUTABLE
    RETURNS NULL ON NULL INPUT;
    /