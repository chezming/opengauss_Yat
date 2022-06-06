-- @testpoint: list分区表上以update方式创建触发器

--step1：创建list分区表,expect成功
drop table if exists t_partition_list_0040_01;
create table t_partition_list_0040_01(p_id int,p_name varchar)
partition by list(p_id)
(partition p1 values(10),
 partition p2 values(20),
 partition p3 values(30),
 partition p4 values(40));

--step2：创建普通表,expect成功
drop table if exists t_partition_list_0040_02;
create table t_partition_list_0040_02(p_id int,p_name varchar);

--step3：向list分区表中插入数据,expect成功
BEGIN
  for i in 1..3 LOOP
    insert into t_partition_list_0040_01 values(10),(20),(30),(40);
  end LOOP;
end;
/

--step4：向普通表中插入数据,expect成功
 insert into t_partition_list_0040_02 values(10,'wang');

--step5：创建触发器函数,expect成功
CREATE OR REPLACE FUNCTION update_func() RETURNS TRIGGER AS
           $$
           DECLARE
           BEGIN
                   UPDATE t_partition_list_0040_02 SET p_name = 1 where p_id=10;
                   RETURN NEW;
           END
           $$ LANGUAGE PLPGSQL;
/

--step6：创建UPDATE触发器,expect成功
CREATE TRIGGER update_trigger
           AFTER UPDATE ON t_partition_list_0040_01
           FOR EACH ROW
           EXECUTE PROCEDURE update_func();
/
--step7： update数据,expect成功
UPDATE t_partition_list_0040_01 SET p_name = 'zhangsan' WHERE p_id=10;

--step8：查看触发器是否生效,expect成功
SELECT * FROM t_partition_list_0040_01 order by p_id asc;
SELECT * FROM t_partition_list_0040_02 order by p_id asc;

--step9：清理环境,expect成功
drop table  t_partition_list_0040_01;
drop table  t_partition_list_0040_02;
drop FUNCTION update_func();


