--  @testpoint:opengauss关键字close(非保留)，作为存储过程名
--关键字不带引号-成功
create or replace procedure close() is
V1 BLOB;
begin
  IF V1 is NULL then
  raise info 'V1 is NULL';
  else
  raise info 'V1 is not NULL';
  end if;
end;
/
--清理环境
DROP procedure close;

--关键字带双引号-成功
create or replace procedure "close"() is
V1 BLOB;
begin
  IF V1 is NULL then
  raise info 'V1 is NULL';
  else
  raise info 'V1 is not NULL';
  end if;
end;
/
--清理环境
drop procedure "close";

--关键字带单引号-合理报错
create or replace procedure 'close'() is
V1 BLOB;
begin
  IF V1 is NULL then
  raise info 'V1 is NULL';
  else
  raise info 'V1 is not NULL';
  end if;
end;
/

--关键字带反引号-合理报错
create or replace procedure `close`() is
V1 BLOB;
begin
  IF V1 is NULL then
  raise info 'V1 is NULL';
  else
  raise info 'V1 is not NULL';
  end if;
end;
/
