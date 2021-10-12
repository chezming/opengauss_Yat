-- @testpoint: 匿名块使用数字操作函数  反正切 atan(x)

DROP TABLE IF EXISTS test_procedure_insert_090;
create table test_procedure_insert_090(id double precision,
name varchar2(20));
declare
sqlstr varchar(1024);
begin
sqlstr := 'insert into test_procedure_insert_090 (SELECT atan(1), 5)';
execute immediate sqlstr;
end;
/

select * from test_procedure_insert_090;
drop table test_procedure_insert_090;
