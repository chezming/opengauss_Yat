-- @testpoint: pg_stat_get_backend_idset()描述：设置当前活动的服务器进程数（从1到活动服务器进程的数量）。

select pg_stat_get_backend_idset() limit 3;