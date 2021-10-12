-- @describe:存储过程中在cursor中使用record变量

--创建表
drop table if exists emp_rec;
create table emp_rec(
empno      numeric(4,0)     not null,
ename      character varying(10),
job        character varying(9),
mgr        numeric(4,0),
hiredate   timestamp(0) without time zone ,
sal        numeric(7,2) ,
comm       numeric(7,2) ,
deptno     numeric(2,0) );

--创建存储过程
CREATE OR REPLACE procedure pro_record_005() AS
DECLARE
  type rec_type2 is record (
        name varchar2 not null := 'SCOTT',
        epno int not null :=10);
		employer2 rec_type2;
		CURSOR C1 IS select ename,empno from emp_rec order by 1 limit 1;
BEGIN
      OPEN C1;
      FETCH C1 INTO employer2;
      raise info 'employer2 name:%,epno2:%',employer2.name,employer2.epno;
      CLOSE C1;
 END;
 /
 
 --调用存储过程
call pro_record_005();

--删除存储过程
drop procedure pro_record_005;

--删除表
drop table emp_rec;