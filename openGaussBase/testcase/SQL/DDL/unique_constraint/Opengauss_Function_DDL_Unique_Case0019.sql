-- @testpoint: 对已有约束名字的列，使用alter创建不同名字的约束
--建表
drop table if exists test_unique_constraint019 cascade;
create table test_unique_constraint019 (id_p int not null, lastname varchar(255) not null, firstname varchar(255),
address varchar(255), city varchar(255),constraint uc_personid unique (id_p));
--增加约束
alter table test_unique_constraint019 add constraint personidnannaa unique (id_p);
--通过系统表查询约束信息
select conname,contype from pg_constraint where conrelid = (select oid from pg_class where relname = 'test_unique_constraint019') order by conname;
--删表
drop table if exists test_unique_constraint019;