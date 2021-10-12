-- @testpoint: 数字操作函数，正切函数，浮点数

--创建测试表并插入数据
drop table if exists tan_T2;
create table tan_T2(f1 decimal,f2 number,f3 numeric,f4 BINARY_DOUBLE);
insert into tan_T2(f1,f2,f3,f4) values(55.5,66.6,77.7,321.321);
select tan(f1),tan(f2),tan(f3) from tan_T2;

--清理环境
drop table if exists tan_T2;


