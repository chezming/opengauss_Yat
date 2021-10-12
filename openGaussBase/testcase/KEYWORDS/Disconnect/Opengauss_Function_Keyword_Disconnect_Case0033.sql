--  @testpoint:opengauss关键字disconnect(非保留)，作为视图名


--关键字disconnect作为视图名，不带引号，创建成功
CREATE or replace VIEW disconnect AS
SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';
drop view disconnect;

--关键字disconnect作为视图名，加双引号，创建成功
CREATE  or replace VIEW "disconnect" AS
SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';
drop VIEW "disconnect";

--关键字disconnect作为视图名，加单引号，合理报错
CREATE or replace VIEW 'disconnect' AS
SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';

--关键字disconnect作为视图名，加反引号，合理报错
CREATE or replace VIEW `disconnect` AS
SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';

