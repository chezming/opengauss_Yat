-- @testpoint: opclass:操作符类:列存,合理报错

--建表：列存
DROP TABLE if EXISTS tb2 CASCADE;
create table tb2(
c_int int,
c_float float4,
c_smalldatetime smalldatetime,
c_cidr cidr,
c_time time,
c_text text,
c_clob clob,
c_timestamp timestamp,
c_numeric numeric,
c_varchar varchar,
c_bytea bytea,
c_bool bool,
c_money money,
c_date date,
c_inet inet
) with (orientation = column);

--建索引指定操作符簇
create index idx_01 on tb2 using psort(c_int int4_ops) ;
create index idx_02 on tb2 using psort(c_float float4_ops) ;
create index idx_03 on tb2 using psort(c_smalldatetime smalldatetime_ops) ;
create index idx_04 on tb2 using psort(c_cidr cidr_ops) ;
create index idx_05 on tb2 using psort(c_time time_ops) ;
create index idx_06 on tb2 using psort(c_text text_ops) ;
create index idx_07 on tb2 using psort(c_timestamp timestamp_ops) ;
create index idx_08 on tb2 using psort(c_numeric numeric_ops) ;
create index idx_09 on tb2 using psort(c_varchar varchar_ops) ;
create index idx_10 on tb2 using psort(c_bytea bytea_ops) ;
create index idx_11 on tb2 using psort(c_bool bool_ops) ;
create index idx_12 on tb2 using psort(c_money money_ops) ;
create index idx_14 on tb2 using psort(c_inet inet_ops) ;
select relname from pg_class where relname like 'idx_%' order by relname;

--建索引指定操作符簇
create index idx_16 on tb2 using btree(c_int int4_ops) ;
create index idx_17 on tb2 using btree(c_float float4_ops) ;
create index idx_18 on tb2 using btree(c_smalldatetime smalldatetime_ops) ;
create index idx_19 on tb2 using btree(c_cidr cidr_ops) ;
create index idx_20 on tb2 using btree(c_time time_ops) ;
create index idx_21 on tb2 using btree(c_text text_ops) ;
create index idx_22 on tb2 using btree(c_timestamp timestamp_ops) ;
create index idx_23 on tb2 using btree(c_numeric numeric_ops) ;
create index idx_24 on tb2 using btree(c_varchar varchar_ops) ;
create index idx_25 on tb2 using btree(c_bytea bytea_ops) ;
create index idx_26 on tb2 using btree(c_bool bool_ops) ;
create index idx_27 on tb2 using btree(c_money money_ops) ;
create index idx_29 on tb2 using btree(c_inet inet_ops) ;
select relname from pg_class where relname like 'idx_%' order by relname;


--建表：列存临时表
DROP TABLE if EXISTS tb2 CASCADE;
create temporary table tb2(
c_int int,
c_float float4,
c_smalldatetime smalldatetime,
c_cidr cidr,
c_time time,
c_text text,
c_clob clob,
c_timestamp timestamp,
c_numeric numeric,
c_varchar varchar,
c_bytea bytea,
c_bool bool,
c_money money,
c_date date,
c_inet inet
) with (orientation = column);

--建索引指定操作符簇
create index idx_01 on tb2 using psort(c_int int4_ops) ;
create index idx_02 on tb2 using psort(c_float float4_ops) ;
create index idx_03 on tb2 using psort(c_smalldatetime smalldatetime_ops) ;
create index idx_04 on tb2 using psort(c_cidr cidr_ops) ;
create index idx_05 on tb2 using psort(c_time time_ops) ;
create index idx_06 on tb2 using psort(c_text text_ops) ;
create index idx_07 on tb2 using psort(c_timestamp timestamp_ops) ;
create index idx_08 on tb2 using psort(c_numeric numeric_ops) ;
create index idx_09 on tb2 using psort(c_varchar varchar_ops) ;
create index idx_10 on tb2 using psort(c_bytea bytea_ops) ;
create index idx_11 on tb2 using psort(c_bool bool_ops) ;
create index idx_12 on tb2 using psort(c_money money_ops) ;
create index idx_14 on tb2 using psort(c_inet inet_ops) ;
select relname from pg_class where relname like 'idx_%' order by relname;

