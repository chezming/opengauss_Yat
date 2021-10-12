-- @testpoint: 插入中文字符，超出字节设定长度，合理报错
-- @modify at: 2020-11-05

DECLARE
  V_C char(1000);
BEGIN
  DROP TABLE IF EXISTS test_char_08;
  CREATE TABLE test_char_08 (name char(1000));
  FOR I IN 1 .. 333 LOOP
    V_C := V_C || '中';
  END LOOP;
  insert into test_char_08 values (V_C);
END;
/
select * from test_char_08;
insert into test_char_08 select name||'中' from  test_char_08;
drop table test_char_08;
