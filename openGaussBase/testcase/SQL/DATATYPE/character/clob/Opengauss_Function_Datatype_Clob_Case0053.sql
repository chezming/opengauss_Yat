-- @testpoint: 插入正常值，设定字节长度并超出，合理报错
-- @modified at: 2020-11-13


DECLARE
  V_C clob;
BEGIN
  drop table if exists test_clob_053;
  create table test_clob_053 (name clob(800));
  FOR I IN 1 .. 1000 LOOP
    V_C := V_C || 'qqqqqqqqqq';
  END LOOP;
  insert into test_clob_053 values (V_C);
END;
/
