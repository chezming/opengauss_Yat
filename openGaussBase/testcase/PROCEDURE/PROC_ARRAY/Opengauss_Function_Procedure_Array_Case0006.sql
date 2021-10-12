-- @describe:存储过程中将一个record类型变量赋值为NULL

--创建表
drop table if exists emp_rec;
create table emp_rec(
empno      numeric(4,0) not null,
ename      character varying(10),
job        character varying(9),
mgr        numeric(4,0),
hiredate   timestamp(0) without time zone,
sal        numeric(7,2),
comm       numeric(7,2),
deptno     numeric(2,0));

--创建存储过程
CREATE OR REPLACE procedure pro_record_006() AS
DECLARE
   type rec_type1 is record (name emp_rec.ename%type,epno int not null :=10);
   employer1 rec_type1;
BEGIN
     employer1 := NULL;
     raise info 'employer1 name:%,epno:%',employer1.name,employer1.epno;

END;
/

--调用存储过程
call pro_record_006();

--删除存储过程
drop procedure pro_record_006;

--删除表
drop table emp_rec;
