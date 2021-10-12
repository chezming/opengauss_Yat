-- @testpoint: opengauss关键字returned_octet_length非保留)，作为索引名，部分测试点合理报错

--前置条件，创建一个表
drop table if exists returned_octet_length_test;
create table returned_octet_length_test(id int,name varchar(10));

--关键字不带引号-成功
drop index if exists returned_octet_length;
create index returned_octet_length on returned_octet_length_test(id);
drop index returned_octet_length;

--关键字带双引号-成功
drop index if exists "returned_octet_length";
create index "returned_octet_length" on returned_octet_length_test(id);
drop index "returned_octet_length";

--关键字带单引号-合理报错
drop index if exists 'returned_octet_length';


--关键字带反引号-合理报错
drop index if exists `returned_octet_length`;
drop table if exists returned_octet_length_test;
