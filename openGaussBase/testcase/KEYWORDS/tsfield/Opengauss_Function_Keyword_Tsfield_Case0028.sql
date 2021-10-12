-- @testpoint: opengauss关键字tsfield(非保留)，作为同义词对象名,部分测试点合理报错


--前置条件
drop table if exists explain_test;
create table explain_test(id int,name varchar(10));

--关键字不带引号-成功
drop synonym if exists tsfield;
create synonym tsfield for explain_test;
insert into tsfield values (1,'ada'),(2, 'bob');
update tsfield set tsfield.name='cici' where tsfield.id=2;
select * from tsfield;
drop synonym if exists tsfield;

--关键字带双引号-成功
drop synonym if exists "tsfield";
create synonym "tsfield" for explain_test;
drop synonym if exists "tsfield";

--关键字带单引号-合理报错
drop synonym if exists 'tsfield';
create synonym 'tsfield' for explain_test;
insert into 'tsfield' values (1,'ada'),(2, 'bob');
update 'tsfield' set 'tsfield'.name='cici' where 'tsfield'.id=2;
select * from 'tsfield';

--关键字带反引号-合理报错
drop synonym if exists `tsfield`;
create synonym `tsfield` for explain_test;
insert into `tsfield` values (1,'ada'),(2, 'bob');
update `tsfield` set `tsfield`.name='cici' where `tsfield`.id=2;
select * from `tsfield`;

--清理环境
drop table if exists explain_test;