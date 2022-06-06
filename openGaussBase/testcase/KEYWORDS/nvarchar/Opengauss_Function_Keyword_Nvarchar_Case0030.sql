-- @testpoint: opengauss关键字nvarchar(非保留)，作为触发器名,部分测试点合理报错

--step1:创建源表和触发表;expect:创建成功
drop table if exists t_nvarchar_0030;
drop table if exists t_trigger_nvarchar_0030;
create table t_nvarchar_0030(id1 int, id2 int, id3 int);
create table t_trigger_nvarchar_0030(id1 int, id2 int, id3 int);

--step2:创建触发器函数;expect:创建成功
create or replace function fun_trigger_0030() returns trigger as
    $$
    declare
    begin
       insert into t_trigger_nvarchar_0030 values(new.id1, new.id2, new.id3);
       return new;
    end
    $$ language plpgsql;
/

--step3:创建insert触发器不带引号;expect:创建成功
create trigger nvarchar before insert on t_nvarchar_0030 for each row execute procedure fun_trigger_0030();
/
drop trigger nvarchar on t_nvarchar_0030 cascade;

--step4:创建insert触发器带双引号;expect:创建成功
create trigger "nvarchar" before insert on t_nvarchar_0030 for each row execute procedure fun_trigger_0030();
/
drop trigger "nvarchar" on t_nvarchar_0030 cascade;

--step5:创建insert触发器带单引号;expect:合理报错
create trigger 'nvarchar' before insert on t_nvarchar_0030 for each row execute procedure fun_trigger_0030();
/

--step6:创建insert触发器带反单引号;expect:合理报错
create trigger `nvarchar` before insert on t_nvarchar_0030 for each row execute procedure fun_trigger_0030();
/

--step7:清理环境;expect:成功
drop table if exists t_nvarchar_0030;
drop table if exists t_trigger_nvarchar_0030;
drop function if exists fun_trigger_0030();
