-- @testpoint: mod函数与group by联合使用
drop table if exists fvt_obj_define_table_mod;
create table fvt_obj_define_table_mod(COL_1 bigint,COL_2 bool,modn integer);
insert into fvt_obj_define_table_mod values(100600,true,mod(356,5));
update FVT_OBJ_DEFINE_table_mod set COL_2 =false where COL_1>100500;
select sum(mod(modn,6598))from FVT_OBJ_DEFINE_table_mod group by COL_2 ORDER BY 1;
drop table if exists fvt_obj_define_table_mod;