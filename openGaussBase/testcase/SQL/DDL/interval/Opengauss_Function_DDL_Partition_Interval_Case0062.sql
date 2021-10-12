-- @testpoint: interval分区,INSERT时先创建后面的分区，再创建前面的分区
drop table if exists table1;

create table table1(
col_1 smallint,
col_2 char(30),
col_3 int,
col_4 date not null,
col_5 boolean,
col_6 nchar(30),
col_7 float
)
partition by range (col_4)
interval ('1 year')
(
	partition table1_p1 values less than ('2020-03-01')
);

insert into table1 values(2,'bbb',2,'2025-02-28',false,'bbb',2.2);
insert into table1 values(2,'bbb',2,'2023-02-28',false,'bbb',2.2);
insert into table1 values(2,'bbb',2,'2020-02-28',false,'bbb',2.2);
insert into table1 values(2,'bbb',2,'2019-02-28',false,'bbb',2.2);
insert into table1 values(2,'bbb',2,'2026-02-28',false,'bbb',2.2);

select t1.relname, partstrategy, boundaries from pg_partition t1, pg_class t2
where t1.parentid = t2.oid and t2.relname = 'table1' and t1.parttype = 'p' order by t1.relname;

drop table if exists table1;