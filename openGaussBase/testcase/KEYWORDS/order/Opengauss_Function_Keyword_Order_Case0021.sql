--  @testpoint:opengauss关键字order(保留)，作为函数名

--关键字不带引号-合理报错
create function order(i integer)
returns integer
as $$
begin
    return i+1;
end;
$$ language plpgsql;
/

--关键字带双引号-成功
create function "order"(i integer)
returns integer
as $$
begin
    return i+1;
end;
$$ language plpgsql;
/

--清理环境
drop function "order";

--关键字带单引号-合理报错
create function 'order'(i integer)
returns integer
as $$
begin
    return i+1;
end;
$$ language plpgsql;
/

--关键字带反引号-合理报错
drop function if exists `order`;
create function `order`(i integer)
returns integer
as $$
begin
    return i+1;
end;
$$ language plpgsql;
/