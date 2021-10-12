-- @testpoint: opengauss关键字boolean(非保留)，作为同义词对象名，部分测试点合理报错
--前置条件
drop table if exists boolean_test;
create table boolean_test(id int,name varchar(10));

--关键字不带引号-成功
drop synonym if exists boolean;
create synonym boolean for boolean_test;
insert into boolean values (1,'ada'),(2, 'bob');
update boolean set boolean.name='cici' where boolean.id=2;
select * from boolean;

--清理环境
drop synonym if exists boolean;

--关键字带双引号-成功
drop synonym if exists "boolean";
create synonym "boolean" for boolean_test;
insert into "boolean" values (1,'ada'),(2, 'bob');
update "boolean" set "boolean".name='cici' where "boolean".id=2;
select * from "boolean";

--清理环境
drop synonym if exists "boolean";

--关键字带单引号-合理报错
drop synonym if exists 'boolean';

--关键字带反引号-合理报错
drop synonym if exists `boolean`;
drop table if exists boolean_test;