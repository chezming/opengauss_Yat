--  @testpoint: clob：建表作为数据类型：列存普通表：success
drop table if exists test_clob_05 CASCADE;
create table test_clob_05(name clob) with (orientation=column);
--插入数据
INSERT INTO test_clob_05 values('test_clob');
--查询字段信息
SELECT format_type(a.atttypid,a.atttypmod) as type
FROM pg_class as c,pg_attribute as a
where c.relname = 'test_clob_05' and a.attrelid = c.oid and a.attnum>0;
--清理数据
drop table if exists test_clob_05 CASCADE;