--  @testpoint:创建函数，指定参数ROWS，估计函数返回的行数是0，合理报错
drop FUNCTION if EXISTS compute1;
CREATE  FUNCTION compute1(i int, out result_1 bigint, out result_2 bigint)
returns SETOF RECORD
as $$
begin
    result_1 = i + 1;
    result_2 = i * 10;
return next;
end;
$$language plpgsql
ROWS 0;
/