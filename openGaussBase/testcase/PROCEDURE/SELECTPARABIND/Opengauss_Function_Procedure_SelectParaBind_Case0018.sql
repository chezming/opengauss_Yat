-- @testpoint: select语句参数值和列名相同，into的应该是参数值，而不是表的数据

--创建测试表
drop table if exists testauto;
create table testauto(id int primary key,c_varchar varchar(20),rootid date);
insert into testauto(id,c_varchar,rootid) values (100,'agjdfojpjpwqi&*22i',to_date('2020-11-24 13:14:15', 'yyyy-mm-dd hh24:mi:ss'));

--创建存储过程
create or replace procedure pro_018()
as
    sqlstat varchar(500);
	v1 varchar(10);
	v2 varchar(10);
	v3 varchar(10);
	r1 varchar(20);
	r2 varchar(20);
	r3 varchar(20);
begin
    v1 := 'id';
    v2 := 'c_varchar';
    v3 := 'rootid';
    sqlstat := 'select :p1,:p2,:p3 from testauto';
    execute immediate sqlstat into r1,r2,r3 using v1,v2,v3;
    raise info 'result:%',r1;
    raise info  'result:%',r2;
    raise info  'result:%',r3;
end;
/
--调用存储过程
call pro_018();

--清理环境
drop procedure pro_018;
drop table if exists testauto;