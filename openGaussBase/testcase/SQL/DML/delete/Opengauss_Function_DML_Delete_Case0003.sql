--  @testpoint:delete语法中，使用using子句
--建表
drop table if exists t_delete02;
create table t_delete02(id int,name varchar(10));
--插入多条重复的数据
insert into t_delete02 values (1,'小明');
insert into t_delete02 values (2,'小明');
insert into t_delete02 values (3,'小明');
insert into t_delete02 values (4,'小李');
insert into t_delete02 values (5,'小李');
insert into t_delete02 values (6,'小李');
insert into t_delete02 values (7,'小红');
insert into t_delete02 values (8,'小红');
--删除表中重复的数据，删除5条重复数据
delete from t_delete02 a using t_delete02 b where a.id<b.id and a.name=b.name;
select * from t_delete02;
--删除表
drop table t_delete02;