-- @testpoint: 表名和列名同时出现关键字and
drop table if exists "and";
create table "and"("and" char(20),stu_age int,sex char(10),score int,address char(10) default 'gauss');
drop table if exists "and";