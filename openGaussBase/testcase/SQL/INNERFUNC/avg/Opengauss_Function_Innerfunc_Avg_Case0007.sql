-- @testpoint: targetlist列
drop table if exists test_avg_001;
create table test_avg_001(
COL_1 bigint,
COL_2 TIMESTAMP WITHOUT TIME ZONE,
COL_3 boolean,
COL_4 decimal,
COL_5 text,
COL_6 smallint,
COL_7 char(30),
COL_17 int ,
COL_42 number(6,2),
COL_44 varchar2(50),
COL_58 number(12,6));
1,'@dfsgdf',8,32.23,'gfhgfh',122);
select avg(COL_17),avg(COL_42),avg(COL_58) from test_avg_001 order by 1,2,3;
drop table if exists test_avg_001;