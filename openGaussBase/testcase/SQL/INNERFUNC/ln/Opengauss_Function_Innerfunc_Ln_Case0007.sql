-- @testpoint: 自然对数lnx用于where条件
DROP TABLE IF EXISTS TEST_LN;
CREATE TABLE TEST_LN(A INT,B INT);
INSERT INTO TEST_LN VALUES(0,1);
INSERT INTO TEST_LN VALUES(1,4);
INSERT INTO TEST_LN VALUES(0.5,2);
SELECT * FROM TEST_LN WHERE LN(1)=0 order by a,b;
DROP TABLE IF EXISTS TEST_LN;