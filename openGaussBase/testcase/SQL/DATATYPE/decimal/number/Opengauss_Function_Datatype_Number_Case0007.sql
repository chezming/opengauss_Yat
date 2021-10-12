-- @testpoint: 插入超出精度小数点后边界范围值，合理报错
-- @modified at: 2020-11-23

declare
  V_C text;
begin
  drop table if exists test_number_07;
  create table test_number_07 (name number);
  for i in 1 .. 16384 loop
    V_C := V_C || '9';
  end loop;
  V_C := '1.' || V_C;
  insert into test_number_07 values (V_C);
end;
/
