-- @testpoint: 在非篡改模式下修复指定防篡改用户表对应的用户历史表hash值，插入数据（合理报错）

--step1：建模式建表;expect:成功
drop schema if exists s_ledger_database_0039;
create schema s_ledger_database_0039;
drop table if exists s_ledger_database_0039.t_ledger_database_0039;
create table s_ledger_database_0039.t_ledger_database_0039(id int, name text);
--step2：插入数据;expect:成功
insert into s_ledger_database_0039.t_ledger_database_0039 values(1, 'alex'), (2, 'bob'), (3, 'peter');
--step3：调用函数在非篡改模式下修复指定防篡改用户表对应的用户历史表hash值，插入数据;expect:失败
select pg_catalog.ledger_hist_repair('s_ledger_database_0039','t_ledger_database_0039');
--step4：删除表;expect:成功
drop table s_ledger_database_0039.t_ledger_database_0039;
drop schema s_ledger_database_0039 cascade;