--  @testpoint:opengauss关键字blob非保留)，作为序列名
--关键字不带引号-成功
drop sequence if exists blob;
create sequence blob start 100 cache 50;

--清理环境
drop sequence blob;

--关键字带双引号-成功
drop sequence if exists "blob";
create sequence "blob" start 100 cache 50;

--清理环境
drop sequence "blob";

--关键字带单引号-合理报错
drop sequence if exists 'blob';

--关键字带反引号-合理报错
drop sequence if exists `blob`;
