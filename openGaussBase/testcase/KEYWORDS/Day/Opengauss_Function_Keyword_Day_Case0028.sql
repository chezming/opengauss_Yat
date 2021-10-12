-- @testpoint: opengauss关键字day(非保留)，作为同义词对象名，部分测试点合理报错


--前置条件
drop table if exists day_test;
create table day_test(id int,name varchar(10));

--关键字不带引号-成功
drop synonym if exists day;
create synonym day for day_test;
insert into day values (1,'ada'),(2, 'bob');
update day set day.name='cici' where day.id=2;
select * from day;
drop synonym if exists day;

--关键字带双引号-成功
drop synonym if exists "day";
create synonym "day" for day_test;
drop synonym if exists "day";

--关键字带单引号-合理报错
drop synonym if exists 'day';
create synonym 'day' for day_test;
insert into 'day' values (1,'ada'),(2, 'bob');
update 'day' set 'day'.name='cici' where 'day'.id=2;
select * from 'day';

--关键字带反引号-合理报错
drop synonym if exists `day`;
create synonym `day` for day_test;
insert into `day` values (1,'ada'),(2, 'bob');
update `day` set `day`.name='cici' where `day`.id=2;
select * from `day`;
drop table if exists day_test;