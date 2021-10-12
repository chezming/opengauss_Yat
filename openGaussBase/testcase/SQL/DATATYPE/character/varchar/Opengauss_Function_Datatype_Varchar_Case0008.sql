-- @testpoint: 插入数据为拼接字符串测试

DECLARE
  V_C varchar(8000);
BEGIN
  drop table if exists test_varchar_08;
  create table test_varchar_08 (name varchar(800));
  FOR I IN 1 .. 798 LOOP
    V_C := V_C || 'q';
  END LOOP;
  insert into test_varchar_08 values (V_C);
END;
/
insert into test_varchar_08 select name||'ww' from test_varchar_08;
select * from test_varchar_08;
drop table if exists test_varchar_08;