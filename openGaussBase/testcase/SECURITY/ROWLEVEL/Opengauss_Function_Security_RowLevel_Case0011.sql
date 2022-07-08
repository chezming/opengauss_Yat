-- @testpoint: 支持列存分区表创建行级访问策略
--step1: 创建列存分区表；expect:成功
DROP TABLE IF EXISTS t_security_RowLwvel_0011;
CREATE TABLE t_security_RowLwvel_0011(id int, card integer NOT NULL,role char(5),data varchar(10))  WITH (ORIENTATION = COLUMN) PARTITION BY RANGE (card)
(
    PARTITION P1 VALUES LESS THAN(5000),
    PARTITION P2 VALUES LESS THAN(10000),
    PARTITION P3 VALUES LESS THAN(15000),
    PARTITION P4 VALUES LESS THAN(20000),
    PARTITION P5 VALUES LESS THAN(25000),
    PARTITION P6 VALUES LESS THAN(30000),
    PARTITION P7 VALUES LESS THAN(40000)
);
--step2: 创建行级访问策略；expect:成功
ALTER TABLE t_security_RowLwvel_0011 ENABLE ROW LEVEL SECURITY;
CREATE ROW LEVEL SECURITY POLICY rls_security_RowLwvel_0011 ON t_security_RowLwvel_0011 USING(role = CURRENT_USER);
--step3: 清理环境；expect:成功
DROP TABLE t_security_RowLwvel_0011 CASCADE;