--- Case Type： Comment
--- Case Name： 在索引上添加注释

--创建表，创建索引
drop table if exists index_comment;
create table index_comment(id int,name varchar(10));
create index index1 on index_comment(id);

--给索引添加注释信息
comment on index index1 is '测试索引注释添加成功';

--在相关系统表中查看注释是否添加成功
select description from pg_description where objoid=(select oid from pg_class where relname='index1');

--清理环境
drop table index_comment;


