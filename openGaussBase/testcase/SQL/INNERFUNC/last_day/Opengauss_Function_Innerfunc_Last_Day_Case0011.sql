-- @testpoint: 自定义函数中使用last_day函数作为入参
drop function if exists last_day_f001;
create or replace function last_day_f001(a date) return date
as
b date;
c smalldatetime;
begin
	b:= to_timestamp(cast(a as varchar),'YYYY-MM-DD HH24:MI:SS.FFFFFF');
	c:= to_date(cast(a as varchar));
	b:= to_date(cast(a as varchar));
	return last_day(cast(b as varchar));
end;
/
select last_day_f001(last_day('2019-01-03 14:58:54'));
drop function if exists last_day_f001;