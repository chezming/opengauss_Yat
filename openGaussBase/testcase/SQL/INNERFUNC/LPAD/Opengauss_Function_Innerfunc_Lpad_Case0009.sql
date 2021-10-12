-- @testpoint: lpad函数与insert结合使用
drop table if exists TEST_LPAD16;
create table TEST_LPAD16 (COL1 VARCHAR2(20),COL2 integer,COL3 VARCHAR2(20));
insert into TEST_LPAD16 values('123', 10, 'abc');
insert into TEST_LPAD16 values('123', 10, (lpad('hi', 5, 'xyza')));
drop table TEST_LPAD16;