--建索引指定操作符簇
create index idx_16 on tb2 using btree(c_int int4_ops) ;
create index idx_17 on tb2 using btree(c_float float4_ops) ;
create index idx_18 on tb2 using btree(c_smalldatetime smalldatetime_ops) ;
create index idx_19 on tb2 using btree(c_cidr cidr_ops) ;
create index idx_20 on tb2 using btree(c_time time_ops) ;
create index idx_21 on tb2 using btree(c_text text_ops) ;
create index idx_22 on tb2 using btree(c_timestamp timestamp_ops) ;
create index idx_23 on tb2 using btree(c_numeric numeric_ops) ;
create index idx_24 on tb2 using btree(c_varchar varchar_ops) ;
create index idx_25 on tb2 using btree(c_bytea bytea_ops) ;
create index idx_26 on tb2 using btree(c_bool bool_ops) ;
create index idx_27 on tb2 using btree(c_money money_ops) ;
create index idx_29 on tb2 using btree(c_inet inet_ops) ;
select relname from pg_class where relname like 'idx_%' order by relname;


--建表：列存分区表
DROP TABLE if EXISTS tb2 CASCADE;
create table tb2(
c_int int,
c_float float4,
c_smalldatetime smalldatetime,
c_cidr cidr,
c_time time,
c_text text,
c_clob clob,
c_timestamp timestamp,
c_numeric numeric,
c_varchar varchar,
c_bytea bytea,
c_bool bool,
c_money money,
c_date date,
c_inet inet
) WITH (ORIENTATION = column) partition by range(c_int)(
partition p1 values less than (100),
partition p2 values less than (1000),
partition p3 values less than (5000),
partition p4 values less than (10001)
);

--建索引指定操作符簇
create index idx_01 on tb2 using psort(c_int int4_ops) local;
create index idx_02 on tb2 using psort(c_float float4_ops) local;
create index idx_03 on tb2 using psort(c_smalldatetime smalldatetime_ops) local;
create index idx_04 on tb2 using psort(c_cidr cidr_ops) local;
create index idx_05 on tb2 using psort(c_time time_ops) local;
create index idx_06 on tb2 using psort(c_text text_ops) local;
create index idx_07 on tb2 using psort(c_timestamp timestamp_ops) local;
create index idx_08 on tb2 using psort(c_numeric numeric_ops) local;
create index idx_09 on tb2 using psort(c_varchar varchar_ops) local;
create index idx_10 on tb2 using psort(c_bytea bytea_ops) local;
create index idx_11 on tb2 using psort(c_bool bool_ops) local;
create index idx_12 on tb2 using psort(c_money money_ops) local;
create index idx_14 on tb2 using psort(c_inet inet_ops) local;
select relname from pg_class where relname like 'idx_%' order by relname;

--建索引指定操作符簇
create index idx_16 on tb2 using btree(c_int int4_ops) local;
create index idx_17 on tb2 using btree(c_float float4_ops) local;
create index idx_18 on tb2 using btree(c_smalldatetime smalldatetime_ops) local;
create index idx_19 on tb2 using btree(c_cidr cidr_ops) local;
create index idx_20 on tb2 using btree(c_time time_ops) local;
create index idx_21 on tb2 using btree(c_text text_ops) local;
create index idx_22 on tb2 using btree(c_timestamp timestamp_ops) local;
create index idx_23 on tb2 using btree(c_numeric numeric_ops) local;
create index idx_24 on tb2 using btree(c_varchar varchar_ops) local;
create index idx_25 on tb2 using btree(c_bytea bytea_ops) local;
create index idx_26 on tb2 using btree(c_bool bool_ops) local;
create index idx_27 on tb2 using btree(c_money money_ops) local;
create index idx_29 on tb2 using btree(c_inet inet_ops) local;
select relname from pg_class where relname like 'idx_%' order by relname;

--清理环境
DROP TABLE if EXISTS tb2 CASCADE;