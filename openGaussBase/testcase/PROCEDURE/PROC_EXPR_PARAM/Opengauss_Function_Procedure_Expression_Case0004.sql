-- @testpoint: 表达式做为参数的存储过程测试--SQL表达式

--前置条件
drop table if exists Table_001;
CREATE TABLE Table_001(
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
drop index if exists indx_t1;
create unique index  indx_t1 on Table_001(T1);
drop index if exists indx_t2;
create index indx_t2 on Table_001(T2,T17,T20);


--创建存储过程
CREATE OR REPLACE PROCEDURE PROC_EXPR_PARAM_004(P1 VARCHAR) AS 
V1 VARCHAR(1200);
v_num int;
BEGIN
    if LENGTH(P1)=0
    then
		V1:='SELECT T2 from Table_001';
    else
		V1:='SELECT T2 from Table_001 WHERE '||P1;
    end if;
	raise info 'result:%',v1;
EXECUTE IMMEDIATE V1 into v_num;
raise info 'result:%',v_num;
EXCEPTION
WHEN NO_DATA_FOUND THEN raise info 'NO_DATA_FOUND';
WHEN OTHERS THEN raise info 'll';
END;
/
--调用存储过程
CALL PROC_EXPR_PARAM_004('T1=12');
CALL PROC_EXPR_PARAM_004('T12=''dbce''');
CALL PROC_EXPR_PARAM_004('T12=''abcd''');
--清理环境
drop table if exists Table_001;
drop PROCEDURE PROC_EXPR_PARAM_004;

