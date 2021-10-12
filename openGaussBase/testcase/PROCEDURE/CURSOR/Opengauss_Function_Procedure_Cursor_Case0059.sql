-- @testpoint: 结合%rowcount判断游标数量

drop table if exists emp;
create table emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);


create or replace procedure p_emp_007(str boolean)
as
declare
    a emp%rowtype;
    cursor mycursor is  select * from emp where empno=1 order by ename;
begin
    open mycursor;
    fetch mycursor into a;
    if  mycursor%rowcount>0 then
        update emp set job='teacher' where empno=2;
        close mycursor;
    end if;
end;
/
call p_emp_007(true);
select * from emp;
drop procedure p_emp_007;
drop table emp;