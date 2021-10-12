-- @testpoint: 匿名块异常捕获

drop table if exists t_cur_emp;
create table t_cur_emp(eno int ,en varchar2(200),sal number);
insert into t_cur_emp values(1,'xu',100);
insert into t_cur_emp values(2,'zhang',200);
insert into t_cur_emp values(3,'li',300);

declare
  v_sal int;
  sal_overflow exception;
begin
  v_sal := 2000;
  insert into t_cur_emp values (4, 'zhengxiao', v_sal);
  if v_sal >= 1000 then
    raise sal_overflow;
  end if;
exception
  when sal_overflow then
    raise notice 'sal overflow';
    raise notice 'error code:%',sqlstate;
    raise notice 'error message:%',sqlerrm;
  when others then
    raise notice 'else exception'; 
end;
/

drop table if exists t_cur_emp;
