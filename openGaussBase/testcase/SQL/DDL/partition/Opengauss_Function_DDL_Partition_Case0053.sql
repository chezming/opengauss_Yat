-- @testpoint: 范围分区全部数据类型，测试单列函数索引空表的analyze功能,暂不支持

drop table if exists partition_range039;
create table partition_range039(
field1   integer,
field2   bigint,
field3   real,
field4   decimal(10,2),
field5   number(6),
field6   char(10),
field7   varchar(10),
field8   varchar2(20),
field9   CLOB,
field10  BLOB,
field11 varchar2(1024),
field12 date,
field13 timestamp,
field14 INTERVAL DAY(3) TO SECOND(4),
field15 timestamp with time zone,
field16 timestamp,
field17 boolean,
field18  varchar(1024),
field19  raw(1027)
)partition by range(field12)
  (
      partition part01 values less than (TO_DATE('2008-07-1 00:00:00','yyyy-mm-dd hh24:mi:ss')),
      partition part02 values less than (TO_DATE('2008-08-1 00:00:00','yyyy-mm-dd hh24:mi:ss')),
      partition part03 values less than (TO_DATE('2008-09-1 00:00:00','yyyy-mm-dd hh24:mi:ss')),
partition part04 values less than (maxvalue)
 );
create index index_partition_range0391 on partition_range039(sin(field1)) local;--局部函数索引
create index index_partition_range0392 on partition_range039(sin(field1)) local; --全局函数索引
create index index_partition_range0393 on partition_range039(sin(field5)) local;
analyze verbose  partition_range039 ;  --12月份只支持此命令
drop table if exists partition_range039;