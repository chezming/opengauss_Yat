-- @testpoint: opengauss逻辑操作符AND,一个为真一个为假
drop table if exists ts_zhparser;
CREATE TABLE ts_zhparser(id int, index int);
INSERT INTO ts_zhparser VALUES(2, 100);
select * from ts_zhparser where id >1 AND index >500;
drop table if exists ts_zhparser;