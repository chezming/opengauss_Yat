--  @testpoint:opengauss关键字returned_length非保留)，作为序列名


--关键字不带引号-成功
drop sequence if exists returned_length;
create sequence returned_length start 100 cache 50;
drop sequence returned_length;

--关键字带双引号-成功
drop sequence if exists "returned_length";
create sequence "returned_length" start 100 cache 50;
drop sequence "returned_length";

--关键字带单引号-合理报错
drop sequence if exists 'returned_length';

--关键字带反引号-合理报错
drop sequence if exists `returned_length`;

