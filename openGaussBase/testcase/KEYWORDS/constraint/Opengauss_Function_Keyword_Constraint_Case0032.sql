--  @testpoint:openGauss保留关键字constraint作为 用户名，

--不带引号，合理报错
 CREATE USER constraint PASSWORD 'Bigdata@123';

 --加双引号，创建成功
 drop user if exists "constraint";
 CREATE USER "constraint" PASSWORD 'Bigdata@123';
 
 --清理环境
 drop user "constraint";
 
 --加单引号，合理报错
 CREATE USER 'constraint' PASSWORD 'Bigdata@123';
  
 --加反引号，合理报错
 CREATE USER `constraint` PASSWORD 'Bigdata@123';