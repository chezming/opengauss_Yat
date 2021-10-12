-- @testpoint: 创建表，创建相同索引名，合理报错

drop table if exists table_ind_confs_003;
create table table_ind_confs_003(
c_id int, c_integer integer,
c_real real,c_float float, c_double int,
c_decimal decimal(38), c_number number(38),c_number1 number,c_number2 number(20,10),c_numeric numeric(38),
c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
c_clob clob,
c_raw raw(20),c_blob blob,
c_timestamp timestamp
);
create index index_ind_confs_003  on table_ind_confs_003 (c_id,c_varchar);
create index index_ind_confs_003  on table_ind_confs_003 (c_number1);
drop table if exists table_ind_confs_003;