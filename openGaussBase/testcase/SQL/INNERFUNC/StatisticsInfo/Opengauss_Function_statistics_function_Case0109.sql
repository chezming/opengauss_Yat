-- @testpoint: pg_stat_get_db_cu_hdd_asyn(oid) 入参为有效值

----step1：入参为有效值; expect:成功
select pg_stat_get_db_cu_hdd_asyn(a.oid) from pg_database a where a.datname = 'postgres';