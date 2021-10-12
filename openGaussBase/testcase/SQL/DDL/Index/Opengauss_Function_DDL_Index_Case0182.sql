--  @testpoint: insert3W数据再建索引

--建普通表
DROP TABLE if EXISTS test_index_table_182 CASCADE;
create table test_index_table_182(c_char2000 char(2000),c_varchar1900 varchar(1900) );

begin
    for i in 0..30000 loop
        insert into test_index_table_182 values(i,i);
    end loop;
end;
/

drop index if exists index_182_01;
create index index_182_01 on test_index_table_182(c_char2000,c_varchar1900);
select relname from pg_class where relname like 'index_182_%';
explain select * from test_index_table_182 where c_char2000 = '50' group by c_char2000,c_varchar1900;

--清理环境
DROP TABLE if EXISTS test_index_table_182 CASCADE;