-- @testpoint: 插入右边界范围值
-- @nodified at: 2020-11-25

begin
  drop table if exists smallserial_08;
  create table smallserial_08 (name smallserial);
  for i in 1 .. 32767 loop
    insert into smallserial_08 values (default);
  end loop;
end;
/
select count(*) from smallserial_08;
drop table smallserial_08;