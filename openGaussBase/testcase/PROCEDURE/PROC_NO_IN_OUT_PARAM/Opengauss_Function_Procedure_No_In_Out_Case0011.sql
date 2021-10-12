-- @testpoint: 测试无出入参存储过程（测试变量为DECIMAL(8,4)型无入出参存储过程）

drop table if exists PROC_NO_IN_OUT_PARAM_001;
CREATE TABLE PROC_NO_IN_OUT_PARAM_001(
C_INT INT ,
C_INTEGER INTEGER NOT NULL ,
C_BIGINT BIGINT,
C_NUMBER NUMBER DEFAULT 0.2332,
C_NUMBER1 NUMBER(12,2),
C_NUMBER2 NUMBER(12,6),
C_BINARY BINARY_DOUBLE,
C_DECIMAL DECIMAL,
C_DECIMAL1 DECIMAL(8,2),
C_DECIMAL2 DECIMAL(8,4),
C_REAL REAL,C_CHAR CHAR(4000),
C_VARCHAR VARCHAR(4000),
C_VARCHAR2 VARCHAR2(4000),
C_VARCHAR1 VARCHAR(100),
C_CHAR1 CHAR(100),
C_NUMERIC NUMERIC,
C_DATE DATE,
C_TIMESTAMP TIMESTAMP,
C_TIMESTAMP1 TIMESTAMP(6),
C_BOOL BOOL
) ;

drop index if exists indx_t1 ;
create unique index  indx_t1 on PROC_NO_IN_OUT_PARAM_001 (c_int);

drop index  if exists indx_t2;
create index indx_t2 on PROC_NO_IN_OUT_PARAM_001 (c_int,C_TIMESTAMP);




CREATE OR REPLACE PROCEDURE PROC_NO_IN_OUT_PARAM_010 AS
V_DECIMAL2 DECIMAL(8,4);
BEGIN
SELECT C_DECIMAL2 INTO V_DECIMAL2 FROM PROC_NO_IN_OUT_PARAM_001 WHERE C_INT=12;
raise info ':%',V_DECIMAL2;
EXCEPTION
WHEN NO_DATA_FOUND THEN raise info 'NO_DATA_FOUND';
END;
/

Call PROC_NO_IN_OUT_PARAM_010();
drop procedure PROC_NO_IN_OUT_PARAM_010;
