-- @testpoint: 对blob类型的不为null的约束,如果插入的列有null值会合理报错
DROP TABLE IF EXISTS t_blob;
CREATE TABLE t_blob(ID BLOB NOT NULL);
INSERT INTO t_blob VALUES('35466');
INSERT INTO t_blob VALUES('100000');
INSERT INTO t_blob VALUES('C4711A1097876CC');
INSERT INTO t_blob VALUES('');
INSERT INTO t_blob VALUES(NULL);
COMMIT;
DROP TABLE IF EXISTS t_blob;