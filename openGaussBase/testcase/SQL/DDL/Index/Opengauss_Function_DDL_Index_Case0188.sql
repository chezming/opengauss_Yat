--  @testpoint: 索引列定义长度3900字节，建表后插入字段长度为3900的数据多条
--INITRANS 指的是一个 BLOCK 上初始预分配给并行交易控制的空间 (ITLs)
--如果一个表格需要同时有大量交易存取，你应该设定 INITRANS 大一点，可以减少 ITL 还要动态扩充的 Overhead

--建普通表
DROP TABLE if EXISTS test_index_table_188 CASCADE;
create table test_index_table_188(
c_varchar varchar(3900));

begin
    for i in 0..10000 loop
        insert into test_index_table_188 values(to_char(lpad('test',3900,'x')));
    end loop;
end;
/

select count(*) from test_index_table_188;
drop index if exists index_188_01;
create index index_188_01 on test_index_table_188(c_varchar) INITRANS 100;
select relname from pg_class where relname like 'index_188_%';
explain select * from test_index_table_188 where c_varchar = 'test' group by c_varchar;

--清理环境
DROP TABLE if EXISTS test_index_table_188 CASCADE;
