-- @testpoint: 插入字符串形式16进制
-- @modify at: 2020-11-04

--创建表
drop table if exists test_raw04;
create table test_raw04 (name raw);

--插入数据
insert into test_raw04 values ('DEADBEEF');

--插入成功，查看数据
select * from test_raw04;

--清理环境
drop table test_raw04;