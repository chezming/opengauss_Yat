--  @testpoint:创建表未指定主键约束，使用alter语句增加主键约束后使用insert..update语句并加关键字EXCLUDED
--预置条件enable_upsert_to_merge为off
drop table if exists test3;
--创建表未指定主键约束
create table test3 (id int ,name varchar(20) );
--给id列添加主键约束
ALTER TABLE test3 ADD CONSTRAINT id_key primary key (id);
--使用insert常规插入一条数据
insert into test3 values(5,'daliu');
select * from test3;
--使用insert..update语句并加关键字EXCLUDED,插入两条数据，主键均不重复，新增两条数据(6,'lisa1'),(7,'lisa2')
insert into test3 values(6,'lisa1'),(7,'lisa2') ON DUPLICATE KEY UPDATE name=EXCLUDED.name;
select * from test3;
--使用insert..update语句并加关键字EXCLUDED,插入两条数据,第一条主键重复，name列不重复，第二条主键不重复，name列不重复，故更新(6,'lisa1')为(6,'xiaomin')；新增一条数据(8,'lilk')
insert into test3 values(6,'xiaomin'),(8,'lilk') ON DUPLICATE KEY UPDATE name=EXCLUDED.name;
select * from test3;
--使用insert..update语句并加关键字EXCLUDED,插入两条数据，主键和name列已存在，数据未发生变化
insert into test3 values(6,'xiaomin'),(8,'lilk') ON DUPLICATE KEY UPDATE name=EXCLUDED.name;
select * from test3;
drop table test3;