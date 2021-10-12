--  @testpoint:opengauss关键字returned_sqlstate非保留)，作为序列名
--关键字不带引号-成功
drop sequence if exists returned_sqlstate;
create sequence returned_sqlstate start 100 cache 50;

--清理环境
drop sequence returned_sqlstate;

--关键字带双引号-成功
drop sequence if exists "returned_sqlstate";
create sequence "returned_sqlstate" start 100 cache 50;

--清理环境
drop sequence "returned_sqlstate";

--关键字带单引号-合理报错
drop sequence if exists 'returned_sqlstate';

--关键字带反引号-合理报错
drop sequence if exists `returned_sqlstate`;
