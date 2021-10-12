-- @testpoint: 插入数据，字段值包含单引号，未转义，合理报错
--建表
drop table if exists COMPANY;
CREATE TABLE COMPANY(
   ID INT PRIMARY KEY     NOT NULL,
   NAME           TEXT    NOT NULL,
   AGE            INT     NOT NULL,
   ADDRESS        CHAR(50),
   SALARY         REAL,
   JOIN_DATE      DATE
);
--插入数据，合理报错
insert into COMPANY values(1','tom's',10,105,8500.9,'2020-11-17');
--删表
drop table COMPANY;