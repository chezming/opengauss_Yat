-- @testpoint: openGauss保留关键字similar作为视图名，合理报错

 --不带引号-合理报错
  CREATE or replace VIEW similar AS
    SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';
	
 --加双引号-创建成功
    CREATE  or replace VIEW "similar" AS
    SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';
	
 --清理环境	
    drop VIEW "similar";
	
 --加单引号-合理报错
 CREATE or replace VIEW 'similar' AS
 SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';
 
 --加反引号-合理报错
 CREATE or replace VIEW `similar` AS
 SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';