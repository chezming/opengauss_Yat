--  @testpoint:指定REPLACE创建函数，不加任何参数
drop FUNCTION if EXISTS test1();
CREATE or REPLACE FUNCTION test1()returns date AS $$
BEGIN
  return now();
end;
$$ LANGUAGE plpgsql;
/
drop FUNCTION test1;