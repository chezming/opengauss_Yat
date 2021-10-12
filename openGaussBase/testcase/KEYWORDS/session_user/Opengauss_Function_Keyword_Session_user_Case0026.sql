--  @testpoint:opengauss关键字session_user(保留)，作为模式名

--关键字不带引号-合理报错
drop schema if exists session_user;
create schema session_user;

--关键字带双引号-成功
drop schema if exists "session_user";
create schema "session_user";

--清理环境
drop schema "session_user";

--关键字带单引号-合理报错
drop schema if exists 'session_user';
create schema 'session_user';

--关键字带反引号-合理报错
drop schema if exists `session_user`;
create schema `session_user`;

