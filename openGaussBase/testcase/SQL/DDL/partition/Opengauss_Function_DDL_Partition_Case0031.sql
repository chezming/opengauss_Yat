-- @testpoint: 范围分区全部数据类型，测试二进制单列索引有数据表的analyze功能

drop table if exists PARTITION_RANGE012;
create table PARTITION_RANGE012(
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
field11  varchar2(1024),
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
create index index_PARTITION_RANGE0126 on PARTITION_RANGE012(field18) local;
declare
i int:=0;
begin
  loop
    i:=i+1;
insert into PARTITION_RANGE012  values(256,10000000,123.3212,123456.123,123456,'dnf','957',
'2012-11-11 00:00:00',interval '2' day,'2016-12-11 00:00:00','2011-12-11 00:00:00','true',null,null);
exit when i= 100;
  end loop;
  raise info'111';
end;
/

 declare
i int:=0;
begin
  loop
    i:=i+1;
insert into PARTITION_RANGE012  values(256,10000000,123.3212,123456.123,123456,'dnf','957',
'2012-11-11 00:00:00',interval '2' day,'2016-12-11 00:00:00','2011-12-11 00:00:00','true',null,null);
exit when i= 1000;
  end loop;
  raise info'111';
end;
/

  declare
i int:=0;
begin
  loop
    i:=i+1;
insert into PARTITION_RANGE012  values(256,10000000,123.3212,123456.123,123456,'dnf','957',
'2012-11-11 00:00:00',interval '2' day,'2016-12-11 00:00:00','2011-12-11 00:00:00','true',null,null);
exit when i= 1000;
  end loop;
  raise info'111';
end;
/

analyze verbose  PARTITION_RANGE012;
drop table if exists PARTITION_RANGE012;