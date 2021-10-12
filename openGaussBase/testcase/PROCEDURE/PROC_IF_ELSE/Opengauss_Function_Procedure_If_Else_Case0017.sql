-- @testpoint: 测试利用存储过程中的if和for loop语句实现冒泡排序

--创建存储过程
create or replace procedure bubble_sort
as
  v_order int;
  v_i int;
  v_j int;
  value_i int;
  value_j int;
  border_i int;
  border_j int;
  value_tmp int;
  min_value int;
  v_sql varchar2(256);
begin
    v_sql:='drop table if exists bubble';
    execute immediate v_sql;
    v_sql:='create table if not exists bubble(id int,value int)';
    execute immediate v_sql;
    v_sql:='insert into bubble(id,value) values (1,20),(2,102),(3,5),(4,12),(5,17),(6,100),(7,99),(8,1),(9,100),(10,11)';
    execute immediate v_sql;
    execute immediate 'select max(id) from bubble' into v_order;
    border_i:=v_order;
    for i in 1..border_i
    loop
        execute immediate 'select value from bubble where id=' ||i into min_value;
		border_j:=i+1;
        for j in border_j..v_order
        loop
            execute immediate 'select value from bubble where id=' ||j into value_tmp ;
            if(value_tmp<min_value)
            then
                v_sql:='update bubble set value=' ||value_tmp||' where id='|| i;
				execute immediate v_sql;
				v_sql:='update bubble set value=' ||min_value||' where id='|| j;
				execute immediate v_sql;
            end if;
        end loop;
        raise info 'result:%',min_value;
    end loop;
end;
/
--调用存储过程
call bubble_sort();

--清理环境
drop procedure bubble_sort;
drop table if exists bubble;