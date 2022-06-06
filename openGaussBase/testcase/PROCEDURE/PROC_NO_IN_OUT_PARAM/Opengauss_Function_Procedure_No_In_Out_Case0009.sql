-- @testpoint: 测试无出入参存储过程（测试变量为DECIMAL型无入出参存储过程）

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

INSERT INTO PROC_NO_IN_OUT_PARAM_001 VALUES(12,58812,546223079,1234567.89,12345.6789,12.3456789,1234.56,2345.67,12345.6789,12.3456789,12.33,'dbcd','abcde','1999-01-01','ab','adc',123.45,'2005-08-08','2000-01-01 15:12:21.11','2000-08-01 15:12:21.32',true);
INSERT INTO PROC_NO_IN_OUT_PARAM_001 VALUES(13,58813,546223078,1234567.78,12345.5678,12.2345678,1234.67,2345.78,12345.5678,12.2345678,12.44,'dbce','abcdf','abcdeg','ac','ade',123.46,'2012-08-08','2000-02-01 15:22:21.11','2012-02-01 15:12:11.32',false);
INSERT INTO PROC_NO_IN_OUT_PARAM_001 VALUES(14,58814,546223077,1234567.67,12345.4567,12.1234567,1234.78,2345.89,12345.4567,12.1234567,12.55,'dbcf','abcdg','2010-02-28','ad','adf',123.47,'2002-08-11','2000-03-01 15:42:21.11','2008-08-12 15:13:21.32',true);
INSERT INTO PROC_NO_IN_OUT_PARAM_001 VALUES(15,58814,546223077,1234567.67,12345.4567,12.1234567,1234.78,2345.89,12345.4567,12.1234567,12.55,'dbcf','abcdg','abcdeh','ad','adf',123.47,'2002-08-11','2000-03-01 15:42:21.11','2008-08-12 15:13:21.32',true);
INSERT INTO PROC_NO_IN_OUT_PARAM_001 VALUES(16,58814,546223077,1234567.67,12345.4567,12.1234567,1234.78,2345.89,12345.4567,12.1234567,12.55,'dbcf','abcdg','abcdeh','ad','adf',123.47,'2002-08-11','2000-03-01 15:42:21.11','2008-08-12 15:13:21.32',true);


CREATE OR REPLACE PROCEDURE PROC_NO_IN_OUT_PARAM_008 AS
V_DECIMAL DECIMAL;
BEGIN
SELECT C_DECIMAL INTO V_DECIMAL FROM PROC_NO_IN_OUT_PARAM_001 WHERE C_INT=12;
raise info ':%',V_DECIMAL;
EXCEPTION
WHEN NO_DATA_FOUND THEN raise info 'NO_DATA_FOUND';
END ;
/

Call PROC_NO_IN_OUT_PARAM_008();
drop procedure PROC_NO_IN_OUT_PARAM_008;
