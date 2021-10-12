-- @testpoint: opengauss关键字database(非保留)，作为同义词对象名，部分测试点合理报错


--前置条件
drop table if exists database_test;
create table database_test(id int,name varchar(10));

--关键字不带引号-成功
drop synonym if exists database;
create synonym database for database_test;
insert into database values (1,'ada'),(2, 'bob');
update database set database.name='cici' where database.id=2;
select * from database;
drop synonym if exists database;

--关键字带双引号-成功
drop synonym if exists "database";
create synonym "database" for database_test;
drop synonym if exists "database";

--关键字带单引号-合理报错
drop synonym if exists 'database';
create synonym 'database' for database_test;
insert into 'database' values (1,'ada'),(2, 'bob');
update 'database' set 'database'.name='cici' where 'database'.id=2;
select * from 'database';

--关键字带反引号-合理报错
drop synonym if exists `database`;
create synonym `database` for database_test;
insert into `database` values (1,'ada'),(2, 'bob');
update `database` set `database`.name='cici' where `database`.id=2;
select * from `database`;
drop table if exists database_test;