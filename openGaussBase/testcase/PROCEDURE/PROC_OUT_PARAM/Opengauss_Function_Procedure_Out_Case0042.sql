-- @testpoint: 仅带出参，将变量转为INT类型输出的存储过程

drop table if exists TEST_001;
CREATE TABLE TEST_001(
  T1 INT,
  T2 INTEGER NOT NULL,
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

create unique index  indx_out_param_t1 on TEST_001(T1);
create index indx_out_param_t2 on TEST_001(T2,T17,T20);




--仅带出参的存储过程测试（测试将变量转为INT类型输出的存储过程）
CREATE OR REPLACE PROCEDURE PROC_OUT_PARAM_001(P1 OUT INT) 
AS
V1 INT:=17.34;
BEGIN
raise info 'V1:%',V1;
END;
/

--调用存储过程
DECLARE
P_V1 INT;
BEGIN 
PROC_OUT_PARAM_001(P_V1);
END;
/
drop PROCEDURE PROC_OUT_PARAM_001;
drop table if exists test_001;