-- @testpoint: opengauss关键字Interval(非保留)，作为存储过程名 合理报错

--关键字不带引号-合理报错
create or replace procedure Interval(p1 integer)
is
c1 varchar(10);
begin
    c1 := 'gauss';
    raise info '-%',c1;
    raise info ':%',p1;
end;
/
--清理环境
drop procedure if exists Interval(p1 integer);

--关键字带双引号-成功
create or replace procedure "Interval"(p1 integer)
is
c1 varchar(10);
begin
    c1 := 'gauss';
    raise info '-%',c1;
    raise info ':%',p1;
end;
/
--清理环境删不掉，暂不删除，需要找开发确认

--关键字带单引号-合理报错
create or replace procedure 'Interval'(p1 integer)
is
c1 varchar(10);
begin
    c1 := 'gauss';
    raise info '-%',c1;
    raise info ':%',p1;
end;
/

--关键字带反引号-合理报错
create or replace procedure `Interval`(p1 integer)
is
c1 varchar(10);
begin
    c1 := 'gauss';
    raise info '-%',c1;
    raise info ':%',p1;
end;
/
--清理环境
drop procedure if exists "Interval"(integer);

