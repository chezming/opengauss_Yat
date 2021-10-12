-- @testpoint: interval分区,创建分区表索引：GLOBAL索引,不支持表达式索引，合理报错
drop index if exists pt_idx_001;
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
interval ('1 month')
(
	partition table1_p1 values less than ('2020-03-01'),
	partition table1_p2 values less than ('2020-04-01'),
	partition table1_p3 values less than ('2020-05-01')
);

-- 分区表GLOBAL索引，表达式索引
create index pt_idx_001 on table1(substr(col_4,4 ,1)) global;

drop index if exists pt_idx_001;
drop table if exists table1;