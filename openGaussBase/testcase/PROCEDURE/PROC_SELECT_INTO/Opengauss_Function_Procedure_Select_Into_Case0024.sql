-- @testpoint: 测试select into语句中给int数据类型赋值，测试字符串隐式转换为number

declare
  v_number number(12,3);
begin
    select '2e+3' into v_number from sys_dummy;
    raise info 'result:% ',v_number;
end;
/
