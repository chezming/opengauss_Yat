-- @testpoint: 入参为字符类型的列，分组求数据集的标准差，合理报错

drop table if exists t_nvl_rca_tab;
create table t_nvl_rca_tab( COL_1 bigint,COL_2 TIMESTAMP WITHOUT TIME ZONE,COL_3 boolean,COL_4 decimal,COL_5 text,COL_6 smallint,COL_7 char(30),COL_8 double precision,COL_9 text,COL_10 character varying(30),COL_11 boolean,COL_12 bytea ,COL_13 real ,COL_14 numeric ,COL_15 blob ,COL_16 integer ,COL_17 int,COL_18 TIMESTAMP WITH TIME ZONE ,COL_19 binary_integer ,COL_20 interval day to second ,COL_21 boolean,COL_22 nchar(30),COL_24 nchar(100),COL_25 character(1000),COL_26 text,COL_27 float,COL_28 double precision,COL_29 bigint,COL_33 interval year to month,COL_34 character(30),COL_35 smallint,COL_36 blob,COL_37 char(300),COL_38 float,COL_39 raw(100),COL_40 clob,
COL_41 binary_double,COL_42 number(6,2),COL_43 decimal(6,2),COL_44 varchar2(50),COL_45 varchar(30),COL_46 nvarchar2(100),COL_47 numeric(12,6),COL_49 date,COL_51 integer,COL_52 binary_double,COL_53 decimal(12,6),COL_54 raw(8000),COL_55 clob,COL_56 varchar2(8000),
COL_58 number(12,6),COL_59 nvarchar2(4000),COL_64 varchar(1000),COL_65 date);



select distinct STDDEV_POP(COL_10) from t_nvl_rca_tab;
select distinct STDDEV_POP(COL_7) from t_nvl_rca_tab;
select distinct STDDEV_POP(COL_22) from t_nvl_rca_tab;

drop table t_nvl_rca_tab;
