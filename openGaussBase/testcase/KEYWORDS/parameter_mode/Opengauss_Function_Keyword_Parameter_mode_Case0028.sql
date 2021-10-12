-- @testpoint: opengauss关键字parameter_mode(非保留)，作为同义词对象名,部分测试点合理报错


--前置条件
drop table if exists explain_test;
create table explain_test(id int,name varchar(10));

--关键字不带引号-成功
drop synonym if exists parameter_mode;
create synonym parameter_mode for explain_test;
insert into parameter_mode values (1,'ada'),(2, 'bob');
update parameter_mode set parameter_mode.name='cici' where parameter_mode.id=2;
select * from parameter_mode;

--关键字带双引号-成功
drop synonym if exists "parameter_mode";
create synonym "parameter_mode" for explain_test;


--关键字带单引号-合理报错
drop synonym if exists 'parameter_mode';
create synonym 'parameter_mode' for explain_test;
insert into 'parameter_mode' values (1,'ada'),(2, 'bob');
update 'parameter_mode' set 'parameter_mode'.name='cici' where 'parameter_mode'.id=2;
select * from 'parameter_mode';

--关键字带反引号-合理报错
drop synonym if exists `parameter_mode`;
create synonym `parameter_mode` for explain_test;
insert into `parameter_mode` values (1,'ada'),(2, 'bob');
update `parameter_mode` set `parameter_mode`.name='cici' where `parameter_mode`.id=2;
select * from `parameter_mode`;
--清理环境
drop synonym if exists "parameter_mode";
drop synonym if exists parameter_mode;
drop table if exists explain_test;