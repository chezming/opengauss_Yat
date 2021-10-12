-- @testpoint: covar_samp函数合法值的输入
drop table if exists T_VAR_POP_SAMP_VARIANCE01;
CREATE TABLE  T_VAR_POP_SAMP_VARIANCE01(
     COL_1 integer,
     COL_2 number(19,0), 
     COL_3 number(10,6));
insert into T_VAR_POP_SAMP_VARIANCE01 values(7,312.245,7+445.255);
insert into T_VAR_POP_SAMP_VARIANCE01 values(5,112.245,7+443.255);

select covar_samp(COL_2,COL_2) from T_VAR_POP_SAMP_VARIANCE01 order by 1;
select covar_samp(COL_3,COL_3) from T_VAR_POP_SAMP_VARIANCE01 order by 1;
select covar_samp(COL_2,COL_3) from T_VAR_POP_SAMP_VARIANCE01 order by 1;
select covar_samp(COL_3,COL_2) from T_VAR_POP_SAMP_VARIANCE01 order by 1;
drop table if exists T_VAR_POP_SAMP_VARIANCE01;
