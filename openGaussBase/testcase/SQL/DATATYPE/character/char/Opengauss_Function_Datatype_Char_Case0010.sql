-- @testpoint: 字节长度设为0，合理报错
-- @modify at: 2020-11-05


--char类型字节设置为0，创建表失败，至少为1
drop table if exists test_char_10;
create table test_char_10 (name char(0));



