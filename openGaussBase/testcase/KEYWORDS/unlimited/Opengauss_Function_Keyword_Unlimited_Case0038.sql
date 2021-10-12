-- @testpoint: 关键字unlimited,用作字段名（合理报错）


drop table if exists unlimited_test cascade;
create table if not exists unlimited_test(id unlimited,name varchar(20));

create or replace procedure unlimited_insert
as
begin
 for i in 1..10 loop
    insert into unlimited_test values(i,'unlimited'||i);
    end loop;
 end;
/
call unlimited_insert();

select * from unlimited_test;

--清理环境
drop procedure unlimited_insert;