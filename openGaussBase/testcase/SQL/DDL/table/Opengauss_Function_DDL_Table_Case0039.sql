-- @testpoint: 强制开启表的行访问控制开关(NO FORCE ROW LEVEL SECURITY)
drop table if exists alter_table_tb037;
create table alter_table_tb037
(
c1 int,
c2 bigint,
c3 varchar(20)
);
insert into alter_table_tb037 values('11',null,'sss');
insert into alter_table_tb037 values('21','','sss');
insert into alter_table_tb037 values('31',66,'');
insert into alter_table_tb037 values('41',66,null);
insert into alter_table_tb037 values('41',66,null);
ALTER TABLE alter_table_tb037 NO FORCE ROW LEVEL SECURITY;
drop table if exists alter_table_tb037;
