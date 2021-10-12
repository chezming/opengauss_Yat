-- @testpoint: USING method：列存local临时表btree组合索引：success
--建表
drop table if exists test_index_table_035;
create TEMPORARY table test_index_table_035(id int, name varchar) with (orientation=column);
--插入数据
BEGIN
  for i in 1..10000 LOOP
    insert into test_index_table_035 values(i,concat('zhangsan',i));
  end LOOP;
end;
/
--创建索引
drop index if exists index_035;
create index index_035 on test_index_table_035 using btree(id,name);
explain select * from test_index_table_035 where id=15 or name='zhangsan20';
select relname from pg_class where relname='index_035';

drop index if exists index_035;
DROP TABLE if EXISTS test_index_table_035 CASCADE;