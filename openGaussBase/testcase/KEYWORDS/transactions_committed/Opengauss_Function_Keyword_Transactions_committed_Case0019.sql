--  @testpoint:opengauss关键字transactions_committed(非保留)，作为外部数据源名

--关键字不带引号-成功
drop data source if exists transactions_committed;
create data source transactions_committed;
drop data source transactions_committed;

--关键字带双引号-成功
drop data source if exists "transactions_committed";
create data source "transactions_committed";
drop data source "transactions_committed";

--关键字带单引号-合理报错
drop data source if exists 'transactions_committed';
create data source 'transactions_committed';

--关键字带反引号-合理报错
drop data source if exists `transactions_committed`;
create data source `transactions_committed`;
