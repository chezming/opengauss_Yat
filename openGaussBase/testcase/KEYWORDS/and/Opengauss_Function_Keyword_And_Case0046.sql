--  @testpoint:定义and列带单引号，应该报错
drop table if exists  t_student ;
create table t_student ('and' char(20),stu_age int,sex char(10),score int,address char(10) default 'gauss');