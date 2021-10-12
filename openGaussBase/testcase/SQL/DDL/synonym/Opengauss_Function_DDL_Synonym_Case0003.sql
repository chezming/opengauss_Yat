-- @testpoint: 为不同长度的表名创建同义词
--建表
drop table if EXISTS syn_tab_003 cascade;
create table syn_tab_003(a int,b varchar);
--建同义词
drop synonym if exists syn_a;
create synonym syn_a for syn_tab_003;
--建表，表名63位
--建同义词
drop synonym if exists syn_a63;
select synobjname from pg_synonym WHERE synname='syn_a63';
--建表，表名64位
--建同义词
drop synonym if exists syn_a64;
select synobjname from pg_synonym WHERE synname='syn_a64';
--清理环境
drop table if EXISTS syn_tab_003 cascade;
drop synonym if exists syn_a;
drop synonym if exists syn_a63;
drop synonym if exists syn_a64;