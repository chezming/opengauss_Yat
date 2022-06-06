-- @testpoint: pg_stat_get_wlm_session_info(int flag),获取当前内存中记录的TopSQL查询语句级别相关统计信息，入参为有效值时

----step1：开启资源管理功能; expect:成功
alter system set use_workload_manager to on;

----step2：参数生效略有延迟，等待始参数生效; expect:成功
select pg_sleep(3);

----step3：入参为有效值时; expect:成功
select pg_stat_get_wlm_session_info(0);
select pg_stat_get_wlm_session_info(1);

----step4：关闭资源管理功能; expect:成功
alter system set use_workload_manager to off;

----step5：参数生效略有延迟，等待始参数生效; expect:成功
select pg_sleep(3);