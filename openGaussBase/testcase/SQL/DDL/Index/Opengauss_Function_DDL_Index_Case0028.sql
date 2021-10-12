-- @testpoint: USING method：列存组合btree索引：单表多字段28:success
--删表
drop table if exists test_index_table_028 cascade;
create table test_index_table_028(id int, name varchar) with (orientation=column);
--插入数据
BEGIN
  for i in 1..10000 LOOP
    insert into test_index_table_028 values(i,concat('zhangsan',i));
  end LOOP;
end;
/
--创建索引
drop index if exists index_028;
create index index_028 on test_index_table_028 using btree(id,name);
explain select * from test_index_table_028 where id=15 or name='zhangsan20';
select relname from pg_class where relname='index_028';

--清理数据
drop index if exists index_028;
drop table if exists test_index_table_028 cascade;