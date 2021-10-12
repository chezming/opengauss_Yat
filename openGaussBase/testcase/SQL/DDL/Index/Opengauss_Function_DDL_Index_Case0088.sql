-- @testpoint: 排序：desc
DROP TABLE if EXISTS test_index_table_088 CASCADE;
create table test_index_table_088(
c_float1 float
) WITH (ORIENTATION = row) ;

begin
    for i in 0..10000 loop
        insert into test_index_table_088 values(i);
    end loop;
end;
/

--建btree索引:5-5
drop index if exists index_088_01;
create index index_088_01 on test_index_table_088 using btree(c_float1 desc);
select relname from pg_class where relname like 'index_088_%' order by relname;
--索引有效
explain select * from test_index_table_088 where c_float1 >500 group by c_float1 limit 10;

--清理环境
DROP TABLE if EXISTS test_index_table_088 CASCADE;