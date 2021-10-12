--  @testpoint:opengauss关键字character_set_name(非保留)，作为函数名
--关键字不带引号-成功
drop function if exists character_set_name;
create function character_set_name(i integer)
returns integer
as $$
begin
    return i+1;
end;
$$ language plpgsql;
/
--清理环境
drop function character_set_name;

--关键字带双引号-成功
drop function if exists "character_set_name";
create function "character_set_name"(i integer)
returns integer
as $$
begin
    return i+1;
end;
$$ language plpgsql;
/
--清理环境
drop function "character_set_name";

--关键字带单引号-合理报错
drop function if exists 'character_set_name';
create function 'character_set_name'(i integer)
returns integer
as $$
begin
    return i+1;
end;
$$ language plpgsql;
/

--关键字带反引号-合理报错
drop function if exists `character_set_name`;
create function `character_set_name`(i integer)
returns integer
as $$
begin
    return i+1;
end;
$$ language plpgsql;
/