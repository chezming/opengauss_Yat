-- @testpoint: 二级分区表长稳测试,部分测试点合理报错

--test1: 创建表并执行不同的sql语句; expect:部分测试点合理报错
drop table if exists t_subpartition_0351;
create table t_subpartition_0351
(
    col_1 varchar2 ( 30 ) ,
    col_2 varchar2 ( 30 )  not null ,
    col_3 varchar2 ( 30 ) not null ,
    col_4     varchar2 ( 30 ),
col_5 varchar2 ( 30 ),
col_6 varchar2 ( 30 ),
col_7 varchar2 ( 30 ),
col_8 varchar2 ( 30 ),
col_9 varchar2 ( 30 ),
col_10 varchar2 ( 30 ),
col_11 varchar2 ( 30 ),
col_12 varchar2 ( 30 ),
col_13 varchar2 ( 30 ),
col_14 varchar2 ( 30 ),
col_15 varchar2 ( 30 ),
col_16 varchar2 ( 30 ),
col_17 varchar2 ( 30 ),
col_18 varchar2 ( 30 ),
col_19 varchar2 ( 30 ),
col_20 varchar2 ( 30 ),
col_21 varchar2 ( 30 ),
col_22 varchar2 ( 30 ),
col_23 varchar2 ( 30 ),
col_24 varchar2 ( 30 ),
col_25 varchar2 ( 30 ),
col_26 varchar2 ( 30 ),
col_27 varchar2 ( 30 ),
col_28 varchar2 ( 30 ),
col_29 varchar2 ( 30 ),
col_30 varchar2 ( 30 ),
col_31 varchar2 ( 30 ),
col_32 varchar2 ( 30 ),
col_33 varchar2 ( 30 ),
col_34 varchar2 ( 30 ),
col_35 varchar2 ( 30 ),
col_36 varchar2 ( 30 ),
col_37 varchar2 ( 30 ),
col_38 varchar2 ( 30 ),
col_39 varchar2 ( 30 ),
col_40 varchar2 ( 30 ),
col_41 varchar2 ( 30 ),
col_42 varchar2 ( 30 ),
col_43 varchar2 ( 30 ),
col_44 varchar2 ( 30 ),
col_45 varchar2 ( 30 ),
col_46 varchar2 ( 30 ),
col_47 varchar2 ( 30 ),
col_48 varchar2 ( 30 ),
col_49 varchar2 ( 30 ),
col_50 varchar2 ( 30 ),
col_51 varchar2 ( 30 ),
col_52 varchar2 ( 30 ),
col_53 varchar2 ( 30 ),
col_54 varchar2 ( 30 ),
col_55 varchar2 ( 30 ),
col_56 varchar2 ( 30 ),
col_57 varchar2 ( 30 ),
col_58 varchar2 ( 30 ),
col_59 varchar2 ( 30 ),
col_60 varchar2 ( 30 ),
col_61 varchar2 ( 30 ),
col_62 varchar2 ( 30 ),
col_63 varchar2 ( 30 ),
col_64 varchar2 ( 30 ),
col_65 varchar2 ( 30 ),
col_66 varchar2 ( 30 ),
col_67 varchar2 ( 30 ),
col_68 varchar2 ( 30 ),
col_69 varchar2 ( 30 ),
col_70 varchar2 ( 30 ),
col_71 varchar2 ( 30 ),
col_72 varchar2 ( 30 ),
col_73 varchar2 ( 30 ),
col_74 varchar2 ( 30 ),
col_75 varchar2 ( 30 ),
col_76 varchar2 ( 30 ),
col_77 varchar2 ( 30 ),
col_78 varchar2 ( 30 ),
col_79 varchar2 ( 30 ),
col_80 varchar2 ( 30 ),
col_81 varchar2 ( 30 ),
col_82 varchar2 ( 30 ),
col_83 varchar2 ( 30 )
)
partition by range (col_1) subpartition by list (col_2)
(
  partition p_range_1 values less than( '-10' )
  (
subpartition p_list_1_1 values ( '-1' ),
subpartition p_list_1_2 values ( '-2' ),
subpartition p_list_1_3 values ( '-3' ),
subpartition p_list_1_4 values ( '-4' ),
subpartition p_list_1_5 values ( '-5' ),
subpartition p_list_1_6 values ( '-6' ),
subpartition p_list_1_7 values ( '-7' ),
subpartition p_list_1_8 values ( '-8' ),
subpartition p_list_1_9 values ( '-9' ),
subpartition p_list_1_10 values ( '-10' ),
subpartition p_list_1_11 values ( '-11' ),
subpartition p_list_1_12 values ( '-12' ),
subpartition p_list_1_13 values ( '-13' ),
subpartition p_list_1_14 values ( '-14' ),
subpartition p_list_1_15 values ( '-15' ),
subpartition p_list_1_16 values ( '-16' ),
subpartition p_list_1_17 values ( '-17' ),
subpartition p_list_1_18 values ( '-18' ),
subpartition p_list_1_19 values ( '-19' ),
subpartition p_list_1_20 values ( '-20' ),
subpartition p_list_1_21 values ( '-21' ),
subpartition p_list_1_22 values ( '-22' ),
subpartition p_list_1_23 values ( '-23' ),
subpartition p_list_1_24 values ( '-24' ),
subpartition p_list_1_25 values ( '-25' ),
subpartition p_list_1_26 values ( '-26' ),
subpartition p_list_1_27 values ( '-27' ),
subpartition p_list_1_28 values ( '-28' ),
subpartition p_list_1_29 values ( '-29' ),
subpartition p_list_1_30 values ( '-30' ),
subpartition p_list_1_31 values ( '-31' ),
subpartition p_list_1_32 values ( '-32' ),
subpartition p_list_1_33 values ( '-33' ),
subpartition p_list_1_34 values ( '-34' ),
subpartition p_list_1_35 values ( '-35' ),
subpartition p_list_1_36 values ( '-36' ),
subpartition p_list_1_37 values ( '-37' ),
subpartition p_list_1_38 values ( '-38' ),
subpartition p_list_1_39 values ( '-39' ),
subpartition p_list_1_40 values ( '-40' ),
subpartition p_list_1_41 values ( '-41' ),
subpartition p_list_1_42 values ( '-42' ),
subpartition p_list_1_43 values ( '-43' ),
subpartition p_list_1_44 values ( '-44' ),
subpartition p_list_1_45 values ( '-45' ),
subpartition p_list_1_46 values ( '-46' ),
subpartition p_list_1_47 values ( '-47' ),
subpartition p_list_1_48 values ( '-48' ),
subpartition p_list_1_49 values ( '-49' ),
subpartition p_list_1_50 values ( '-50' ),
subpartition p_list_1_51 values ( default )
  ),
    partition p_range_2 values less than('10 ')
  (
subpartition p_list_2_1 values (  '1' ),
subpartition p_list_2_2 values (  '2' ),
subpartition p_list_2_3 values (  '3' ),
subpartition p_list_2_4 values (  '4' ),
subpartition p_list_2_5 values (  '5' ),
subpartition p_list_2__6 values (  '-6' ),
subpartition p_list_2_6 values (  '6' ),
subpartition p_list_2_7 values (  '7' ),
subpartition p_list_2_8 values (  '8' ),
subpartition p_list_2_9 values (  '9' ),
subpartition p_list_2_10 values (  '10' ),
subpartition p_list_2_11 values (  '11' ),
subpartition p_list_2_12 values (  '12' ),
subpartition p_list_2_13 values (  '13' ),
subpartition p_list_2_14 values (  '14' ),
subpartition p_list_2_15 values (  '15' ),
subpartition p_list_2_16 values (  '16' ),
subpartition p_list_2_17 values (  '17' ),
subpartition p_list_2_18 values (  '18' ),
subpartition p_list_2_19 values (  '19' ),
subpartition p_list_2_20 values (  '20' ),
subpartition p_list_2_21 values (  '21' ),
subpartition p_list_2_22 values (  '22' ),
subpartition p_list_2_23 values (  '23' ),
subpartition p_list_2_24 values (  '24' ),
subpartition p_list_2_25 values (  '25' ),
subpartition p_list_2_26 values (  '26' ),
subpartition p_list_2_27 values (  '27' ),
subpartition p_list_2_28 values (  '28' ),
subpartition p_list_2_29 values (  '29' ),
subpartition p_list_2_30 values (  '30' ),
subpartition p_list_2_31 values (  '31' ),
subpartition p_list_2_32 values (  '32' ),
subpartition p_list_2_33 values (  '33' ),
subpartition p_list_2_34 values (  '34' ),
subpartition p_list_2_35 values (  '35' ),
subpartition p_list_2_36 values (  '36' ),
subpartition p_list_2_37 values (  '37' ),
subpartition p_list_2_38 values (  '38' ),
subpartition p_list_2_39 values (  '39' ),
subpartition p_list_2_40 values (  '40' ),
subpartition p_list_2_41 values (  '41' ),
subpartition p_list_2_42 values (  '42' ),
subpartition p_list_2_43 values (  '43' ),
subpartition p_list_2_44 values (  '44' ),
subpartition p_list_2_45 values (  '45' ),
subpartition p_list_2_46 values (  '46' ),
subpartition p_list_2_47 values (  '47' ),
subpartition p_list_2_48 values (  '48' ),
subpartition p_list_2_49 values (  '49' ),
subpartition p_list_2_50 values (  '50' ),
subpartition p_list_2_51 values ( default )
  ),
    partition p_range_3 values less than( '20 '),

   partition p_range_4 values less than( '30' )
   (
    subpartition p_list_4_1 values ( default )
  ),
   partition p_range_5 values less than( '40' )
   (
   subpartition p_list_5_1 values (  '41' ),
subpartition p_list_5_2 values (  '42' ),
subpartition p_list_5_3 values (  '43' ),
subpartition p_list_5_4 values (  '44' ),
subpartition p_list_5_5 values (  '45' ),
subpartition p_list_5_6 values (  '46' ),
subpartition p_list_5_7 values (  '47' ),
subpartition p_list_5_8 values (  '48' ),
subpartition p_list_5_9 values (  '49' ),
subpartition p_list_5_10 values (  '50' ),
subpartition p_list_5_11 values (  '51' ),
subpartition p_list_5_12 values (  '52' ),
subpartition p_list_5_13 values (  '53' ),
subpartition p_list_5_14 values (  '54' ),
subpartition p_list_5_15 values (  '55' ),
subpartition p_list_5_16 values (  '56' ),
subpartition p_list_5_17 values (  '57' ),
subpartition p_list_5_18 values (  '58' ),
subpartition p_list_5_19 values (  '59' ),
subpartition p_list_5_20 values (  '60' ),
subpartition p_list_5_21 values (  '61' ),
subpartition p_list_5_22 values (  '62' ),
subpartition p_list_5_23 values (  '63' ),
subpartition p_list_5_24 values (  '64' ),
subpartition p_list_5_25 values (  '65' ),
subpartition p_list_5_26 values (  '66' ),
subpartition p_list_5_27 values (  '67' ),
subpartition p_list_5_28 values (  '68' ),
subpartition p_list_5_29 values (  '69' ),
subpartition p_list_5_30 values (  '70' ),
subpartition p_list_5_31 values (  '71' ),
subpartition p_list_5_32 values (  '72' ),
subpartition p_list_5_33 values (  '73' ),
subpartition p_list_5_34 values (  '74' ),
subpartition p_list_5_35 values (  '75' ),
subpartition p_list_5_36 values (  '76' ),
subpartition p_list_5_37 values (  '77' ),
subpartition p_list_5_38 values (  '78' ),
subpartition p_list_5_39 values (  '79' ),
subpartition p_list_5_40 values (  '80' ),
subpartition p_list_5_41 values (  '81' ),
subpartition p_list_5_42 values (  '82' ),
subpartition p_list_5_43 values (  '83' ),
subpartition p_list_5_44 values (  '84' ),
subpartition p_list_5_45 values (  '85' ),
subpartition p_list_5_46 values (  '86' ),
subpartition p_list_5_47 values (  '87' ),
subpartition p_list_5_48 values (  '88' ),
subpartition p_list_5_49 values (  '89' ),
subpartition p_list_5_50 values (  '90' ),
subpartition p_list_5_51 values (  '91' ),
subpartition p_list_5_52 values (  '92' ),
subpartition p_list_5_53 values (  '93' ),
subpartition p_list_5_54 values (  '94' ),
subpartition p_list_5_55 values (  '95' ),
subpartition p_list_5_56 values (  '96' ),
subpartition p_list_5_57 values (  '97' ),
subpartition p_list_5_58 values (  '98' ),
subpartition p_list_5_59 values (  '99' ),
subpartition p_list_5_60 values (  '100' ),
subpartition p_list_5_61 values (  '101' ),
subpartition p_list_5_62 values (  '102' ),
subpartition p_list_5_63 values (  '103' ),
subpartition p_list_5_64 values (  '104' ),
subpartition p_list_5_65 values (  '105' ),
subpartition p_list_5_66 values (  '106' ),
subpartition p_list_5_67 values (  '107' ),
subpartition p_list_5_68 values (  '108' ),
subpartition p_list_5_69 values (  '109' ),
subpartition p_list_5_70 values (  '110' ),
subpartition p_list_5_71 values (  '111' ),
subpartition p_list_5_72 values (  '112' ),
subpartition p_list_5_73 values (  '113' ),
subpartition p_list_5_74 values (  '114' ),
subpartition p_list_5_75 values (  '115' ),
subpartition p_list_5_76 values (  '116' ),
subpartition p_list_5_77 values (  '117' ),
subpartition p_list_5_78 values (  '118' ),
subpartition p_list_5_79 values (  '119' ),
subpartition p_list_5_80 values ( default )
  ),
   partition p_range_6 values less than( maxvalue )
) enable row movement;

