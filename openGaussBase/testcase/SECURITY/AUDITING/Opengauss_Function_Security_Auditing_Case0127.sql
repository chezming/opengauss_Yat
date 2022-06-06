-- @testpoint: 管理员用户给不同对象添加相同名称的资源标签，添加成功
--step1: 管理员用户创建多个对象；expect:成功
DROP VIEW IF EXISTS v_security_auditing_0127;
DROP TABLE IF EXISTS table_security_auditing_0127;
DROP FUNCTION IF EXISTS func_security_auditing_0127;
DROP SCHEMA IF EXISTS schema_security_auditing_0127;
CREATE SCHEMA schema_security_auditing_0127;
CREATE FUNCTION func_security_auditing_0127(integer, integer) RETURNS integer
    AS 'select $1 + $2;'
    LANGUAGE SQL
    IMMUTABLE
    RETURNS NULL ON NULL INPUT;
/
CREATE VIEW v_security_auditing_0127 AS SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';
CREATE TABLE table_security_auditing_0127(id int,name char(10));
--step2: 管理员用户给多个对象添加资源标签；expect:成功
DROP RESOURCE LABEL IF EXISTS rl_security_auditing_0127;
CREATE RESOURCE LABEL rl_security_auditing_0127 ADD FUNCTION(func_security_auditing_0127);
ALTER RESOURCE LABEL rl_security_auditing_0127 ADD SCHEMA(schema_security_auditing_0127);
ALTER RESOURCE LABEL rl_security_auditing_0127 ADD VIEW(v_security_auditing_0127);
ALTER RESOURCE LABEL rl_security_auditing_0127 ADD TABLE(table_security_auditing_0127);
--step3: 管理员用户从资源标签移除对象；expect:成功
ALTER RESOURCE LABEL rl_security_auditing_0127 REMOVE TABLE(table_security_auditing_0127);
--step4: 清理环境；expect:成功
DROP RESOURCE LABEL rl_security_auditing_0127;
DROP FUNCTION func_security_auditing_0127;