-- @testpoint: opengauss关键字collation_schema(非保留)，作为用户名 合理报错 


--关键字collation_schema作为视图名，不带引号，创建成功
CREATE or replace VIEW collation_schema AS
SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';

--关键字collation_schema作为视图名，加双引号，创建成功
CREATE  or replace VIEW "collation_schema" AS
SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';
drop VIEW "collation_schema";

--关键字collation_schema作为视图名，加单引号，合理报错
CREATE or replace VIEW 'collation_schema' AS
SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';

--关键字collation_schema作为视图名，加反引号，合理报错
CREATE or replace VIEW `collation_schema` AS
SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';
