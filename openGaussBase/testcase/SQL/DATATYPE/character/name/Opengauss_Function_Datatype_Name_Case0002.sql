-- @testpoint: 创建列存表，插入正常值，合理报错
-- @modified at: 2020-11-13

drop table if exists name_02;
CREATE  TABLE name_02 (id name) WITH (orientation=column);
