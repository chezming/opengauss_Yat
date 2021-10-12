-- @testpoint: megre语句验证表名，字段名大小写
DROP TABLE IF EXISTS bonuses_depa1;
DROP TABLE IF EXISTS new_bonuses_depa1;
CREATE TABLE bonuses_depa1(staff_id INT NOT NULL, staff_name CHAR(50), job VARCHAR(30), bonus NUMBER);
CREATE TABLE new_bonuses_depa1(staff_id INT NOT NULL, staff_name CHAR(50), job VARCHAR(30), bonus NUMBER);
INSERT INTO bonuses_depa1(staff_id, staff_name, job, bonus) VALUES(23,'王霞','研发',5000);
INSERT INTO bonuses_depa1(staff_id, staff_name, job, bonus) VALUES(24,'李名莹','测试',7000);
INSERT INTO bonuses_depa1(staff_id, staff_name, job, bonus) VALUES(25,'刘莉莉','质量控制',8000);
INSERT INTO bonuses_depa1(staff_id, staff_name, job, bonus) VALUES(29,'刘雪','测试',8000);
INSERT INTO bonuses_depa1(staff_id, staff_name, job, bonus) VALUES(21,'曹明','资料开发',11000);
SELECT * FROM bonuses_depa1 ORDER BY 1,2,3,4;
INSERT INTO new_bonuses_depa1(staff_id, staff_name, job, bonus) VALUES(23,'王霞','研发',7000);
INSERT INTO new_bonuses_depa1(staff_id, staff_name, job, bonus) VALUES(27,'王雪芬','资料开发',7000);
INSERT INTO new_bonuses_depa1(staff_id, staff_name, job, bonus) VALUES(28,'邓辉','质量控制',8000);
INSERT INTO new_bonuses_depa1(staff_id, staff_name, job, bonus) VALUES(25,'刘莉莉','质量控制',10000);
INSERT INTO new_bonuses_depa1(staff_id, staff_name, job, bonus) VALUES(21,'曹明','资料开发',12000);
SELECT * FROM new_bonuses_depa1 ORDER BY 1,2,3,4;
MERGE INTO Bonuses_depa1 BD1 USING new_bonuses_depa1 NBD1 ON (BD1.staff_id = NBD1.staff_id) WHEN MATCHED THEN UPDATE SET BD1.bonus = NBD1.bonus WHEN NOT MATCHED THEN INSERT (staff_id, staff_name, job, bonus) VALUES (NBD1.staff_id, NBD1.staff_name, NBD1.job, NBD1.bonus);
SELECT * FROM bonuses_depa1 ORDER BY 1,2,3,4;
MERGE INTO bonuses_depa1 bD1 USING new_bonuses_depa1 NBD1 ON (BD1.staff_id = NBD1.staff_id) WHEN MATCHED THEN UPDATE SET BD1.bonus = NBD1.bonus WHEN NOT MATCHED THEN INSERT (staff_id, staff_name, job, bonus) VALUES (NBD1.staff_id, NBD1.staff_name, NBD1.job, NBD1.bonus);
SELECT * FROM bonuses_depa1 ORDER BY 1,2,3,4;
MERGE INTO bonuses_depa1 BD1 USING new_bonuses_depa1 NBD1 ON (BD1.staff_ID = NBD1.staff_id) WHEN MATCHED THEN UPDATE SET BD1.bonus = NBD1.bonus WHEN NOT MATCHED THEN INSERT (staff_id, staff_name, job, bonus) VALUES (NBD1.staff_id, NBD1.staff_name, NBD1.job, NBD1.bonus);
SELECT * FROM bonuses_depa1 ORDER BY 1,2,3,4;
MERGE INTO bonuses_depa1 BD1 USING new_bonuses_depa1 NBD1 ON (BD1.staff_id = NBD1.staff_id) WHEN MATCHED THEN UPDATE SET BD1.bonus = NBD1.bonus WHEN NOT MATCHED THEN INSERT (staff_ID, staff_name, job, bonus) VALUES (NBD1.staff_id, NBD1.staff_name, NBD1.job, NBD1.bonus);
SELECT * FROM bonuses_depa1 ORDER BY 1,2,3,4;
MERGE INTO bonuses_depa1 BD1 USING new_bonuses_depa1 NBD1 ON (BD1.staff_id = NBD1.staff_id) WHEN MATCHED THEN UPDATE SET BD1.bonus = NBD1.bonus WHEN NOT MATCHED THEN INSERT (staff_id, staff_name, job, bonus) VALUES (nBD1.staff_id, NBD1.staff_name, NBD1.job, NBD1.bonus);
SELECT * FROM bonuses_depa1 ORDER BY 1,2,3,4;
MERGE INTO bonuses_depa1 BD1 USING New_bonuses_depa1 NBD1 ON (BD1.staff_id = NBD1.staff_id) WHEN MATCHED THEN UPDATE SET BD1.bonus = NBD1.bonus WHEN NOT MATCHED THEN INSERT (staff_id, staff_name, job, bonus) VALUES (NBD1.staff_id, NBD1.staff_name, NBD1.job, NBD1.bonus);
SELECT * FROM bonuses_depa1 ORDER BY 1,2,3,4;
MERGE INTO bonuses_depa1 BD1 USING new_bonuses_depa1 NBD1 ON (BD1.staff_id = NBD1.staff_id) WHEN MATCHED THEN UPDATE SET BD1.bonus = NBD1.bonus WHEN NOT MATCHED THEN INSERT (staff_id, staff_name, job, bonus) VALUES (NBD1.staff_id, NBD1.staff_name, NBD1.job, NBD1.bonus);
SELECT * FROM bonuses_depa1 ORDER BY 1,2,3,4;
--清理环境
DROP TABLE IF EXISTS bonuses_depa1;
DROP TABLE IF EXISTS new_bonuses_depa1;