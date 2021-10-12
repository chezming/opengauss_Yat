-- @testpoint: covar_samp函数入参传入函数返回值
drop table if exists T_VAR_POP_SAMP_VARIANCE01;
CREATE TABLE  T_VAR_POP_SAMP_VARIANCE01(
     COL_1 integer,
     COL_2 number(19,0), 
     COL_3 number(10,6));
insert into T_VAR_POP_SAMP_VARIANCE01 values(7,312.245,7+445.255);
insert into T_VAR_POP_SAMP_VARIANCE01 values(5,112.245,7+443.255);
select covar_samp(abs(COL_1)+ceil(COL_3)*floor(COL_2),abs(COL_1)+ceil(COL_3)*floor(COL_2)) from T_VAR_POP_SAMP_VARIANCE01 order by 1;
select covar_samp(cos(COL_1)*exp(COL_3/100)/ln(COL_2),cos(COL_1)*exp(COL_3/100)/ln(COL_3)) from T_VAR_POP_SAMP_VARIANCE01 order by 1;
select covar_samp(sign(COL_1-COL_2)-sin(COL_3)/floor(COL_3),sign(COL_1-COL_2)-sin(COL_3)/floor(COL_2)) from T_VAR_POP_SAMP_VARIANCE01 order by 1;
select covar_samp(tan(COL_1)+ceil(COL_3)*sqrt(COL_2),tan(COL_1)+ceil(COL_3)*sqrt(COL_2)) from T_VAR_POP_SAMP_VARIANCE01 order by 1;
drop table if exists T_VAR_POP_SAMP_VARIANCE01;

