-- @testpoint: 无输入，无效参数(合理报错)


select atan2('','') from sys_dummy;
select atan2(null,null) from sys_dummy;

select atan2(,) from sys_dummy;
select atan2('11+11',) from sys_dummy;
select atan2(11 11) from sys_dummy;
select atan2(22,) from sys_dummy;
