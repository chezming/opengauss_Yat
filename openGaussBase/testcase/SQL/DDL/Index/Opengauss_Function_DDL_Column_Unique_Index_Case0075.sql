-- @testpoint: 列存普通表，创建时指定字段约束deferrable,合理报错

--测试点一:创建列存普通表，指定主键约束，指定字段约束可推迟
--step1:测试点一,创建列存普通表,指定主键约束，指定字段约束可推迟   expect:失败
drop table if exists t_columns_unique_index_0075_01;
create table t_columns_unique_index_0075_01(id1 smallint primary key deferrable initially deferred,id2 integer unique) with(orientation=column);

--step2:测试点一,清理环境   expect:不需要清理
--No need to clean


--测试点二:创建列存普通表，指定唯一约束，指定字段约束可推迟
--step1:测试点二,创建列存普通表,指定主键约束，指定字段约束可推迟   expect:失败
drop table if exists t_columns_unique_index_0075_02;
create table t_columns_unique_index_0075_02(id1 smallint, id2 integer unique deferrable initially deferred) with(orientation=column);

--step2:测试点二,清理环境   expect:不需要清理
--No need to clean
