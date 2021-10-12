-- @testpoint: 游标%rowtype，for循环里用fetch 合理报错

drop table if exists emp;
create table emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into emp values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into emp values(10,'abc','worker',9000);
insert into emp values(716,'ZHANGSAN','leader',20000);

create or replace procedure syscur_019()
is
declare
    cursor mycursor  is select * from emp where  ename like '%ZHANGSAN%' and sal > 9000 ;
    c mycursor%rowtype;
begin
    for a  in  mycursor
    loop
    open mycursor;
    fetch mycursor into c;
        raise info 'a is emp:%',c.ENAME;
        raise info 'user$ name is:% ',c.job;
        raise info ':%',mycursor%rowcount;
    end loop;
end;
/
call syscur_019();
drop table emp;
drop procedure syscur_019;