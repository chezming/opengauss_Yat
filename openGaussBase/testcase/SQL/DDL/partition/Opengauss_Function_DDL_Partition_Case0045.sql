-- @testpoint: 范围分区表，分区键为数值(number)，测试analyze收集统计信息功能

drop table if exists partition_range00009;
create table partition_range00009(
field1   integer,
field2   bigint,
field3   real,
field4   decimal(10,2),
field5   number(38),
field6   char(10),
field7   varchar(10),
field8   varchar2(20),
field9   CLOB,
field10  BLOB,
field11  varchar2(1024),
field12 date,
field13 timestamp,
field14 INTERVAL DAY(3) TO SECOND(4),
field15 timestamp with time zone,
field16 timestamp,
field17 boolean,
field18  varchar(1024),
field19  raw(1027)
)partition by range(field5)
  (
partition part01 values less than (10),
partition part02 values less than (100),
partition part03 values less than (150),
partition part04 values less than (200),
partition part05 values less than (300),
partition part06 values less than (600),
partition part07 values less than (800),
partition part08 values less than (1000),
partition part09 values less than (3000),
partition part10 values less than (4000),
partition part11 values less than (5000),
partition part12 values less than (6000),
partition part13 values less than (7000),
partition part14 values less than (maxvalue)
 );
 declare
i int:=0;
begin
  loop
    i:=i+1;
'2012-11-11 00:00:00',interval '2' day,'2016-12-11 00:00:00','2011-12-11 00:00:00','true',null,null);
exit when i= 1000;
  end loop;
  raise info'111';
end;
/

analyze verbose  partition_range00009 ;
drop table if exists partition_range00009;