-- @testpoint: 函数svals(hstore)，获取hstore中的值.入参为无效值时，合理报错

--当参数非键值对时
select svals('a=>1,b=>2,c=> ');