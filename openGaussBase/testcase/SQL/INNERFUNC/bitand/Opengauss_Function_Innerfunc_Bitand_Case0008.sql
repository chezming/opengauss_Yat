-- @testpoint: 函数自身嵌套

select bitand(bitand(6,3),bitand(15,3)) as result from sys_dummy;
