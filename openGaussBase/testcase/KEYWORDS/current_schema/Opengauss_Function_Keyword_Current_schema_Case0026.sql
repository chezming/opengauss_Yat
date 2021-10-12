--  @testpoint:opengauss关键字current_schema(保留)，作为模式名

--关键字不带引号-合理报错
drop schema if exists current_schema;
create schema current_schema;

--关键字带双引号-成功
drop schema if exists "current_schema";
create schema "current_schema";

--清理环境
drop schema "current_schema";

--关键字带单引号-合理报错
drop schema if exists 'current_schema';
create schema 'current_schema';

--关键字带反引号-合理报错
drop schema if exists `current_schema`;
create schema `current_schema`;

