-- @testpoint: range分区表join查询

--step1:建表造数据 t_partition_0070_01; expect:成功
drop table if exists t_partition_0070_01;
create table t_partition_0070_01 (
c_id int,
c_d_id numeric,
c_w_id int,
c_first varchar(16),
c_middle char(2),
c_last varchar(16),
c_street_1 text,
c_street_2 varchar(60),
c_city varchar(60),
c_state char(2),
c_zip char(9),
c_phone char(16),
c_since timestamp,
c_credit char(2),
c_credit_lim numeric(12,2),
c_discount numeric(4,4),
c_balance numeric(12,2),
c_ytd_payment numeric(12,2),
c_payment_cnt int,
c_delivery_cnt int,
c_data varchar(500));

drop index if exists t_partition_0070_01_1;
drop index if exists t_partition_0070_01_2;
drop index if exists t_partition_0070_01_3;
drop index if exists t_partition_0070_01_4;
drop index if exists t_partition_0070_01_6;
drop index if exists t_partition_0070_01_7;
drop index if exists t_partition_0070_01_8;
drop index if exists t_partition_0070_01_9;

create index t_partition_0070_01_1 on t_partition_0070_01(c_id);
create index t_partition_0070_01_2 on t_partition_0070_01(c_d_id);
create index t_partition_0070_01_3 on t_partition_0070_01(c_w_id);
create index t_partition_0070_01_4 on t_partition_0070_01(c_credit_lim);
create index t_partition_0070_01_6 on t_partition_0070_01(c_street_2);
create index t_partition_0070_01_7 on t_partition_0070_01(c_city);
create index t_partition_0070_01_8 on t_partition_0070_01(c_zip);
create index t_partition_0070_01_9 on t_partition_0070_01(c_since);

insert into t_partition_0070_01(c_id,c_w_id,c_street_1,c_city) values(generate_series(1,10),generate_series(1,10),'a_streetstreetstreet','a_citycitycitycitycity');
--step2:建表造数据 t_partition_0070_02; expect:成功
drop table if exists t_partition_0070_02;
create table t_partition_0070_02 (
c_int integer ,
c_smallint int ,
c_bigint bigint ,
c_decimal decimal ,
c_numeric numeric ,
c_real real ,
c_double double precision ,
c_money varchar(20) ,
c_character_varying character varying(1024) ,
c_varchar varchar(20) ,
c_char char(1024) ,
c_text text ,
c_bytea varchar(20) ,
c_timestamp_without  varchar(100) ,
c_timestamp_with varchar(100),
c_boolean boolean ,
c_oid varchar(50) ,
c_character varchar(50),
c_interval varchar(50) ,
c_date date ,
c_time_without varchar(100),
c_time_with varchar(100),
c_binary_integer binary_integer,
c_binary_double binary_double,
c_dec varchar(50),
c_numeric_1 numeric(3,2),
c_varchar2 varchar2(100));

insert into t_partition_0070_02(c_int,c_date) values(generate_series(1,10),'2021-01-01 00:00:00');

--step3:建表造数据 t_partition_0070_03; expect:成功
drop table if exists t_partition_0070_03;
create table t_partition_0070_03(
  wd_tinyint       tinyint,
  wd_smallint      smallint,
  wd_int        integer ,
  wd_bigint       bigint,
  wd_numeric       numeric,
  wd_real       real,
  wd_double       double precision,
  wd_decimal          decimal,
  wd_varchar        varchar(100),
  wd_char       char(30),
  wd_nvarchar2      nvarchar2(100),
  wd_text       varchar(2000),
  wd_timestamptz  varchar(100),
  wd_timestamp  varchar(100),
  wd_date       date,
  wd_time       varchar(100),
  wd_timetz   varchar(100),
  wd_interval      varchar(100),
  wd_smalldatetine varchar(100),
  wd_text1            varchar(2000),
  wd_int1             integer,
  wd_varchar1         varchar(100),
  wd_num           numeric,
  wd_num1       numeric,
  wd_char1            char(20),
  wd_char2            char(20),
  wd_date4       date,
  wd_date5       date
)
partition by range (wd_date4)
(
partition order_08_1 values less than ('2014-12-01'),
partition order_08_2 values less than ('2020-12-01'),
partition order_08_3 values less than ('2025-12-01'),
partition order_08_4 values less than ('2030-12-01'),
partition order_08_5 values less than ('2035-12-01'),
partition order_08_6 values less than ('2040-12-01'),
partition order_08_7 values less than ('2045-12-01'),
partition order_08_8 values less than ('2050-12-01'),
partition order_08_9 values less than ('2055-12-01'),
partition order_08_10 values less than (maxvalue)
);

insert into t_partition_0070_03(wd_int,wd_varchar,wd_date) values(generate_series(1,10),'aaaa','2021-01-01 00:00:00');

--step4: join查询; expect:成功
select t2.c_int,t2.c_date::varchar
from t_partition_0070_02 t2
where t2.c_int =5
intersect all select t1.c_w_id,t3.wd_date::varchar
from t_partition_0070_03 t3 inner join t_partition_0070_01 t1 on t3.wd_int = t1.c_id
where t1.c_city like 'a%' and length(t1.c_street_1) >=15
and t1.c_w_id = 5 and t3.wd_varchar like 'a%'
order by 1,2;

--step5: 清理环境; expect:成功
drop table if exists t_partition_0070_01;
drop table if exists t_partition_0070_02;
drop table if exists t_partition_0070_03;