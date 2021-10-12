-- @testpoint: uuid数据类型转换至varchar2,char
-- @modified at: 2020-11-30

drop table if exists test_uuid_03;
create table test_uuid_03 (id uuid);
insert into test_uuid_03 values ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11');
select * from test_uuid_03;
alter table test_uuid_03 alter column id type varchar2(200);
--查看字段信息修改是否成功
select format_type(a.atttypid,a.atttypmod) as type from pg_class as c,pg_attribute as a where c.relname = 'test_uuid_03' and a.attrelid = c.oid and a.attnum>0;

drop table if exists test_uuid_03;
create table test_uuid_03 (id uuid);
insert into test_uuid_03 values ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11');
select * from test_uuid_03;
alter table test_uuid_03 alter column id type char(100);
--查看字段信息修改是否成功
select format_type(a.atttypid,a.atttypmod) as type from pg_class as c,pg_attribute as a where c.relname = 'test_uuid_03' and a.attrelid = c.oid and a.attnum>0;

drop table test_uuid_03;