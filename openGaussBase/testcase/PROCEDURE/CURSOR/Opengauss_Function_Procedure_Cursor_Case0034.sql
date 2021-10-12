-- @testpoint: 存储过程中游标变量作为out参数

drop table if exists emp_test;
create table emp_test(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into emp_test values(1,'zhangsan','doctor1',10000);
insert into emp_test values(2,'zhangsan2','doctor2',10000);
insert into emp_test values(123,'zhangsan3','doctor3',10000);
insert into emp_test values(1,'zhansi','doctor1',12000);
insert into emp_test values(2,'lisiabc','doctor2',13000);
insert into emp_test values(123,'zhangwu123','doctor3',14000);

create or replace procedure syscur_034(sys_cur OUT sys_refcursor)
is
C1 sys_refcursor;
begin
open C1 for
    select empno,ename from emp_test  where empno=1 order by empno,ename;
sys_cur := C1;
end;
/

declare
  cv SYS_REFCURSor;
  v_empno     emp_test.empno%TYPE;
  v_ename     emp_test.ename%TYPE;
begin
syscur_034(cv);
  loop
    fetch cv into v_empno, v_ename;
    exit when cv%NOTFOUND;
	raise info ':%',v_ename;
  end loop;
  raise info '-------------------------------------';
  close cv;
end;
/

drop procedure syscur_034;