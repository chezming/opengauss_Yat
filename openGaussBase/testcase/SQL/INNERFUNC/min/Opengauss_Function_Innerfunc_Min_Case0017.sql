-- @testpoint: 函数调用min结合group by--inet

--step1:创建表; expect:成功
drop table if exists t_min_case0017;
create table t_min_case0017(id int, i inet);

--step2:创建函数; expect:成功
create or replace function f_min_case0017()
returns table(r_i int, i_c inet)
as $$
begin
return query select id, min(i)  from t_min_case0017 group by id order by id;
end;
$$language plpgsql;/

--step3:调用函数; expect:空
select f_min_case0017();

--step4:插入空值; expect:空 ::
insert into t_min_case0017 values(1, NULL);
select f_min_case0017();
insert into t_min_case0017 values(1, '::');
select f_min_case0017();

--step5:插入数据; expect:(1,::) (2,::255.255.0.0/120)
insert into t_min_case0017 values(1, '::ffff/128'),(2, '::ffff:0/120');
select f_min_case0017();

--step6:插入数据; expect:(1,::) (2,::)
insert into t_min_case0017 values(1, '0:0:0:0:0:0:0:0'),(2, '0:0:0:0:0:0:0:0');
select f_min_case0017();

--tearDown
drop function f_min_case0017;
drop table if exists t_min_case0017;

