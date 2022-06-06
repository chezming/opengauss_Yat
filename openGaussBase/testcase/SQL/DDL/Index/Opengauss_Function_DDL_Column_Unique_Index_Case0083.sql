-- @testpoint: 创建列存表,验证数值数据类型对主键/唯一约束/唯一索引的支持,部分step合理报错

--测试点一:创建列存普通表，字段类型为数值型，指定主键约束
--step1:测试点一,创建列存普通表,字段类型为数值型,指定主键约束   expect:成功
drop table if exists t_columns_unique_index_0083_01;
create table t_columns_unique_index_0083_01(
id1 smallint, id2 integer, id3 bigint, id4 decimal(10,4), id5 numeric(8,3),id6 real,
id7 double precision, id8 smallserial, id9 serial, id10 bigserial,
primary key(id1,id2,id3,id4,id5,id6,id7,id8,id9,id10)) with(orientation=column);

--step2:测试点一,插入数据   expect:成功
insert into t_columns_unique_index_0083_01 values(32765,2147483647,9223372036854,123456.1223,33456.255,10.3655,123456.1234,1,1,1);

--step3:测试点一,再次插入重复数据   expect:失败
insert into t_columns_unique_index_0083_01 values(32765,2147483647,9223372036854,123456.1223,33456.255,10.3655,123456.1234,1,1,1);

--step4:测试点一,清理环境    expect:成功
drop table t_columns_unique_index_0083_01;


--测试点二:创建列存普通表，字段类型为数值型，指定唯一约束
--step1:测试点二,创建列存普通表,字段类型为数值型,指定唯一约束   expect:成功
drop table if exists t_columns_unique_index_0083_02;
create table t_columns_unique_index_0083_02(
id1 smallint, id2 integer, id3 bigint, id4 decimal(10,4), id5 numeric(8,3),id6 real,
id7 double precision, id8 smallserial, id9 serial, id10 bigserial,
constraint const_83 unique(id1,id2,id3,id4,id5,id6,id7,id8,id9,id10)) with(orientation=column);

--step2:测试点二,插入数据   expect:成功
insert into t_columns_unique_index_0083_02 values(32765,2147483647,9223372036854,123456.1223,33456.255,10.3655,123456.1234,1,1,1);

--step3:测试点二,再次插入重复数据   expect:失败
insert into t_columns_unique_index_0083_02 values(32765,2147483647,9223372036854,123456.1223,33456.255,10.3655,123456.1234,1,1,1);

--step4:测试点二,清理环境    expect:成功
drop table t_columns_unique_index_0083_02;


--测试点三:创建列存普通表，字段类型为数值型，创建唯一索引
--step1:测试点三,创建列存普通表,字段类型为数值型   expect:成功
drop table if exists t_columns_unique_index_0083_03;
create table t_columns_unique_index_0083_03(
id1 smallint, id2 integer, id3 bigint, id4 decimal(10,4), id5 numeric(8,3),id6 real,
id7 double precision, id8 smallserial, id9 serial, id10 bigserial) with(orientation=column);

--step2:创建唯一索引   expect:成功
create unique index i_columns_unique_index_0083 on t_columns_unique_index_0083_03 using btree(id1,id2,id3,id4,id5,id6,id7,id8,id9,id10);

--step2:测试点三,插入数据   expect:成功
insert into t_columns_unique_index_0083_03 values(32765,2147483647,9223372036854,123456.1223,33456.255,10.3655,123456.1234,1,1,1);

--step3:测试点三,再次插入重复数据   expect:失败
insert into t_columns_unique_index_0083_03 values(32765,2147483647,9223372036854,123456.1223,33456.255,10.3655,123456.1234,1,1,1);

--step4:测试点三,清理环境    expect:成功
drop table t_columns_unique_index_0083_03;



