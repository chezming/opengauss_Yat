-- @testpoint: 匿名块使用数字操作函数  a的b次幂 power

DROP TABLE IF EXISTS test_procedure_insert_121;
create table test_procedure_insert_121(id double precision,
name varchar2(20));
declare
sqlstr varchar(1024);
begin
sqlstr := 'insert into test_procedure_insert_121 (SELECT power(9.0, 3.0),44)';
execute immediate sqlstr;
end;
/

select * from test_procedure_insert_121;
drop table test_procedure_insert_121;
