-- @testpoint: hash分区表，重命名分区名

--创建hash分区表
drop table if exists partition_hash_tab;
create table partition_hash_tab(p_id int,p_name varchar,p_age int)
partition by hash(p_id)
(partition p1,partition p2,partition p3);

--查询分区名
select relname from pg_partition
where parentid = (select parentid from pg_partition where relname = 'partition_hash_tab')
and parttype = 'p' order by boundaries desc;

--重命名分区名
alter table partition_hash_tab rename partition p2 to p2_new;

--再次查询分区名是否被重命名
select relname from pg_partition
where parentid = (select parentid from pg_partition where relname = 'partition_hash_tab')
and parttype = 'p' order by boundaries desc;

--清理环境
drop table partition_hash_tab;