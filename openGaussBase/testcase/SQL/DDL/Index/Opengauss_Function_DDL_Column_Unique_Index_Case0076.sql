-- @testpoint: 列存普通表，创建时指定表级约束deferrable,部分step合理报错

--测试点一:创建列存普通表，指定主键约束，指定表级约束可推迟，重复插入相同数据
--step1:测试点一,创建列存普通表,指定主键约束，指定表级约束可推迟   expect:成功
drop table if exists t_columns_unique_index_0076_01;
create table t_columns_unique_index_0076_01(id1 smallint, id2 integer, primary key(id1) deferrable initially deferred) with(orientation=column);

--step2:测试点一,清理环境   expect:不需要清理
--No need to clean


--测试点二:创建列存普通表，指定唯一约束，指定表级约束可推迟，重复插入相同数据
--step1:测试点二,创建列存普通表,指定主键约束，指定表级约束可推迟   expect:成功
drop table if exists t_columns_unique_index_0076_02;
create table t_columns_unique_index_0076_02(id1 smallint, id2 integer,unique (id2) deferrable initially deferred) with(orientation=column);

--step2:测试点一,清理环境   expect:不需要清理
--No need to clean