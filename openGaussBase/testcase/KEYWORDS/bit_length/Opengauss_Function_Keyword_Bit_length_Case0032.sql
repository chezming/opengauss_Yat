--  @testpoint:opengauss关键字bit_length(非保留)，作为用户名
--关键字bit_length作为用户名不带引号，创建成功
drop user if exists bit_length;
CREATE USER bit_length PASSWORD 'Bigdata@123';

--清理环境
drop user bit_length;

--关键字bit_length作为用户名加双引号，创建成功
drop user if exists "bit_length";
CREATE USER "bit_length" PASSWORD 'Bigdata@123';

--清理环境
drop user "bit_length";

--关键字bit_length作为用户名加单引号，合理报错
CREATE USER 'bit_length' PASSWORD 'Bigdata@123';

--关键字bit_length作为用户名加反引号，合理报错
CREATE USER `bit_length` PASSWORD 'Bigdata@123';
