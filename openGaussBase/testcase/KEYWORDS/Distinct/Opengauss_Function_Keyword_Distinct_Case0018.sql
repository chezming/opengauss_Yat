--  @testpoint:opengauss关键字distinct(保留)，作为数据库名

--关键字不带引号-失败
drop database if exists distinct;
create database distinct;

--关键字带双引号-成功
drop database if exists "distinct";
create database "distinct";
drop database "distinct";

--关键字带单引号-合理报错
drop database if exists 'distinct';
create database 'distinct';

--关键字带反引号-合理报错
drop database if exists `distinct`;
create database `distinct`;
