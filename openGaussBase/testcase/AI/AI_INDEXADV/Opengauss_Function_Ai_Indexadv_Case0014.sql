-- @testpoint: 组合使用where条件，group  by分组，order by 排序,比较运算符,inner join ... using 连接,模糊查询like,范围查询in进行查询索引推荐

--test1:组合使用where条件，group  by分组，order by 排序,比较运算符,inner join ... using ,模糊查询like,范围查询in进行查询索引推荐
--step1:建表1;expect:建表1成功
drop table if exists t_table_ai_indexadv_0014 cascade;
create table t_table_ai_indexadv_0014 (col_int int,col_numeric numeric,
col_float float,col_char char(10),col_text text,col_time time);

--step2:建表2;expect:建表2成功
drop table if exists t_table_ai_indexadv1_0014 cascade;
create table t_table_ai_indexadv1_0014 (col_int int,col_dec dec,col_money money,col_boolean boolean,col_char char(10),col_clob clob);

--step3:建存储过程;expect:建存储过程成功
create or replace procedure p_procedure_insert_0014 (a int) is
V_int int;
V_numeric numeric;
V_float float;
V_char char(10);
V_text text;
V_time time;
begin
for i in 1..a
loop
V_int :=i;
V_numeric :=i+1.11;
V_float :=i*5.55;
V_char :='x_'|| i;
V_text :='V_text_'|| i;
V_time :='19:41:20';
execute immediate 'insert into t_table_ai_indexadv_0014 values
(:p1,:p2,:p3,:p4,:p5,:p6)
'using V_int,V_numeric,V_float,V_char,V_text,V_time;
end loop;
end;
/

--step4:建存储过程1;expect:建存储过程1成功
create or replace procedure p_procedure_insert1_0014() is
V_int int;
V_dec dec;
V_money money;
V_boolean boolean;
V_char char(10);
V_clob clob;
begin
for i in 2000..100000
loop
V_int :=i;
V_dec :=i*8.88;
V_money :=i*2;
V_boolean :='t';
V_char :=i ||'_x';
V_clob :='V_clob_'|| i;
execute immediate 'insert into t_table_ai_indexadv1_0014 values
(:p1,:p2,:p3,:p4,:p5,:p6)
'using V_int,V_dec,V_money,V_boolean,V_char,V_clob;
end loop;
end;
/

--step5:向表1，表2中插入100000条数据并统计数据的数量;expec:向表1，表2中插入数据成功,返回表数据的数量;
call p_procedure_insert_0014(100000);
select count(*) from t_table_ai_indexadv_0014;
call p_procedure_insert1_0014();
select count(*) from t_table_ai_indexadv1_0014;

--step6:组合使用where条件，group  by分组，order by 排序,比较运算符,inner join ... using ,模糊查询like,范围查询in进行查询索引腿荐;expect:返回推荐的索引列
select * from gs_index_advise('select t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric,t_table_ai_indexadv1_0014.col_money
from t_table_ai_indexadv_0014 inner join   t_table_ai_indexadv1_0014 using(col_int)
where t_table_ai_indexadv_0014.col_time=''19:41:20'' group by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_money order by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_money limit 20;');

select * from gs_index_advise('select t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric,t_table_ai_indexadv1_0014.col_money
from t_table_ai_indexadv_0014 inner join t_table_ai_indexadv1_0014 using(col_int)
where t_table_ai_indexadv_0014.col_int > 20000 group by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_money order by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_money limit 20;');

select * from gs_index_advise('select t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric,t_table_ai_indexadv1_0014.col_money
from t_table_ai_indexadv_0014 inner join t_table_ai_indexadv1_0014 using(col_int)
where t_table_ai_indexadv_0014.col_time=''19:41:20'' and t_table_ai_indexadv_0014.col_char in (''x_10000'', ''x_1000000'') group by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_money order by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_money limit 20;');

select * from gs_index_advise('select t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric,t_table_ai_indexadv1_0014.col_money
from t_table_ai_indexadv_0014 inner join   t_table_ai_indexadv1_0014 using(col_int)
where t_table_ai_indexadv_0014.col_int < 3000 and t_table_ai_indexadv1_0014.col_money in (''$5,998.00'', ''$5,960.00'',''$5,982.00'') group by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_money order by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_money limit 20;');

select * from gs_index_advise('select t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric,t_table_ai_indexadv1_0014.col_money
from t_table_ai_indexadv_0014 inner join   t_table_ai_indexadv1_0014 using(col_int)
where t_table_ai_indexadv_0014.col_time=''19:41:20'' or t_table_ai_indexadv1_0014.col_char in (''x_10000'', ''x_1000000'') group by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_money order by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_money limit 20;');

select * from gs_index_advise('select t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric,t_table_ai_indexadv1_0014.col_money
from t_table_ai_indexadv_0014 inner join   t_table_ai_indexadv1_0014 using(col_int)
where t_table_ai_indexadv1_0014.col_int < 3000 or t_table_ai_indexadv1_0014.col_money in (''$5,998.00'', ''$5,960.00'',''$5,982.00'')   group by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_money order by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_money limit 20;');

select * from gs_index_advise('select t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric,t_table_ai_indexadv_0014.col_text
from t_table_ai_indexadv_0014 inner join  t_table_ai_indexadv1_0014 using(col_int)
where t_table_ai_indexadv_0014.col_text like ''V_text_2999%''   group by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv_0014.col_text order by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv_0014.col_text limit 20;');

select * from gs_index_advise('select t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric,t_table_ai_indexadv1_0014.col_dec
from t_table_ai_indexadv_0014 inner join   t_table_ai_indexadv1_0014 using(col_int)
where t_table_ai_indexadv1_0014.col_dec like ''%.88''   group by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_dec order by   t_table_ai_indexadv_0014.col_int,t_table_ai_indexadv_0014.col_numeric ,t_table_ai_indexadv1_0014.col_dec limit 20;');

--step7:清理环境;expect:清理环境成功
drop table t_table_ai_indexadv_0014;
drop table t_table_ai_indexadv1_0014;
drop procedure p_procedure_insert_0014;
drop procedure p_procedure_insert1_0014;