--索引
create index on t_subpartition_0351(col_1,col_2);
create index on t_subpartition_0351(col_1);
create index on t_subpartition_0351(col_2);

--ddl：
alter table t_subpartition_0351 split subpartition p_list_1_51  values(100) into (subpartition add_p_01,subpartition add_p_02);
alter table t_subpartition_0351 split subpartition p_list_2_51  values(100,110,120) into (subpartition add_p_03,subpartition add_p_04);


--dml:
insert into t_subpartition_0351 values (generate_series(0, 19),generate_series(0, 1000),generate_series(0, 99));
insert into t_subpartition_0351 values(1,1,1),(4,4,4),(5,5,5),(8,8,8),(9,9,9);
insert into t_subpartition_0351(col_1,col_2,col_3)  values(31,1,1),(34,4,4),(45,5,5),(68,8,8),(70,9,9);
insert into t_subpartition_0351 values(0,0,0,0);
insert into t_subpartition_0351 values(0,0,0,0);
insert into t_subpartition_0351 values(0,0,0,0);
update t_subpartition_0351 set col_2=8 where col_2=0;
update t_subpartition_0351 set col_1=8 where col_2=8;
delete t_subpartition_0351 where col_2=8;
insert into t_subpartition_0351 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
insert into t_subpartition_0351 values(11,11,1,1),(15,15,5,5),(18,81,8,8),(29,9,9,9);
insert into t_subpartition_0351 values(21,11,1,1),(15,15,5,5),(18,81,8,8),(-29,31,9,9);
insert into t_subpartition_0351 values(-1,1,1,1),(-1,-15,5,5),(-8,7,8,8),(-9,29,9,9);
insert into t_subpartition_0351 values(-8,18,1);
insert into t_subpartition_0351 values(8,38,1);
update t_subpartition_0351 set col_2=36 where col_1=8;
update t_subpartition_0351 set col_4=col_1 where col_1<5;
update t_subpartition_0351 set col_4=80 where col_1=5;
update t_subpartition_0351 set col_1=80,col_2=8 where col_1=5;
truncate t_subpartition_0351;
insert into  t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99));
delete from  t_subpartition_0351 where col_1 >18 ;
delete from  t_subpartition_0351 where col_2 <10 and col_3>5;
delete from  t_subpartition_0351 where col_2 <50 and col_3>5;
insert into  t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99));
delete  t_subpartition_0351 where col_2-100>10;
delete  t_subpartition_0351 where col_2-100>10;
delete  t_subpartition_0351 where col_2/5>1;
alter table t_subpartition_0351 truncate subpartition p_list_5_15;
insert into t_subpartition_0351 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
insert into t_subpartition_0351 values(11,11,1,1),(15,15,5,5),(18,81,8,8),(29,9,9,9);
insert into t_subpartition_0351 values(21,11,1,1),(15,15,5,5),(18,81,8,8),(-29,31,9,9);
insert into t_subpartition_0351 values(-1,1,1,1),(-1,-15,5,5),(-8,7,8,8),(-9,29,9,9);
insert into t_subpartition_0351 values(-8,18,1);
insert into t_subpartition_0351 values(8,38,1);
update t_subpartition_0351 set col_2=36 where col_1=8;
update t_subpartition_0351 set col_4=col_1 where col_1<5;
update t_subpartition_0351 set col_4=80 where col_1=5;
update t_subpartition_0351 set col_1=80,col_2=8 where col_1=5;
alter table t_subpartition_0351 truncate subpartition p_list_2_19;
insert into  t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99));
truncate t_subpartition_0351;
insert into  t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99));
truncate t_subpartition_0351 cascade;
insert into t_subpartition_0351 values(11,11,1,1),(15,15,5,5),(18,81,8,8),(29,9,9,9);
insert into t_subpartition_0351 values(21,11,1,1),(15,15,5,5),(18,81,8,8),(-29,31,9,9);
insert into t_subpartition_0351 values(-1,1,1,1),(-1,-15,5,5),(-8,7,8,8),(-9,29,9,9);
insert into t_subpartition_0351 values(-8,18,1);
insert into t_subpartition_0351 values(8,38,1);
alter table t_subpartition_0351 truncate partition p_range_1;
insert into  t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99));
alter table t_subpartition_0351 truncate partition p_range_3;

