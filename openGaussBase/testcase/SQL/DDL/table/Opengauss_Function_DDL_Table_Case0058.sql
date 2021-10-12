-- @testpoint: create table和LIKE INCLUDING INDEXES参数结合使用

DROP TABLE IF EXISTS tab_12;
drop table if exists long;
CREATE TABLE tab_12
(id                     NUMBER(7) CONSTRAINT PK_TAB PRIMARY KEY USING INDEX,
 use_filename              VARCHAR2(20) ,
 filename                  VARCHAR2(255),
 text                       VARCHAR2(2000)
 );


create table long (like  tab_12 INCLUDING INDEXES);
drop table if exists tab_12;
drop table if exists long;
