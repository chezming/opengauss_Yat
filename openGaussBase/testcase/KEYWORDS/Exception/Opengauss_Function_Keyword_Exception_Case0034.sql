-- @testpoint: opengauss关键字exception(非保留)，作为游标名 合理报错

--前置条件
drop table if exists exception_test cascade;
create table exception_test(cid int,fid int);

--关键字不带引号-成功
start transaction;
cursor exception for select * from exception_test order by 1;
close exception;
end;

--关键字带双引号-成功
start transaction;
cursor "exception" for select * from exception_test order by 1;
close "exception";
end;

--关键字带单引号-合理报错
start transaction;
cursor 'exception' for select * from exception_test order by 1;
close 'exception';
end;

--关键字带反引号-合理报错
start transaction;
cursor `exception` for select * from exception_test order by 1;
close `exception`;
end;

--清理环境
drop table if exists exception_test;