--  @testpoint: 创建表验证字段大小写敏感：报错
drop table if EXISTS false_1 CASCADE;
create table false_1(a int,A int,b CHAR(10));