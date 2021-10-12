-- @testpoint: 存储过程中goto语句使用 如果从goto到一个不包含执行语句的位置，需要添加null语句。

create or replace procedure goto_test()
as
declare
   done  boolean;
begin
   for i in 1..50 loop
      if done then
         goto end_loop;
      end if;
      <<end_loop>>
      null;
   end loop;
end;
/
call  goto_test();
drop procedure goto_test;
