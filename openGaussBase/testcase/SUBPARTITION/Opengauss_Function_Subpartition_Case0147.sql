-- @testpoint: list_hash二级分区表：分区名称为超长/重复,部分测试点合理报错

--step1: 创建表空间; expect:成功
drop table if exists t_subpartition_0147;
drop tablespace if exists ts_subpartition_0147;
create tablespace ts_subpartition_0147 relative location 'subpartition_tablespace/subpartition_tablespace_0147';
drop tablespace if exists ts_subpartition_0147_01;
create tablespace ts_subpartition_0147_01 relative location 'subpartition_tablespace/subpartition_tablespace_0147_01';
--test1: 分区名称-名称超长
--step2: 创建二级分区表,二级分区名称超长; expect:成功
create table if not exists t_subpartition_0147
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0147
partition by list (col_1) subpartition by hash (col_2)
(
  partition p_list_1 values (-1,-2,-3,-4,-5,-6,-7,-8,-9,-10 )
  (
    subpartition p_hash_1_1 ,
    subpartition p_hash_1_2 ,
    subpartition p_hash_1_3 
  ),
  partition p_list_2 values (1,2,3,4,5,6,7,8,9,10 )
  (
    subpartition p_hash_2_1 ,
    subpartition p_hash_2_2 ,
    subpartition p_hash_2_3 ,
    subpartition p_hash_2_4 ,
    subpartition p_hash_2_5 tablespace ts_subpartition_0147_01
  ),
  partition p_list_3 values (11,12,13,14,15,16,17,18,19,20),
  partition p_list_4 values (21,22,23,24,25,26,27,28,29,30 )
  (
    subpartition p_hash_2_5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555  tablespace ts_subpartition_0147_01
  ),
  partition p_list_5 values (default)
  (
    subpartition p_hash_5_1 
  ),
  partition p_list_6 values (31,32,33,34,35,36,37,38,39,40)
  (
    subpartition p_hash_6_1 ,
    subpartition p_hash_6_2 ,
    subpartition p_hash_6_3 tablespace ts_subpartition_0147_01
  )
) enable row movement ;
--step3: 查询分区信息; expect:成功
select relname, parttype, partstrategy, indisusable from pg_partition where parentid = (select oid from pg_class where relname = 't_subpartition_0147') order by relname;
select a.relname,a.parttype,a.partstrategy,a.indisusable from pg_partition a,(select oid from pg_partition
where parentid = (select oid from pg_class where relname = 't_subpartition_0147')) b where a.parentid = b.oid order by a.relname;
--step4: 插入数据; expect:成功
insert into t_subpartition_0147 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
insert into t_subpartition_0147 values(11,11,1,1),(15,15,5,5),(18,81,8,8),(29,9,9,9);
insert into t_subpartition_0147 values(21,11,1,1),(15,15,5,5),(18,81,8,8),(-29,31,9,9);
insert into t_subpartition_0147 values(-1,1,1,1),(-1,-15,5,5),(-8,7,8,8),(-9,29,9,9);
insert into t_subpartition_0147 values(8,38,1);
--step5: 查询一级分区数据; expect:成功
select * from t_subpartition_0147 partition(p_list_4);
--step6: 查询超长名称的二级分区数据; expect:成功
select * from t_subpartition_0147 subpartition(p_hash_2_5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555);
--step7: 更新指定数据; expect:成功
update t_subpartition_0147 set col_2=10 where col_2=11;
--step8: 查询超长名称的二级分区数据; expect:成功
select * from t_subpartition_0147 subpartition(p_hash_2_5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555);
--step9: 删除二级分区; expect:合理报错
alter table t_subpartition_0147 drop subpartition p_hash_2_5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555;

