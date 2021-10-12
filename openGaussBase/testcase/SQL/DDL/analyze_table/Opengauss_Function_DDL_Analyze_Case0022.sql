-- @testpoint: 创建联合索引，进行analyze

drop table if exists tbl_009;
create table tbl_009
(col_tinyint      tinyint,col_smallint         smallint,col_int  integer, col_smallserial      varchar(30),col_float      float(3),col_char   char(30),col_boolean   boolean
);
insert into tbl_009 values(10,-1562,13,'aa',3.1415926,'cc','true');
insert into tbl_009 values(100,9152,24234,'aa',3.1415926,'cc','true');
insert into tbl_009 values(0,102,13,'aa',3.1415926,'cc','true');
insert into tbl_009 values(255,32712,1234,'aa',3.1415926,'cc','true');

create index idx001 on tbl_009(col_tinyint,col_int);
analyze tbl_009;
drop table if exists tbl_009;