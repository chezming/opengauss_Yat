-- @testpoint: interval分区,分区数据类型与分区键不一致，合理报错
-- partition key value must be const or const-evaluable expression
drop table if exists partition_table_001;

create table partition_table_001( 
col_1 smallint,
col_2 char(30),
col_3 int,
col_4 date,
col_5 boolean, 
col_6 nchar(30),
col_7 float
)
partition by range (col_4)
interval ('1 month') 
(
	partition partition_table_001_p1 values less than (2018)
);
