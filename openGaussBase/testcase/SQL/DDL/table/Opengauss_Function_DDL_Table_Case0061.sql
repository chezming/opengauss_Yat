-- @testpoint: create table和LIKE INCLUDING PARTITION参数结合使用
DROP TABLE IF EXISTS tab_12;
CREATE TABLE tab_12
(id                      NUMBER(7)
   CONSTRAINT tab_12_id_nn NOT NULL,
 use_filename              VARCHAR2(20),
 filename                  VARCHAR2(255),
 text                       VARCHAR2(2000)
  )PARTITION BY RANGE(id)
(
        PARTITION P1 VALUES LESS THAN(30),
        PARTITION P2 VALUES LESS THAN(60),
        PARTITION P3 VALUES LESS THAN(90),
        PARTITION P4 VALUES LESS THAN(MAXVALUE)
);

insert into tab_12 values(1,'李','小龙','截拳道大师');
create table long (like  tab_12 INCLUDING PARTITION);
drop table if exists tab_12;
drop table if exists long;