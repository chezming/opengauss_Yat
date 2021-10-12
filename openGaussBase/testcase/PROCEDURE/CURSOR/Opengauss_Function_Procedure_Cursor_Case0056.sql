-- @testpoint: 隐式游标%found，提取数据

drop table if exists emp;
create table emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);

create or replace procedure p_emp_004(str boolean)
AS
declare
    a emp%rowtype;
    cursor mycursor is  select * from emp where empno=1 order by ename;
begin
    open mycursor;
    fetch  mycursor into a;
    if mycursor%found then
        insert into emp values(1,'zhangsan','doctor1',10001);
    end if;
    close mycursor;
end;
/
call p_emp_004(true);
select * from emp;
drop procedure p_emp_004;
drop table emp;
