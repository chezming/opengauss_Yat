-- @testpoint: 模式匹配POSIX正则表达式,~大小写敏感匹配，模式与串相等
DROP TABLE IF EXISTS type_char;
CREATE TABLE type_char (string1 varchar(10));
insert into type_char values ('abc');
SELECT  * from type_char  where string1 ~ 'abc';
DROP TABLE IF EXISTS type_char;