--test2: 分区名称-名称重复
--step10: 创建二级分区表,不同一级分区中的二级分区名称重复; expect:合理报错
drop table if exists t_subpartition_0147;
create table if not exists t_subpartition_0147
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0147
partition by list (col_1) subpartition by hash (col_2)
(
  partition p_list_1 values (-1,-2,-3,-4,-5,-6,-7,-8,-9,-10 )
  (
    subpartition p_hash_1_1 ,
    subpartition p_hash_1_2 ,
    subpartition p_hash_1_3 
  ),
  partition p_list_2 values (1,2,3,4,5,6,7,8,9,10 )
  (
    subpartition p_hash_2_1 ,
    subpartition p_hash_2_2 ,
    subpartition p_hash_2_3 ,
    subpartition p_hash_2_4 ,
    subpartition p_hash_1_2 
  ),
  partition p_list_3 values (11,12,13,14,15,16,17,18,19,20),
  partition p_list_4 values (21,22,23,24,25,26,27,28,29,30 )
  (
    subpartition p_hash_4_1 
  ),
  partition p_list_5 values (default)
  (
    subpartition p_hash_5_1 
  ),
  partition p_list_6 values (31,32,33,34,35,36,37,38,39,40)
  (
    subpartition p_hash_6_1 ,
    subpartition p_hash_6_2 ,
    subpartition p_hash_6_3 
  )
) enable row movement ;
--step11: 创建二级分区表,二级分区名称和一级分区名称重复; expect:合理报错
drop table if exists t_subpartition_0147;
create table if not exists t_subpartition_0147
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0147
partition by list (col_1) subpartition by hash (col_2)
(
  partition p_list_1 values (-1,-2,-3,-4,-5,-6,-7,-8,-9,-10 )
  (
    subpartition p_hash_1_1 ,
    subpartition p_hash_1_2 ,
    subpartition p_list_6 
  ),
  partition p_list_2 values (1,2,3,4,5,6,7,8,9,10 )
  (
    subpartition p_hash_2_1 ,
    subpartition p_hash_2_2 ,
    subpartition p_hash_2_3 ,
    subpartition p_hash_2_4 ,
    subpartition p_hash_2_5 
  ),
  partition p_list_3 values (11,12,13,14,15,16,17,18,19,20),
  partition p_list_4 values (21,22,23,24,25,26,27,28,29,30 )
  (
    subpartition p_hash_4_1 
  ),
  partition p_list_5 values (default)
  (
    subpartition p_hash_5_1 
  ),
  partition p_list_6 values (31,32,33,34,35,36,37,38,39,40)
  (
    subpartition p_hash_6_1 ,
    subpartition p_hash_6_2 ,
    subpartition p_hash_6_3 
  )
) enable row movement ;
--step12: 创建二级分区表,同一个一级分区内的二级分区名称重复; expect:合理报错
drop table if exists t_subpartition_0147;
create table if not exists t_subpartition_0147
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0147
partition by list (col_1) subpartition by hash (col_2)
(
  partition p_list_1 values (-1,-2,-3,-4,-5,-6,-7,-8,-9,-10 )
  (
    subpartition p_list_1 ,
    subpartition p_hash_1_1 ,
    subpartition p_hash_1_3 
  ),
  partition p_list_2 values (1,2,3,4,5,6,7,8,9,10 )
  (
    subpartition p_hash_2_1 ,
    subpartition p_hash_2_2 ,
    subpartition p_hash_2_3 ,
    subpartition p_hash_2_4 ,
    subpartition p_hash_2_5 
  ),
  partition p_list_3 values (11,12,13,14,15,16,17,18,19,20),
  partition p_list_4 values (21,22,23,24,25,26,27,28,29,30 )
  (
    subpartition p_hash_4_1 
  ),
  partition p_list_5 values (default)
  (
    subpartition p_hash_5_1 
  ),
  partition p_list_6 values (31,32,33,34,35,36,37,38,39,40)
  (
    subpartition p_hash_6_1 ,
    subpartition p_hash_6_2 ,
    subpartition p_hash_6_3 
  )
) enable row movement ;

