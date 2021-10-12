-- @testpoint: 自然对数lnx入参是列
DROP TABLE IF EXISTS TEST_LN;
CREATE TABLE TEST_LN(A INT,B INT);
INSERT INTO TEST_LN VALUES(0,1);
INSERT INTO TEST_LN VALUES(1,4);
INSERT INTO TEST_LN VALUES(0.5,2);
SELECT LN(B) FROM TEST_LN order by LN(B);
DROP TABLE IF EXISTS TEST_LN;