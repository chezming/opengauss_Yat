-- @testpoint: EXTRACT(field FROM source)函数从时间戳里获取世纪的值
--（field的取值范围：century）
select extract(century from timestamp '2000-12-16 12:21:13') from sys_dummy;
