--test2: 创建表并执行不同的sql语句; expect:部分测试点合理报错
drop table if exists t_subpartition_0351;
create table t_subpartition_0351
(
    col_1 int  primary key,
    col_2 int  not null ,
    col_3 varchar2 ( 30 ) not null ,
    col_4 int  generated always as(2*col_2) stored ,
    check (col_4 >= col_2)
)
with(fillfactor=80)
partition by list (col_1) subpartition by range (col_2)
(
 partition p_list_1 values(-1,-2,-3,-4,-5,-6,-7,-8,-9,-10 )
  (
    subpartition p_range_1_1 values less than( -10 ),
    subpartition p_range_1_2 values less than( 0 ),
    subpartition p_range_1_3 values less than( 10 ),
    subpartition p_range_1_4 values less than( 20 ),
    subpartition p_range_1_5 values less than( 50 ),
    subpartition p_range_1_6 values less than( 60 ),
    subpartition p_range_1_7 values less than( 70 ),
    subpartition p_range_1_8 values less than( 80 ),
    subpartition p_range_1_9 values less than( 90 ),
    subpartition p_range_1_10 values less than( 100 ),
    subpartition p_range_1_11 values less than( maxvalue )
  ),
  partition p_list_2 values(1,2,3,4,5,6,7,8,9,10 ),
  partition p_list_3 values(11,12,13,14,15,16,17,18,19,20)
  (
    subpartition p_range_3_1 values less than( 15 ),
    subpartition p_range_3_2 values less than( maxvalue )
  ),
    partition p_list_4 values(21,22,23,24,25,26,27,28,29,30)
  (
    subpartition p_range_4_1 values less than( -10 ),
    subpartition p_range_4_2 values less than( 0 ),
    subpartition p_range_4_3 values less than( 10 ),
    subpartition p_range_4_4 values less than( 20 ),
    subpartition p_range_4_5 values less than( maxvalue )
  ),
   partition p_list_5 values(31,32,33,34,35,36,37,38,39,40)
  (
    subpartition p_range_5_1 values less than( maxvalue )
  ),
   partition p_list_6 values(41,42,43,44,45,46,47,48,49,50)
   (
    subpartition p_range_6_1 values less than( -10 ),
    subpartition p_range_6_2 values less than( maxvalue )
   ),
   partition p_list_7 values(default)
) enable row movement;

 --索引
