-- @testpoint: extract(field from timestamp)从给定的时间戳里获取时间间隔总秒数的值
--（field的取值范围：epoch值为时间日期型）
--如果source为timestamp with time zone，表示自1970-01-01 00:00:00-00 utc以来的秒数（结果可能是负数）
select extract(epoch from timestamp with time zone '2001-02-16 20:38:40.12-08') from sys_dummy;
--如果source为interval，表示时间间隔的总秒数
select extract(epoch from interval '5 days 3 hours') from sys_dummy;
--将epoch值转换为时间戳的方法
select timestamp with time zone 'epoch' + 982384720.12 * interval '1 second' as result;