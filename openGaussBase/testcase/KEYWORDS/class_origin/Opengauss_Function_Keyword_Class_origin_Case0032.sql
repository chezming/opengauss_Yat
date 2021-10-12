--  @testpoint:opengauss关键字class_origin(非保留)，作为用户名
--关键字class_origin作为用户名不带引号，创建成功
drop user if exists class_origin;
CREATE USER class_origin PASSWORD 'Bigdata@123';

--清理环境
drop user class_origin;

--关键字class_origin作为用户名加双引号，创建成功
drop user if exists "class_origin";
CREATE USER "class_origin" PASSWORD 'Bigdata@123';

--清理环境
drop user "class_origin";

--关键字class_origin作为用户名加单引号，合理报错
CREATE USER 'class_origin' PASSWORD 'Bigdata@123';

--关键字class_origin作为用户名加反引号，合理报错
CREATE USER `class_origin` PASSWORD 'Bigdata@123';
