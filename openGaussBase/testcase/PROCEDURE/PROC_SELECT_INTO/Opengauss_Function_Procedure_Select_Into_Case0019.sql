-- @testpoint: 测试select into语句中带有复杂数学表达式时给int数据类型赋值

declare
  v_int int;
begin
    raise info 'result:% ',v_int;
end;
/