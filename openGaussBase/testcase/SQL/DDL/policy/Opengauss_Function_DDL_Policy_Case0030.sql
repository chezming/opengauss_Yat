--  @testpoint:创建行访问控制策略，指定行访问控制SQL操作为insert（行存表）,合理报错
--创建行存表test_policy
drop table if exists test_policy cascade;
create table test_policy(id int,usr name);
--插入数据
insert into test_policy(id, usr) values(1, 's_usr1');
insert into test_policy(id, usr) values(2, 's_usr2');
insert into test_policy(id, usr) values(3, 's_usr2');
insert into test_policy(id, usr) values(4, 's_usr2');
insert into test_policy(id, usr) values(5, 's_usr1');
insert into test_policy(id, usr) values(5, 's_usr3');
--打开行级安全检查
ALTER TABLE test_policy ENABLE ROW LEVEL SECURITY;
--创建测试用户
drop user if exists s_usr1 cascade;
create user s_usr1 password 'Test@123';
drop user if exists s_usr2 cascade;
create user s_usr2 password 'Test@123';
drop user if exists s_usr3 cascade;
create user s_usr3 password 'Test@123';
--授予用户表的select,insert权限
grant select,insert on test_policy to s_usr1,s_usr2,s_usr3;
--创建策略,指定行访问控制影响的数据库用户为public,sql操作为insert,合理报错，INSERT策略不能具有using_expression
drop POLICY if exists pol1 ON test_policy;
CREATE POLICY pol1 ON test_policy FOR insert TO PUBLIC USING (usr = current_user);
--删除表
drop table test_policy;
--删除用户
drop user if exists s_usr1 cascade;
drop user if exists s_usr2 cascade;
drop user if exists s_usr3 cascade;