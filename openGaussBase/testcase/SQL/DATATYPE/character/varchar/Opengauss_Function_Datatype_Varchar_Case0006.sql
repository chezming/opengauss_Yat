-- @testpoint: 插入正常值，字节长度设定为合理范围值（800）
-- @modify at: 2020-11-17

DECLARE
  V_C varchar(8000);
BEGIN
  drop table if exists test_varchar_06;
  create table test_varchar_06 (name varchar(800));
  FOR I IN 1 .. 800 LOOP
    V_C := V_C || 'q';
  END LOOP;
  insert into test_varchar_06 values (V_C);
END;
/
select * from test_varchar_06;
drop table test_varchar_06;