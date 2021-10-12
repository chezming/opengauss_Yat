--  @testpoint: column_name：行存临时表常用数据类型33列
DROP TABLE if EXISTS test_index_table_076 CASCADE;
create temporary table test_index_table_076(
c_varchar1 varchar,c_varchar2 varchar,c_varchar3 varchar,c_varchar4 varchar,c_varchar5 varchar,
c_varchar6 varchar,c_varchar7 varchar,c_varchar8 varchar,c_varchar9 varchar,c_varchar10 varchar,c_varchar11 varchar,c_varchar12 varchar,
c_varchar13 varchar,c_varchar14 varchar,c_varchar15 varchar,c_varchar16 varchar,c_varchar17 varchar,c_varchar18 varchar,c_varchar19 varchar,
c_varchar20 varchar,c_varchar21 varchar,c_varchar22 varchar,c_varchar23 varchar,c_varchar24 varchar,c_varchar25 varchar,c_varchar26 varchar,
c_varchar27 varchar,c_varchar28 varchar,c_varchar29 varchar,c_varchar30 varchar,c_varchar31 varchar,c_varchar32 varchar,c_varchar33 varchar
) WITH (ORIENTATION = row);

--建psort索引:合理报错
drop index if exists index_076_01;
create index index_076_01 on test_index_table_076 using psort(c_varchar1,
c_varchar2,c_varchar3,c_varchar4,c_varchar5,c_varchar6,c_varchar7,c_varchar8,c_varchar9,c_varchar10,c_varchar11,c_varchar12,
c_varchar13,c_varchar14,c_varchar15,c_varchar16,c_varchar17,c_varchar18,c_varchar19,c_varchar20,c_varchar21,c_varchar22,
c_varchar23,c_varchar24,c_varchar25,c_varchar26,c_varchar27,c_varchar28,c_varchar29,c_varchar30,c_varchar31,c_varchar32,c_varchar33);

select relname from pg_class where relname like 'index_076_%' order by relname;

--btree:合理报错
drop index if exists index_076_01;
create index index_076_01 on test_index_table_076 using btree(c_varchar1,
c_varchar2,c_varchar3,c_varchar4,c_varchar5,c_varchar6,c_varchar7,c_varchar8,c_varchar9,c_varchar10,c_varchar11,c_varchar12,
c_varchar13,c_varchar14,c_varchar15,c_varchar16,c_varchar17,c_varchar18,c_varchar19,c_varchar20,c_varchar21,c_varchar22,
c_varchar23,c_varchar24,c_varchar25,c_varchar26,c_varchar27,c_varchar28,c_varchar29,c_varchar30,c_varchar31,c_varchar32,c_varchar33);

select relname from pg_class where relname like 'index_076_%' order by relname;

--gist:合理报错
drop index if exists index_076_01;
create index index_076_01 on test_index_table_076 using gist(c_varchar1,
c_varchar2,c_varchar3,c_varchar4,c_varchar5,c_varchar6,c_varchar7,c_varchar8,c_varchar9,c_varchar10,c_varchar11,c_varchar12,
c_varchar13,c_varchar14,c_varchar15,c_varchar16,c_varchar17,c_varchar18,c_varchar19,c_varchar20,c_varchar21,c_varchar22,
c_varchar23,c_varchar24,c_varchar25,c_varchar26,c_varchar27,c_varchar28,c_varchar29,c_varchar30,c_varchar31,c_varchar32,c_varchar33);

select relname from pg_class where relname like 'index_076_%' order by relname;

--gin:合理报错
drop index if exists index_076_01;
create index index_076_01 on test_index_table_076 using gin(to_tsvector('english', c_varchar1),
to_tsvector('english', c_varchar2),
to_tsvector('english', c_varchar3),
to_tsvector('english', c_varchar4),
to_tsvector('english', c_varchar5),
to_tsvector('english', c_varchar6),
to_tsvector('english', c_varchar7),
to_tsvector('english', c_varchar8),
to_tsvector('english', c_varchar9),
to_tsvector('english', c_varchar10),
to_tsvector('english', c_varchar11),
to_tsvector('english', c_varchar12),
to_tsvector('english', c_varchar13),
to_tsvector('english', c_varchar14),
to_tsvector('english', c_varchar15),
to_tsvector('english', c_varchar16),
to_tsvector('english', c_varchar17),
to_tsvector('english', c_varchar18),
to_tsvector('english', c_varchar19),
to_tsvector('english', c_varchar20),
to_tsvector('english', c_varchar21),
to_tsvector('english', c_varchar22),
to_tsvector('english', c_varchar23),
to_tsvector('english', c_varchar24),
to_tsvector('english', c_varchar25),
to_tsvector('english', c_varchar26),
to_tsvector('english', c_varchar27),
to_tsvector('english', c_varchar28),
to_tsvector('english', c_varchar29),
to_tsvector('english', c_varchar30),
to_tsvector('english', c_varchar31),
to_tsvector('english', c_varchar32),
to_tsvector('english', c_varchar33));

select relname from pg_class where relname like 'index_076_%' order by relname;

--清理环境
DROP TABLE if EXISTS test_index_table_076 CASCADE;
