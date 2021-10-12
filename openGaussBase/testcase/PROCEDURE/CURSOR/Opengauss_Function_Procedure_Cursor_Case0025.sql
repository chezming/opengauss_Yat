-- @testpoint: 存储过程中使用游标

drop table if exists emp;
create table emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into emp values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into emp values(10,'abc','worker',9000);
insert into emp values(716,'ZHANGSAN','leader',20000);

create or  replace procedure syscur_025() is
    cursor mycursor is select * from emp  where  sal <> 10000;
    a emp%rowtype;
begin
    open mycursor;
    fetch mycursor into a;
        raise info 'sal is not 10000:%',a.ename;
    close mycursor;
end;
/
call syscur_025();
drop table emp;
drop procedure syscur_025;

