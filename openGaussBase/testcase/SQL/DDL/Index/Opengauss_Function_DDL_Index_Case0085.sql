-- @testpoint: expression：与自定义函数和函数同义词结合使用 部分测试点合理报错
DROP TABLE if EXISTS test_index_table_085 CASCADE;
create table test_index_table_085(
c_float1 float
) WITH (ORIENTATION = row) ;

begin
    for i in 0..10000 loop
        insert into test_index_table_085 values(i);
    end loop;
end;
/
--非immutable函数
CREATE OR REPLACE FUNCTION func_test_085_01(i integer) RETURNS integer  AS $$
        BEGIN
                RETURN i + 1;
        END;
$$ LANGUAGE plpgsql;
/

--建btree索引:包含func_test_085函数：报错
drop index if exists index_085_01;
create index index_085_01 on test_index_table_085 using btree(func_test_085_01(c_float1));
select relname from pg_class where relname like 'index_085_%' order by relname;

--immutable函数
CREATE OR REPLACE FUNCTION func_test_085_02(i integer) RETURNS integer  immutable AS $$
        BEGIN
                RETURN i + 1;
        END;
$$ LANGUAGE plpgsql;
/

--建btree索引:包含func_test_085函数
drop index if exists index_085_01;
create index index_085_01 on test_index_table_085 using btree(func_test_085_02(c_float1));
select relname from pg_class where relname like 'index_085_%' order by relname;

--创建函数的同义词
drop synonym if exists syn_func_test_085_02;
create synonym syn_func_test_085_02 for func_test_085_02;

--建btree索引:包含func_test_085函数
drop index if exists index_085_01;
create index index_085_01 on test_index_table_085 using btree(func_test_085_02(c_float1));
select relname from pg_class where relname like 'index_085_%' order by relname;


--清理环境
drop synonym if exists syn_func_test_085_02;
DROP TABLE if EXISTS test_index_table_085 CASCADE;
drop function if exists func_test_085_01(integer);
drop function if exists func_test_085_02(integer);