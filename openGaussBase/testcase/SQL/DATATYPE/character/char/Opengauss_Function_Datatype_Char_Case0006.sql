-- @testpoint: 插入拼接英文字符串超出设定长度，合理报错
-- @modify at: 2020-11-05

DECLARE
  V_C char(800);
BEGIN
  DROP TABLE IF EXISTS test_char_06;
  CREATE TABLE test_char_06 (name char(800));
  FOR I IN 1 .. 800 LOOP
    V_C := V_C || 'x';
  END LOOP;
  insert into test_char_06 values (V_C);
END;
/
insert into test_char_06 select name||'xxxxxxxxxx' from  test_char_06;
drop table test_char_06;
