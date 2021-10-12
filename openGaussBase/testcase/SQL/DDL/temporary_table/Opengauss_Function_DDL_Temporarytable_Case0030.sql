-- @testpoint: 删除主外键约束，添加cascade constraints参数
-- @modify at: 2020-11-24
--创建全局临时表1
drop table if exists temp_table_030;
create global temporary table temp_table_030(
c_id int,
c_integer integer,
c_real real,
c_float float,
c_double binary_double,
c_decimal decimal(38),
c_number number(38),
c_number1 number,
c_number2 number(20,10),
c_numeric numeric(38),
c_char char(50) default null,
c_varchar varchar(20),
c_varchar2 varchar2(4000),
c_clob clob,
c_raw raw(20),
c_blob blob,
c_date date,
c_timestamp timestamp
)on commit preserve rows;
--增加约束
alter table temp_table_030 add  constraint temp_table_030_pk primary key (c_id);
--插入数据
insert into temp_table_030 values(1,0,3.14,1.0002,3.55555,5,7887.656,0,0.111111,3.1415926,'dghg','jjj','pokj99',
insert into temp_table_030 values(2,0,3.14,1.0002,3.55555,5,7887.656,0,0.111111,3.1415926,'dghg','jjj','pokj99',
insert into temp_table_030 values(3,0,3.14,1.0002,3.55555,5,7887.656,0,0.111111,3.1415926,'dghg','jjj','pokj99',
--建表2
drop table if exists temp_table_030_bak;
create global temporary table temp_table_030_bak(a int);
--增加主外键约束
alter table temp_table_030_bak add constraint temp_table_030_bak_cons foreign key (a) references temp_table_030;
--删除约束
drop table temp_table_030 cascade constraints;
--查询表的约束信息，无数据
select conname,contype from pg_constraint where conrelid = (select oid from pg_class where relname = 'temp_table_030');
select conname,contype from pg_constraint where conrelid = (select oid from pg_class where relname = 'temp_table_030_bak');
--删表
drop table temp_table_030_bak;