create index on t_subpartition_0351(col_1,col_2);
create index on t_subpartition_0351(col_1);
create index on t_subpartition_0351(col_2);

--ddl：
alter table t_subpartition_0351 split subpartition p_range_4_5  at(100) into (subpartition add_p_01,subpartition add_p_02);
alter table t_subpartition_0351 split subpartition p_range_6_2  at(100,110,120) into (subpartition add_p_03,subpartition add_p_04);--失败

--dml:
insert into t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99));
insert into t_subpartition_0351 values(1,1,1),(4,4,4),(5,5,5),(8,8,8),(9,9,9);
insert into t_subpartition_0351(col_1,col_2,col_3)  values(31,1,1),(34,4,4),(45,5,5),(68,8,8),(70,9,9);
insert into t_subpartition_0351 values(0,0,0,0);--失败
insert into t_subpartition_0351 values(0,0,0,0);--失败
insert into t_subpartition_0351 values(0,0,0,0);--失败
update t_subpartition_0351 set col_2=8 where col_2=0;
update t_subpartition_0351 set col_1=8 where col_2=8;
delete t_subpartition_0351 where col_2=8;
insert into t_subpartition_0351 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
insert into t_subpartition_0351 values(11,11,1,1),(15,15,5,5),(18,81,8,8),(29,9,9,9);
insert into t_subpartition_0351 values(21,11,1,1),(15,15,5,5),(18,81,8,8),(-29,31,9,9);
insert into t_subpartition_0351 values(-1,1,1,1),(-1,-15,5,5),(-8,7,8,8),(-9,29,9,9); --失败
insert into t_subpartition_0351 values(-8,18,1);
insert into t_subpartition_0351 values(8,38,1);
update t_subpartition_0351 set col_2=36 where col_1=8;
update t_subpartition_0351 set col_4=col_1 where col_1<5; --失败
update t_subpartition_0351 set col_4=80 where col_1=5; --失败
update t_subpartition_0351 set col_1=80,col_2=8 where col_1=5;
truncate t_subpartition_0351;
insert into t_subpartition_0351 values(11,11,1,1),(15,15,5,5),(18,81,8,8),(29,9,9,9);
insert into t_subpartition_0351 values(21,11,1,1),(15,15,5,5),(18,81,8,8),(-29,31,9,9);
insert into t_subpartition_0351 values(-1,1,1,1),(-1,-15,5,5),(-8,7,8,8),(-9,29,9,9); --失败
insert into t_subpartition_0351 values(-8,18,1);
insert into t_subpartition_0351 values(8,38,1);
insert into  t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99));
delete from  t_subpartition_0351 where col_1 >18 ;
delete from  t_subpartition_0351 where col_2 <10 and col_3>5;
delete from  t_subpartition_0351 where col_2 <50 and col_3>5;
insert into  t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99));
delete  t_subpartition_0351 where col_2-100>10;
delete  t_subpartition_0351 where col_2-100>10;
delete  t_subpartition_0351 where col_2/5>1;
alter table t_subpartition_0351 truncate subpartition p_range_5_1;
insert into t_subpartition_0351 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
insert into t_subpartition_0351 values(11,11,1,1),(15,15,5,5),(18,81,8,8),(29,9,9,9);
insert into t_subpartition_0351 values(21,11,1,1),(15,15,5,5),(18,81,8,8),(-29,31,9,9);
insert into t_subpartition_0351 values(-1,1,1,1),(-1,-15,5,5),(-8,7,8,8),(-9,29,9,9); --失败
insert into t_subpartition_0351 values(-8,18,1);
insert into t_subpartition_0351 values(8,38,1);
update t_subpartition_0351 set col_2=36 where col_1=8;
update t_subpartition_0351 set col_4=col_1 where col_1<5; --失败
update t_subpartition_0351 set col_4=80 where col_1=5; --失败
update t_subpartition_0351 set col_1=80,col_2=8 where col_1=5;
alter table t_subpartition_0351 truncate subpartition p_list_2_subpartdefault1;
insert into  t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99));
truncate t_subpartition_0351;
insert into t_subpartition_0351 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
insert into t_subpartition_0351 values(11,11,1,1),(15,15,5,5),(18,81,8,8),(29,9,9,9);
insert into t_subpartition_0351 values(21,11,1,1),(15,15,5,5),(18,81,8,8),(-29,31,9,9);
insert into t_subpartition_0351 values(-1,1,1,1),(-1,-15,5,5),(-8,7,8,8),(-9,29,9,9); --失败
insert into t_subpartition_0351 values(-8,18,1);
insert into t_subpartition_0351 values(8,38,1);
truncate t_subpartition_0351 cascade;
insert into  t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99));
alter table t_subpartition_0351 truncate partition p_list_1;
alter table t_subpartition_0351 truncate partition p_list_3;

