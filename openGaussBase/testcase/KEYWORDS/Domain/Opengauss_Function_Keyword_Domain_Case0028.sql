-- @testpoint: opengauss关键字domain(非保留)，作为同义词对象名，部分测试点合理报错


--前置条件
drop table if exists domain_test;
create table domain_test(id int,name varchar(10));

--关键字不带引号-成功
drop synonym if exists domain;
create synonym domain for domain_test;
insert into domain values (1,'ada'),(2, 'bob');
update domain set domain.name='cici' where domain.id=2;
select * from domain;
drop synonym if exists domain;

--关键字带双引号-成功
drop synonym if exists "domain";
create synonym "domain" for domain_test;
drop synonym if exists "domain";

--关键字带单引号-合理报错
drop synonym if exists 'domain';
create synonym 'domain' for domain_test;
insert into 'domain' values (1,'ada'),(2, 'bob');
update 'domain' set 'domain'.name='cici' where 'domain'.id=2;
select * from 'domain';

--关键字带反引号-合理报错
drop synonym if exists `domain`;
create synonym `domain` for domain_test;
insert into `domain` values (1,'ada'),(2, 'bob');
update `domain` set `domain`.name='cici' where `domain`.id=2;
select * from `domain`;
drop table if exists domain_test;