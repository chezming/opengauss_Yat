-- @testpoint: 验证【范围】分区表【drop partition】时，update global index关键字对【btree】类型【唯一性多字段索引】的重建作用

--创建分区表，插入样例数据，建立全局索引
drop table if exists test_ugi_096;
create table test_ugi_096
(
    c_id integer not null,
    c_name varchar(16) default 'omm',
    c_class varchar(20) not null
)
partition by range(c_id)
(
    partition p1 values less than (1001), 
    partition p2 values less than (2001), 
    partition p3 values less than (3001),
    partition p4 values less than (4001),
    partition p5 values less than (5001),
    partition p6 values less than (6001)
);

insert into test_ugi_096(c_id, c_class) select r, '1-1' from generate_series(1,1000) as r;
insert into test_ugi_096(c_id, c_class) select r, '1-2' from generate_series(1001,2000) as r;
insert into test_ugi_096(c_id, c_class) select r, '1-3' from generate_series(2001,3000) as r;
insert into test_ugi_096(c_id, c_class) select r, '1-4' from generate_series(3001,4000) as r;
insert into test_ugi_096(c_id, c_class) select r, '1-5' from generate_series(4001,5000) as r;
insert into test_ugi_096(c_id, c_class) select r, '1-6' from generate_series(5001,6000) as r;

create unique index global_index_id_096 on test_ugi_096(c_id, c_name) global;

--收集统计信息
analyse test_ugi_096;

--确认删除分区可以破坏全局索引，并使用alter index xxx rebuild重建索引global_index_id_096
--查看分区状态
select t1.relname, partstrategy, boundaries from pg_partition t1, pg_class t2 
where t1.parentid = t2.oid and t2.relname = 'test_ugi_096' and t1.parttype = 'p' order by relname;
--查看执行计划，确认走index scan
explain analyse select * from test_ugi_096 where c_id = 2333;
--删除分区p2，破坏全局索引
alter table test_ugi_096 drop partition p2;
--分区p2已被删除
select t1.relname, partstrategy, boundaries from pg_partition t1, pg_class t2 
where t1.parentid = t2.oid and t2.relname = 'test_ugi_096' and t1.parttype = 'p' order by relname;
--查看索引可用情况，索引已不可用
select c.relname, i.indisusable from pg_index i join pg_class c on i.indexrelid = c.oid 
where i.indrelid = 'test_ugi_096'::regclass order by c.relname;
--查看执行计划，走seq scan
explain analyse select * from test_ugi_096 where c_id = 2333;
--使用alter index xxx rebuild重建索引
alter index global_index_id_096 rebuild;
--查看索引可用情况，global_index_id_096可用，可用索引查看执行计划确走index scan
select c.relname, i.indisusable from pg_index i join pg_class c on i.indexrelid = c.oid 
where i.indrelid = 'test_ugi_096'::regclass order by c.relname;
explain analyse select * from test_ugi_096 where c_id = 2333;
vacuum analyse;

--删除分区p3，破坏全局索引，带update global index关键字
alter table test_ugi_096 drop partition p3 update global index;
select t1.relname, partstrategy, boundaries from pg_partition t1, pg_class t2 
where t1.parentid = t2.oid and t2.relname = 'test_ugi_096' and t1.parttype = 'p' order by relname;
--此时，global_index_id_096可用
select c.relname, i.indisusable from pg_index i join pg_class c on i.indexrelid = c.oid 
where i.indrelid = 'test_ugi_096'::regclass order by c.relname;
--查看执行计划，c_id走index scan
explain analyse select * from test_ugi_096 where c_id = 2333;

--表test_ugi_096应当包含"wait_clean_gpi=y"
select a.relname,a.parttype,a.reloptions from pg_partition a, pg_class b 
where a.parentid = b.oid and b.relname = 'test_ugi_096' and a.reloptions[3] like '%wait_clean_gpi=y%' order by 1,2,3;
--执行清理
vacuum analyse;
--表test_ugi_096不再包含"wait_clean_gpi=y"
select a.relname,a.parttype,a.reloptions from pg_partition a, pg_class b 
where a.parentid = b.oid and b.relname = 'test_ugi_096' and a.reloptions[3] like '%wait_clean_gpi=y%' order by 1,2,3;

--执行insert、update、delete等操作
insert into test_ugi_096(c_id, c_class) select r, '1-1' from generate_series(1005,1020) as r;
update test_ugi_096 set c_class = '2-1' where c_id = 5005;
delete from test_ugi_096 where c_id = 4830;
--查看执行计划，c_id走index scan
explain analyse select * from test_ugi_096 where c_id = 2333;

--确认test_ugi_096表中数据量正确，4015行
select count(*) from test_ugi_096;
--清理表
drop table test_ugi_096;