--  @testpoint:opengauss关键字inout非保留,函数过程带inout模式

CREATE OR REPLACE FUNCTION compute(i int, inout result_1 bigint, inout result_2 bigint)
returns SETOF RECORD
as $$
begin
    result_1 = i + 1;
    result_2 = i * 10;
return next;
end;
$$language plpgsql;
/

call compute(6,1,8);
drop function compute;
