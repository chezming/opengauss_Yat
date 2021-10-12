--  @testpoint:opengauss关键字binary_integer(非保留)，作为用户名
--关键字binary_integer作为用户名不带引号，创建成功
drop user if exists binary_integer;
CREATE USER binary_integer PASSWORD 'Bigdata@123';

--清理环境
drop user binary_integer;

--关键字binary_integer作为用户名加双引号，创建成功
drop user if exists "binary_integer";
CREATE USER "binary_integer" PASSWORD 'Bigdata@123';

--清理环境
drop user "binary_integer";

--关键字binary_integer作为用户名加单引号，合理报错
CREATE USER 'binary_integer' PASSWORD 'Bigdata@123';

--关键字binary_integer作为用户名加反引号，合理报错
CREATE USER `binary_integer` PASSWORD 'Bigdata@123';
