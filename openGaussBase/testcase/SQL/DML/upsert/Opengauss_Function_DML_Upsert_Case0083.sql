--  @testpoint:建表时指定id列是主键，后修改name列是主键，使用insert..update语句并加关键字EXCLUDED插入数据
--预置条件enable_upsert_to_merge为off
drop table if exists mykey_0b;
--建表指定id字段为主键
create table mykey_0b
(
   name nvarchar2(20),
   id number primary key ,
   address nvarchar2(50)
) ;
--常规insert插入一条数据
insert into mykey_0b values('kihy',5,'jinhua');
select * from mykey_0b;
--使用insert..update语句,主键冲突，故更新name和address值，原数据('kihy',5,'jinhua')修改为('lisa',5,'dalian')
insert into mykey_0b values('lisa',5,'dalian') ON DUPLICATE KEY UPDATE  name=EXCLUDED.name,address=EXCLUDED.address;
select * from mykey_0b;
--删除id列的主键约束
alter table mykey_0b drop constraint mykey_0b_pkey;
--常规插入id已存在的值，合理插入
insert into mykey_0b values('liqi',5,'dalian');
select * from mykey_0b;
--使用insert..update语句，id已存在，新增一条数据('lisa1',5,'yunnan'),正常插入
INSERT INTO mykey_0b VALUES('lisa1',5,'yunnan') ON DUPLICATE KEY UPDATE name=EXCLUDED.name,address=EXCLUDED.address;
select * from mykey_0b;
drop table mykey_0b;