-- @testpoint: 自定义函数嵌套调用———3层嵌套

--创建自定义函数1
create or replace function func_nest_transfer_005(v_id5 int) return int is
  v_num5 int;
begin
  raise info 'func_nest_transfer_005 begin';
  v_num5:=v_id5+1;
  raise info 'func_nest_transfer_005 end';
  return(v_num5);
end;
/
--创建自定义函数2
create or replace function func_nest_transfer_004(v_id4 int) return int is
  v_num4 int;
  v_num4_1 int;
begin
  raise info 'func_nest_transfer_004 begin';
  v_num4:=v_id4+1;
  select func_nest_transfer_005(v_num4) into v_num4_1;
  raise info 'func_nest_transfer_004 end';
  return(v_num4_1);
end;
/
--创建自定义函数3
create or replace function func_nest_transfer_003(v_id3 int) return int is
  v_num3 int;
  v_num3_1 int;
begin
  raise info 'func_nest_transfer_003 begin';
  v_num3:=v_id3+1;
  select func_nest_transfer_004(v_num3) into v_num3_1;
    raise info 'func_nest_transfer_003 end';
  return(v_num3_1);
end;
/
--调用自定义函数
select func_nest_transfer_003(3);

--恢复环境
drop function if exists func_nest_transfer_003;
drop function if exists func_nest_transfer_004;
drop function if exists func_nest_transfer_005;