-- @testpoint: 创建触发器带参数INITIALLY DEFERRED,在事务结尾检查
-- @modified at: 2020-12-17

--创建源表和触发表
DROP TABLE IF EXISTS test_trigger_src_tbl0;
DROP TABLE IF EXISTS test_trigger_des_tbl0;
CREATE TABLE test_trigger_src_tbl0(id1 INT, id2 INT, id3 INT);
CREATE TABLE test_trigger_des_tbl0(id1 INT, id2 INT, id3 INT);

--创建触发器函数
CREATE OR REPLACE FUNCTION tri_insert_func01() RETURNS TRIGGER AS
$$
DECLARE
BEGIN
	INSERT INTO test_trigger_des_tbl0 VALUES(NEW.id1, NEW.id2, NEW.id3);
	RETURN NEW;
END
$$ LANGUAGE PLPGSQL;
/

--创建触发器
CREATE CONSTRAINT TRIGGER insert_trigger01 AFTER INSERT ON test_trigger_src_tbl0  INITIALLY DEFERRED  FOR EACH ROW EXECUTE PROCEDURE tri_insert_func01();

--开启事务，执行INSERT触发事件
start transaction;
INSERT INTO test_trigger_src_tbl0 VALUES(100,200,300);
SELECT * FROM test_trigger_src_tbl0;
--检查触发结果，未执行
SELECT * FROM test_trigger_des_tbl0;
commit;
--事务提交后执行，查看触发结果
SELECT * FROM test_trigger_des_tbl0;

--DROP TRIGGER
DROP TRIGGER insert_trigger01 ON test_trigger_src_tbl0;
DROP FUNCTION tri_insert_func01() cascade;
DROP TABLE test_trigger_src_tbl0;
DROP TABLE test_trigger_des_tbl0;