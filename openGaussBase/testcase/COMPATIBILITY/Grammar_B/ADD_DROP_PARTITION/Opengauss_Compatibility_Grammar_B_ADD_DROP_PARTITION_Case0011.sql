-- @testpoint: 验证间隔分区表增删分区原语法和MySQL兼容语法
drop table if exists t_b_add_drop_par_0011;
-- segment on
create table t_b_add_drop_par_0011(c1 int primary key,c2 timestamp)
with (segment=on)
partition by range(c2)
interval('1 day')
(
  partition p1 values less than ('1990-01-01 00:00:00'),
  partition p2 values less than ('1990-01-02 00:00:00'),
  partition p3 values less than ('1990-01-03 00:00:00'),
  partition p4 values less than ('1990-01-04 00:00:00'),
  partition p5 values less than ('1990-01-05 00:00:00'),
  partition p6 values less than ('1990-01-06 00:00:00'),
  partition p7 values less than ('1990-01-07 00:00:00'),
  partition p8 values less than ('1990-01-08 00:00:00'),
  partition p9 values less than ('1990-01-09 00:00:00'),
  partition p10 values less than ('1990-01-10 00:00:00')
) ;
create index i_b_add_drop_par_0011_1 on t_b_add_drop_par_0011 (c1) global;
create index i_b_add_drop_par_0011_2 on t_b_add_drop_par_0011 (c2) local;
insert into t_b_add_drop_par_0011 values
  (1,'1990-01-01 00:00:00'),
  (2,'1990-01-02 00:00:00'),
  (3,'1990-01-03 00:00:00'),
  (4,'1990-01-04 00:00:00'),
  (5,'1990-01-05 00:00:00');
-- @testpoint: MySQL语法 add partition 合理报错,间隔分区表不支持手动添加分区
alter table t_b_add_drop_par_0011 add partition (partition pa1 values less than ('1990-02-01 00:00:00'));
alter table t_b_add_drop_par_0011 add partition (partition pa1 values less than ('1990-02-01 00:00:00'),partition pa2 values less than ('1990-02-02 00:00:00'));
-- @testpoint: 原语法 add partition 合理报错，间隔分区表不支持手动添加分区
alter table t_b_add_drop_par_0011 add partition pa1 values less than ('1990-02-01 00:00:00');
alter table t_b_add_drop_par_0011 add partition pa1 values less than ('1990-02-01 00:00:00'),add partition pa2 values less than ('1990-02-02 00:00:00');
drop table t_b_add_drop_par_0011;
