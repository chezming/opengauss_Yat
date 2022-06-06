-- @testpoint: 不支持基表依赖外部复合类型的闪回,合理报错

--step1: 查询enable_recyclebin默认值; expect:显示默认值off
show enable_recyclebin;

--step2: 修改enable_recyclebin为on; expect:修改成功
alter system set enable_recyclebin to on;
select pg_sleep(2);
show enable_recyclebin;

--step3: 清空回收站; expect:回收站清空成功
drop table if exists t_timecapsule_0020_01 ;
drop table if exists t_timecapsule_0020_02 ;
purge recyclebin;

--step4: 创建复合类型; expect:创建成功
create type type_timecapsule_0020 as (a int, b int);

--step5: 创建表; expect:表创建成功
create table t_timecapsule_0020_01(a int, b type_timecapsule_0020);
create table t_timecapsule_0020_02(a int, b int);

--step6: 删除表1; expect:删除成功
drop table t_timecapsule_0020_01;

--step7: 删除表2; expect:删除成功
drop table t_timecapsule_0020_02;

--step8: 对表1执行闪回drop; expect:闪回失败合理报错
timecapsule table t_timecapsule_0020_01 to before drop;

--step9: 对表1执行闪回drop; expect:闪回成功
timecapsule table t_timecapsule_0020_02 to before drop;

--step10: 查询闪回后的表数据; expect:查询结果为空与预期结果一致
select * from t_timecapsule_0020_02;

--step11: 在回收站中截取原始对象名称; expect:截取结果为空
select substr(rcyoriginname, 1, 9) rcyoriginname, rcyoperation, rcytype, rcycanrestore, rcycanpurge from gs_recyclebin order by rcyrelid;

--step12: 删除表及符合类型; expect:删除表1合理报错，表2与复合类型删除成功
drop table t_timecapsule_0020_01;
drop table t_timecapsule_0020_02;
drop type type_timecapsule_0020;

--step13: 清空回收站; expect:回收站清空成功
purge recyclebin;

--step14: 在回收站中截取原始对象名称; expect:截取结果为空
select substr(rcyoriginname, 1, 9) rcyoriginname, rcyoperation, rcytype, rcycanrestore, rcycanpurge from gs_recyclebin order by rcyrelid;

--step15: 清理环境; expect:清理成功
drop table if exists t_timecapsule_0020_01 purge;
drop table if exists t_timecapsule_0020_02 purge;

--step16: 恢复默认值; expect:默认值恢复成功
alter system set enable_recyclebin to off;
select pg_sleep(2);
show enable_recyclebin;