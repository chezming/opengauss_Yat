-- @testpoint:在存储过程中插入加括号select的语句

DROP TABLE IF EXISTS test_procedure_insert_01;
create table test_procedure_insert_01 (f1 int, f2 int);
insert into test_procedure_insert_01 values(1,2);

DROP TABLE IF EXISTS test_procedure_insert_02;
create table test_procedure_insert_02 (f1 int, f2 int);

CREATE OR REPLACE PROCEDURE p_test_insert_01
is
begin
insert into test_procedure_insert_02 (select f1,f2 from test_procedure_insert_01);
end;
/

CALL p_test_insert_01();
select * from test_procedure_insert_02;
DROP PROCEDURE p_test_insert_01;
DROP TABLE test_procedure_insert_01;
DROP TABLE test_procedure_insert_02;
