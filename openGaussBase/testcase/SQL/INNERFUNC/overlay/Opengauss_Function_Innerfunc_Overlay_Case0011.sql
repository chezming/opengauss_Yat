-- @testpoint: overlay函数与insert结合使用
drop table if exists TEST_LPAD16;
create table TEST_LPAD16 (COL1 VARCHAR2(20),COL2 integer,COL3 VARCHAR2(20));
insert into TEST_LPAD16 values(overlay('hello' placing 'world' from 2 for 3), 10, 'abc');
drop table  TEST_LPAD16;