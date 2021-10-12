-- @testpoint: 标量类型%rowtype的测试———基本类型测试



--标量类型%type的测试———基本类型测试

drop table if exists FVT_PROC_SCALAR_ROWTYPE_table_005;
CREATE TABLE FVT_PROC_SCALAR_ROWTYPE_table_005(
  T1 INT NOT NULL,
  T2 INTEGER,
  T3 BIGINT,
  T4 NUMBER DEFAULT 0.2332,
  T5 NUMBER(12,2),
  T6 NUMBER(12,6),
  T7 BINARY_DOUBLE,
  T8 DECIMAL,
  T9 DECIMAL(8,2),
  T10 DECIMAL(8,4),
  T11 REAL,
  T12 CHAR(4000),
  T13 CHAR(100),
  T14 VARCHAR(4000),
  T15 VARCHAR(100),
  T16 VARCHAR2(4000),
  T17 NUMERIC,
 
  T19 DATE,
  T20 TIMESTAMP,
  T21 TIMESTAMP(6),
  T22 BOOL
) ;

create unique index  FVT_PROC_SCALAR_ROWTYPE_table_index_005 on FVT_PROC_SCALAR_ROWTYPE_table_005(T1);
create index FVT_PROC_SCALAR_ROWTYPE_table_index1_005 on FVT_PROC_SCALAR_ROWTYPE_table_005(T2,T17,T20);



--创建存储过程
CREATE OR REPLACE PROCEDURE FVT_PROC_SCALAR_ROWTYPE_005()  AS
V1 FVT_PROC_SCALAR_ROWTYPE_table_005%rowtype;
BEGIN
select * into V1 from FVT_PROC_SCALAR_ROWTYPE_table_005 where T1=14;
raise info 'T13=:%',V1.T13;
EXCEPTION
WHEN NO_DATA_FOUND THEN raise info 'NO_DATA_FOUND';
END;
/

--修改列属性
alter table FVT_PROC_SCALAR_ROWTYPE_table_005 modify T13 INT;




--重新编译存储过程
CREATE OR REPLACE PROCEDURE FVT_PROC_SCALAR_ROWTYPE_005()  AS
V1 FVT_PROC_SCALAR_ROWTYPE_table_005%rowtype;
BEGIN
select * into V1 from FVT_PROC_SCALAR_ROWTYPE_table_005 where T1=14;
raise info 'T13=:%',V1.T13;
EXCEPTION
WHEN NO_DATA_FOUND THEN raise info 'NO_DATA_FOUND';
END;
/

--调用存储过程
CALL FVT_PROC_SCALAR_ROWTYPE_005();

--恢复环境
drop table if exists FVT_PROC_SCALAR_ROWTYPE_table_005;
drop procedure if exists FVT_PROC_SCALAR_ROWTYPE_005;