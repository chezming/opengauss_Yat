-- @testpoint: 关键字year，用作字段名

drop table if exists year_test cascade;
create table year_test(id int,year varchar(20));

create or replace procedure year_insert
as
begin
 for i in 1..20 loop
    insert into year_test values(i,'year'||i);
    end loop;
 end;
/
call year_insert();

select * from year_test;
drop table if exists year_test cascade;
drop procedure year_insert;
