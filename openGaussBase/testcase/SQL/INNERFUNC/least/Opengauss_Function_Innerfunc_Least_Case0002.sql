-- @testpoint: 入参为least函数
select least(56,89,least(34,23)) from sys_dummy;
select least(89,least(34,323),least(34343,3243,3434,43215,3)) from sys_dummy;