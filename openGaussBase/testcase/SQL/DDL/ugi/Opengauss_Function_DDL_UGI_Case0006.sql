-- @testpoint: 验证【列表】分区表【drop partition】时，update global index关键字对【btree】类型【多字段索引】的重建作用

--创建分区表，插入样例数据，建立全局索引
drop table if exists test_ugi_006;
create table test_ugi_006
(
    c_id integer not null,
    c_name varchar(16) default 'omm',
    c_class varchar(20) not null
)
partition by LIST(c_id)
(
    partition p1 values (1,2,3),
    partition p2 values (4,5,6),
    partition p3 values (7,8,9),
    partition p4 values (10,11,12),
    partition p5 values (13,14,15),
    partition p6 values (16,17,18)
);

insert into test_ugi_006(c_id, c_class) select r, '1-1' from generate_series(1,3) as r;
insert into test_ugi_006(c_id, c_class) select r, '1-2' from generate_series(4,6) as r;
insert into test_ugi_006(c_id, c_class) select r, '1-3' from generate_series(7,9) as r;
insert into test_ugi_006(c_id, c_class) select r, '1-4' from generate_series(10,12) as r;
insert into test_ugi_006(c_id, c_class) select r, '1-5' from generate_series(13,15) as r;
insert into test_ugi_006(c_id, c_class) select r, '1-6' from generate_series(16,18) as r;

create index global_index_id_006 on test_ugi_006(c_id, c_name) global;
create index global_index_class_006 on test_ugi_006(c_class, c_name) global;
--收集统计信息
analyse test_ugi_006;

--禁用seqscan
set enable_seqscan = off;

--确认删除分区可以破坏全局索引，并使用alter index xxx rebuild重建索引global_index_id_086
--查看分区状态
select t1.relname, partstrategy, boundaries from pg_partition t1, pg_class t2 
where t1.parentid = t2.oid and t2.relname = 'test_ugi_006' and t1.parttype = 'p' order by relname;
--查看执行计划，确认走index scan
explain analyse select * from test_ugi_006 where c_id = 10;
--删除分区p2，破坏全局索引
alter table test_ugi_006 drop partition p2;
--分区p2已被删除
select t1.relname, partstrategy, boundaries from pg_partition t1, pg_class t2 
where t1.parentid = t2.oid and t2.relname = 'test_ugi_006' and t1.parttype = 'p' order by relname;
--查看索引可用情况，索引已不可用
select c.relname, i.indisusable from pg_index i join pg_class c on i.indexrelid = c.oid 
where i.indrelid = 'test_ugi_006'::regclass order by c.relname;
--查看执行计划，走seq scan
explain analyse select * from test_ugi_006 where c_id = 10;
--使用alter index xxx rebuild重建索引
alter index global_index_id_006 rebuild;
--查看索引可用情况，global_index_id_086可用，global_index_class_086不可用，可用索引查看执行计划确走index scan
select c.relname, i.indisusable from pg_index i join pg_class c on i.indexrelid = c.oid 
where i.indrelid = 'test_ugi_006'::regclass order by c.relname;
explain analyse select * from test_ugi_006 where c_id = 10;
vacuum analyse;

--删除分区p3，破坏全局索引，带update global index关键字
alter table test_ugi_006 drop partition p3 update global index;
select t1.relname, partstrategy, boundaries from pg_partition t1, pg_class t2 
where t1.parentid = t2.oid and t2.relname = 'test_ugi_006' and t1.parttype = 'p' order by relname;
--此时，global_index_id_006可用，global_index_class_006不可用
select c.relname, i.indisusable from pg_index i join pg_class c on i.indexrelid = c.oid 
where i.indrelid = 'test_ugi_006'::regclass order by c.relname;
--查看执行计划，c_id走index scan，c_class走seq scan
explain analyse select * from test_ugi_006 where c_id = 10;
explain analyse select * from test_ugi_006 where c_class = '1-2';

--表test_ugi_006应当包含"wait_clean_gpi=y"
select a.relname,a.parttype,a.reloptions from pg_partition a, pg_class b 
where a.parentid = b.oid and b.relname = 'test_ugi_006' and a.reloptions[3] like '%wait_clean_gpi=y%' order by 1,2,3;
--执行清理
vacuum analyse;
--表test_ugi_006不再包含"wait_clean_gpi=y"
select a.relname,a.parttype,a.reloptions from pg_partition a, pg_class b 
where a.parentid = b.oid and b.relname = 'test_ugi_006' and a.reloptions[3] like '%wait_clean_gpi=y%' order by 1,2,3;

--执行insert、update、delete等操作
insert into test_ugi_006(c_id, c_class) select r, '1-1' from generate_series(1,3) as r;
update test_ugi_006 set c_class = '1-2' where c_id = 5;
delete from test_ugi_006 where c_id = 5;
--查看执行计划，c_id走index scan
explain analyse select * from test_ugi_006 where c_id = 10;

--确认test_ugi_006表中数据量正确，15行
select count(*) from test_ugi_006;
--清理表
drop table test_ugi_006;