--  @testpoint:opengauss关键字reuse(非保留)，作为视图名
--关键字reuse作为视图名，不带引号，创建成功
CREATE or replace VIEW reuse AS
SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';

--清理环境
drop view reuse;

--关键字reuse作为视图名，加双引号，创建成功
CREATE  or replace VIEW "reuse" AS
SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';

--清理环境
drop VIEW "reuse";
--关键字reuse作为视图名，加单引号，合理报错

CREATE or replace VIEW 'reuse' AS
SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';

--关键字reuse作为视图名，加反引号，合理报错
CREATE or replace VIEW `reuse` AS
SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';