--step13: 创建二级分区表,二级分区名和列名重复; expect:成功
drop table if exists t_subpartition_0147;
create table if not exists t_subpartition_0147
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0147
partition by list (col_1) subpartition by hash (col_2)
(
  partition p_list_1 values (-1,-2,-3,-4,-5,-6,-7,-8,-9,-10 )
  (
    subpartition p_hash_1_1 ,
    subpartition p_hash_1_2 ,
    subpartition p_hash_1_3 
  ),
  partition p_list_2 values (1,2,3,4,5,6,7,8,9,10 )
  (
    subpartition p_hash_2_1 ,
    subpartition p_hash_2_2 ,
    subpartition p_hash_2_3 ,
    subpartition p_hash_2_4 tablespace ts_subpartition_0147_01,
    subpartition p_hash_2_5 
  ),
  partition p_list_3 values (11,12,13,14,15,16,17,18,19,20),
  partition p_list_4 values (21,22,23,24,25,26,27,28,29,30 )
  (
    subpartition col_2 
  ),
  partition p_list_5 values (default)
  (
    subpartition p_hash_5_1 
  ),
  partition p_list_6 values (31,32,33,34,35,36,37,38,39,40)
  (
    subpartition p_hash_6_1 ,
    subpartition p_hash_6_2 ,
    subpartition p_hash_6_3  tablespace ts_subpartition_0147_01
  )
) enable row movement ;
--step14: 插入数据; expect:成功
insert into t_subpartition_0147 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
insert into t_subpartition_0147 values(11,11,1,1),(15,15,5,5),(18,81,8,8),(29,9,9,9);
insert into t_subpartition_0147 values(21,11,1,1),(15,15,5,5),(18,81,8,8),(-29,31,9,9);
insert into t_subpartition_0147 values(-1,1,1,1),(-1,-15,5,5),(-8,7,8,8),(9,29,9,9);
insert into t_subpartition_0147 values(-8,18,1);
--step15: 查询与列名重复的二级分区数据; expect:成功
select * from  t_subpartition_0147 subpartition (col_2);

--step16: 创建二级分区表,二级分区名为opengauss; expect:成功
drop table if exists t_subpartition_0147;
create table if not exists t_subpartition_0147
(
    col_1 int ,
    col_2 int ,
    col_3 int ,
    col_4 int 
)
tablespace ts_subpartition_0147
partition by list (col_1) subpartition by hash (col_2)
(
  partition p_list_1 values (-1,-2,-3,-4,-5,-6,-7,-8,-9,-10 )
  (
    subpartition p_hash_1_1 ,
    subpartition p_hash_1_2 ,
    subpartition p_hash_1_3 
  ),
  partition p_list_2 values (1,2,3,4,5,6,7,8,9,10 )
  (
    subpartition p_hash_2_1 ,
    subpartition p_hash_2_2 ,
    subpartition p_hash_2_3 ,
    subpartition p_hash_2_4 tablespace ts_subpartition_0147,
    subpartition p_hash_2_5 
  ),
  partition p_list_3 values (11,12,13,14,15,16,17,18,19,20),
  partition p_list_4 values (21,22,23,24,25,26,27,28,29,30 )
  (
    subpartition opengauss 
  ),
  partition p_list_5 values (default)
  (
    subpartition p_hash_5_1 
  ),
  partition p_list_6 values (31,32,33,34,35,36,37,38,39,40)
  (
    subpartition p_hash_6_1 ,
    subpartition p_hash_6_2 ,
    subpartition p_hash_6_3 tablespace ts_subpartition_0147_01
  )
) enable row movement ;
--step17: 查询数据; expect:成功
select relname, parttype, partstrategy, indisusable from pg_partition where parentid = (select oid from pg_class where relname = 't_subpartition_0147') order by relname;
select a.relname,a.parttype,a.partstrategy,a.indisusable from pg_partition a,(select oid from pg_partition
where parentid = (select oid from pg_class where relname = 't_subpartition_0147')) b where a.parentid = b.oid order by a.relname;
--step18: 插入数据; expect:成功
insert into t_subpartition_0147 values(1,1,1,1),(5,5,5,5),(8,8,8,8),(9,9,9,9);
insert into t_subpartition_0147 values(11,11,1,1),(15,15,5,5),(18,81,8,8),(29,9,9,9);
insert into t_subpartition_0147 values(21,11,1,1),(15,15,5,5),(18,81,8,8),(-29,31,9,9);
insert into t_subpartition_0147 values(-1,-1,1,1),(-1,-15,5,5),(-8,7,8,8),(-9,29,9,9);
insert into t_subpartition_0147 values(-8,18,1);
--step19: 查询二级分区名为opengauss数据; expect:成功
select * from t_subpartition_0147 subpartition(opengauss);
--step20: 使用错误的关键字查询表数据; expect:成功,实际查询所有的数据
select * from t_subpartition_0147 subpartitn(opengauss);

--step21: 清理环境; expect:成功
drop table if exists t_subpartition_0147;
drop tablespace if exists ts_subpartition_0147;
drop tablespace if exists ts_subpartition_0147_01;