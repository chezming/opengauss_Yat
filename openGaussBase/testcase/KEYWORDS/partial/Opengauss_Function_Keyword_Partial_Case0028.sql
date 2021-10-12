-- @testpoint: opengauss关键字partial(非保留)，作为同义词对象名,部分测试点合理报错


--前置条件
drop table if exists partial_test;
create table partial_test(id int,name varchar(10));

--关键字不带引号-成功
drop synonym if exists partial;
create synonym partial for partial_test;
insert into partial values (1,'ada'),(2, 'bob');
update partial set partial.name='cici' where partial.id=2;
select * from partial;

--关键字带双引号-成功
drop synonym if exists "partial";
create synonym "partial" for partial_test;


--关键字带单引号-合理报错
drop synonym if exists 'partial';
create synonym 'partial' for partial_test;
insert into 'partial' values (1,'ada'),(2, 'bob');
update 'partial' set 'partial'.name='cici' where 'partial'.id=2;
select * from 'partial';

--关键字带反引号-合理报错
drop synonym if exists `partial`;
create synonym `partial` for partial_test;
insert into `partial` values (1,'ada'),(2, 'bob');
update `partial` set `partial`.name='cici' where `partial`.id=2;
select * from `partial`;
--清理环境
drop synonym if exists "partial";
drop synonym if exists partial;
drop table if exists partial_test;