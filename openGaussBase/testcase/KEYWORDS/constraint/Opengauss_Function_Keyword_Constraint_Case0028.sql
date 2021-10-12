-- @testpoint: opengauss关键字constraint(保留)，作为同义词对象名，部分测试点合理报错


--前置条件
drop table if exists constraint_test;
create table constraint_test(id int,name varchar(10));

--关键字不带引号-失败
drop synonym if exists constraint;
create synonym constraint for constraint_test;


--关键字带双引号-成功
drop synonym if exists "constraint";
create synonym "constraint" for constraint_test;
insert into "constraint" values (1,'ada'),(2, 'bob');
update "constraint" set "constraint".name='cici' where "constraint".id=2;
select * from "constraint";

--清理环境
drop synonym "constraint";

--关键字带单引号-合理报错
drop synonym if exists 'constraint';
create synonym 'constraint' for constraint_test;
insert into 'constraint' values (1,'ada'),(2, 'bob');
update 'constraint' set 'constraint'.name='cici' where 'constraint'.id=2;
select * from 'constraint';

--关键字带反引号-合理报错
drop synonym if exists `constraint`;
create synonym `constraint` for constraint_test;
insert into `constraint` values (1,'ada'),(2, 'bob');
update `constraint` set `constraint`.name='cici' where `constraint`.id=2;
select * from `constraint`;

--清理环境
drop table if exists constraint_test;