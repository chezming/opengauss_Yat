-- @testpoint: 创建列类型是伪类型的表，合理报错
drop table if exists table_2;
create table table_2(a any,b any ,c any);
drop table if exists table_2;