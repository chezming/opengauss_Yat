-- @testpoint: list分区表上以truncate方式创建触发器

--step1：创建list分区表,expect成功
drop table if exists t_partition_list_0049_01;
create table t_partition_list_0049_01(p_id int,p_name varchar)
partition by list(p_id)
(partition p1 values(10),
 partition p2 values(20),
 partition p3 values(30),
 partition p4 values(40));

--step2：创建普通表,expect成功
drop table if exists t_partition_list_0049_02;
create table t_partition_list_0049_02(p_id int,p_name varchar);

--step3：向list分区表中插入数据,expect成功
BEGIN
  for i in 1..3 LOOP
    insert into t_partition_list_0049_01 values(10),(20),(30),(40);
  end LOOP;
end;
/

--step4：创建触发器函数,expect成功
CREATE OR REPLACE FUNCTION truncate_func() RETURNS TRIGGER AS
           $$
           DECLARE
           BEGIN
                   INSERT INTO t_partition_list_0049_02 VALUES(1);
                   RETURN NEW;
           END
           $$ LANGUAGE PLPGSQL;
/

--step5：创建truncate触发器,expect成功
CREATE TRIGGER truncate_trigger
           AFTER truncate on t_partition_list_0049_01
           FOR EACH STATEMENT
           EXECUTE PROCEDURE truncate_func();
/
--step6:truncate分区表,expect成功
truncate table t_partition_list_0049_01;

--step7：查看触发器是否生效,expect成功
SELECT * FROM t_partition_list_0049_01 order by p_id asc;
SELECT * FROM t_partition_list_0049_02 order by p_id asc;

--step8：清理环境,expect成功
drop table  t_partition_list_0049_01;
drop table  t_partition_list_0049_02;
drop FUNCTION truncate_func();