--test3: 创建表并执行不同的sql语句; expect:部分测试点合理报错
drop table if exists t_subpartition_0351;
create table t_subpartition_0351
(
    col_1 int  primary key,
    col_2 int  not null ,
    col_3 varchar2 ( 30 ) not null ,
    col_4 int  generated always as(2*col_2) stored ,
    check (col_4 >= col_2)
)
with(fillfactor=80)
partition by range (col_1) subpartition by hash (col_2)
(
  partition p_range_1 values less than( -10 )
  (
    subpartition p_hash_1_1 ,
    subpartition p_hash_1_2 ,
    subpartition p_hash_1_3,
    subpartition p_hash_1_4,
    subpartition p_hash_1_5,
    subpartition p_hash_1_6
  ),
  partition p_range_2 values less than( 20 ),
  partition p_range_3 values less than( 30)
  (
    subpartition p_hash_3_1 ,
    subpartition p_hash_3_2 ,
    subpartition p_hash_3_3
  ),
    partition p_range_4 values less than( 50)
  (
    subpartition p_hash_4_1
  ),
  partition p_range_5 values less than( maxvalue )
) enable row movement;

 --索引
create index on t_subpartition_0351(col_1,col_2);
create index on t_subpartition_0351(col_1);
create index on t_subpartition_0351(col_2);

