-- @testpoint: 插入正常值，字节长度设为合理范围
-- @modify at: 2020-11-05


DECLARE
  V_C char(800);
BEGIN
  DROP TABLE IF EXISTS test_char_04;
  CREATE TABLE test_char_04 (stringv char(800));
  FOR I IN 1 .. 800 LOOP
    V_C := V_C || 'x';
  END LOOP;
  insert into test_char_04 values (V_C);
END;
/
select * from test_char_04;
drop table test_char_04;