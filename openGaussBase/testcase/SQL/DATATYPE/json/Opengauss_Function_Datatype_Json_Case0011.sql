-- @testpoint: 创建行存分区表，合理报错

drop table if exists test_json_11;
create table test_json_11 (c1 json,c2 int) WITH (orientation=row, compression=no)
PARTITION BY RANGE (c1)
(
        PARTITION P1 VALUES LESS THAN('g'),
        PARTITION P2 VALUES LESS THAN('n'),
        PARTITION P3 VALUES LESS THAN('q'),
        PARTITION P4 VALUES LESS THAN('t'),
        PARTITION P5 VALUES LESS THAN('w'),
        PARTITION P6 VALUES LESS THAN('z'));