--ddl：
alter table t_subpartition_0351 split subpartition p_hash_3_3  at(100) into (subpartition add_p_01,subpartition add_p_02);--失败
alter table t_subpartition_0351 split subpartition p_hash_1_6  at(100,110,120) into (subpartition add_p_03,subpartition add_p_04);--失败

--dml:
insert into t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99));--失败
insert into t_subpartition_0351 values(1,1,1),(4,4,4),(5,5,5),(8,8,8),(9,9,9);
insert into t_subpartition_0351(col_1,col_2,col_3)  values(31,1,1),(34,4,4),(45,5,5),(68,8,8),(70,9,9);
insert into t_subpartition_0351 values(0,0,0,0);--失败
insert into t_subpartition_0351 values(0,0,0,0);--失败
insert into t_subpartition_0351 values(0,0,0,0);--失败
update t_subpartition_0351 set col_2=8 where col_2=0;
update t_subpartition_0351 set col_1=8 where col_2=8;--失败
delete t_subpartition_0351 where col_2=8;
insert into t_subpartition_0351 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);--失败
insert into t_subpartition_0351 values(11,11,1,1),(15,15,5,5),(18,81,8,8),(29,9,9,9);
insert into t_subpartition_0351 values(21,11,1,1),(15,15,5,5),(18,81,8,8),(-29,31,9,9);--失败
insert into t_subpartition_0351 values(-1,1,1,1),(-1,-15,5,5),(-8,7,8,8),(-9,29,9,9);--失败
insert into t_subpartition_0351 values(-8,18,1);
insert into t_subpartition_0351 values(8,38,1);
update t_subpartition_0351 set col_2=36 where col_1=8;
update t_subpartition_0351 set col_4=col_1 where col_1<5; --失败
update t_subpartition_0351 set col_4=80 where col_1=5; --失败
update t_subpartition_0351 set col_1=80,col_2=8 where col_1=5;
truncate t_subpartition_0351;
insert into  t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99)); --失败
delete from  t_subpartition_0351 where col_1 >18 ;
delete from  t_subpartition_0351 where col_2 <10 and col_3>5;
delete from  t_subpartition_0351 where col_2 <50 and col_3>5;
insert into  t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99)); --失败
delete  t_subpartition_0351 where col_2-100>10;
delete  t_subpartition_0351 where col_2-100>10;
delete  t_subpartition_0351 where col_2/5>1;
alter table t_subpartition_0351 truncate subpartition p_hash_3_3;
insert into t_subpartition_0351 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
insert into t_subpartition_0351 values(11,11,1,1),(15,15,5,5),(18,81,8,8),(29,9,9,9);
insert into t_subpartition_0351 values(21,11,1,1),(15,15,5,5),(18,81,8,8),(-29,31,9,9);
insert into t_subpartition_0351 values(-1,1,1,1),(-1,-15,5,5),(-8,7,8,8),(-9,29,9,9); --失败
insert into t_subpartition_0351 values(-8,18,1);
insert into t_subpartition_0351 values(8,38,1);
update t_subpartition_0351 set col_2=36 where col_1=8;
update t_subpartition_0351 set col_4=col_1 where col_1<5; --失败
update t_subpartition_0351 set col_4=80 where col_1=5; --失败
update t_subpartition_0351 set col_1=80,col_2=8 where col_1=5;
alter table t_subpartition_0351 truncate subpartition p_range_2_subpartdefault1;
insert into  t_subpartition_0351 values (generate_series(-19, 19),generate_series(0, 1000),generate_series(0, 99)); --失败
truncate t_subpartition_0351;
truncate t_subpartition_0351 cascade;
insert into t_subpartition_0351 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
insert into t_subpartition_0351 values(11,11,1,1),(15,15,5,5),(18,81,8,8),(29,9,9,9);
insert into t_subpartition_0351 values(21,11,1,1),(15,15,5,5),(18,81,8,8),(-29,31,9,9);
insert into t_subpartition_0351 values(-1,1,1,1),(-1,-15,5,5),(-8,7,8,8),(-9,29,9,9);
insert into t_subpartition_0351 values(-8,18,1);
insert into t_subpartition_0351 values(8,38,1);
alter table t_subpartition_0351 truncate partition p_range_1;
alter table t_subpartition_0351 truncate partition p_range_3;

--step4: 清理环境; expect:成功
drop table if exists t_subpartition_0351;