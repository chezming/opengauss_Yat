-- @testpoint: opengauss关键字transactions_committed(非保留)，作为同义词对象名,部分测试点合理报错


--前置条件
drop table if exists explain_test;
create table explain_test(id int,name varchar(10));

--关键字不带引号-成功
drop synonym if exists transactions_committed;
create synonym transactions_committed for explain_test;
insert into transactions_committed values (1,'ada'),(2, 'bob');
update transactions_committed set transactions_committed.name='cici' where transactions_committed.id=2;
select * from transactions_committed;
drop synonym if exists transactions_committed;

--关键字带双引号-成功
drop synonym if exists "transactions_committed";
create synonym "transactions_committed" for explain_test;
drop synonym if exists "transactions_committed";

--关键字带单引号-合理报错
drop synonym if exists 'transactions_committed';
create synonym 'transactions_committed' for explain_test;
insert into 'transactions_committed' values (1,'ada'),(2, 'bob');
update 'transactions_committed' set 'transactions_committed'.name='cici' where 'transactions_committed'.id=2;
select * from 'transactions_committed';

--关键字带反引号-合理报错
drop synonym if exists `transactions_committed`;
create synonym `transactions_committed` for explain_test;
insert into `transactions_committed` values (1,'ada'),(2, 'bob');
update `transactions_committed` set `transactions_committed`.name='cici' where `transactions_committed`.id=2;
select * from `transactions_committed`;

--清理环境
drop table if exists explain_test;