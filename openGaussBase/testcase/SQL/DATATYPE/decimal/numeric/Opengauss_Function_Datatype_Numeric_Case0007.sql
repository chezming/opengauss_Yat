-- @testpoint: 插入超出小数点后边界范围值，合理报错
-- @modified at: 2020-11-23

declare
  V_C text;
begin
  drop table if exists test_numeric_07;
  create table test_numeric_07 (name numeric);
  for i in 1 .. 16384 loop
    V_C := V_C || '9';
  end loop;
  V_C := '1.' || V_C;
  insert into test_numeric_07 values (V_C);
end;
/
