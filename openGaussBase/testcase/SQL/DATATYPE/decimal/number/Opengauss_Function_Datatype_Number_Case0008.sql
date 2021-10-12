-- @testpoint: 插入精度小数点后边界范围值
-- @modified at: 2020-11-23

declare
  V_C text;
begin
  drop table if exists test_number_08;
  create table test_number_08 (name number);
  for i in 1 .. 16383 loop
    V_C := V_C || '9';
  end loop;
  V_C := '1.' || V_C;
  insert into test_number_08 values (V_C);
end;
/
select char_length(name) from test_number_08;
drop table test_number_08;