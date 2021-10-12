-- @testpoint: 表达式做为参数的存储过程测试--case表达式

--创建存储过程
CREATE OR REPLACE PROCEDURE FVT_PROC_EXPR_PARAM_005(score IN REAL,grade OUT VARCHAR)  AS
BEGIN
CASE 
when (score < 0)  then raise info 'The score is invalid';
when (score > 100)  then raise info 'The score is invalid';
when (score > 90)  then grade:='A';
when (score > 80) then grade:='B';
when (score > 60) then grade:='C';
when (score < 60) then grade:='D';
raise info 'NO data found';
end case;
raise info 'The grade is :% ',grade;
END; 
/
--调用存储过程
DECLARE
V_score REAL :=85.5;
V_grade char(4000);
BEGIN
FVT_PROC_EXPR_PARAM_005(V_score,V_grade);
END;
/
--清理环境
drop PROCEDURE FVT_PROC_EXPR_PARAM_005;














