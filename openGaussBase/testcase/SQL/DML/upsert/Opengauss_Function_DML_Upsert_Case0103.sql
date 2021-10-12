--  @testpoint:创建表指定两个字段为复合唯一约束，使用insert..update语句
--预置条件enable_upsert_to_merge为off

drop table if exists mykey_4d;
--建表指定id，name为唯一约束
create table mykey_4d
(
   name nvarchar2(20) ,
   id number  ,
   address nvarchar2(50),
   constraint unique_n_i unique(name,id)
) ;
--使用insert常规插入两条数据，唯一约束name列重复，插入两条数据
 insert into mykey_4d values('a',1,'yy'),('a',2,'yy');
 select * from mykey_4d;
 --使用insert常规插入两条数据，唯一约束id列重复，插入两条数据
 insert into mykey_4d values('b',1,'yy'),('c',1,'yy');
  select * from mykey_4d;
  --使用insert常规插入一条数据,唯一约束name和id列都重复，合理报错
  insert into mykey_4d values('b',1,'yy');
  --使用insert..update语句，插入一条数据，唯一约束name和id列都重复,更改数据('b',1,'yy')为('b',1,'xx')
  insert into mykey_4d values('b',1,'xx')ON DUPLICATE KEY UPDATE address='xx';
  select * from mykey_4d;
   --再次执行以上语句，数据未发生变化
  insert into mykey_4d values('b',1,'xx')ON DUPLICATE KEY UPDATE address='xx';
  --添加excluded关键字
  insert into mykey_4d values('b',1,'yy')ON DUPLICATE KEY UPDATE address=excluded.address;
  select * from mykey_4d;
  drop table mykey_4d;