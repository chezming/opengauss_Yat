--  @testpoint:计算时间点d当月最后一天的时间
--获取2020年2月的最后一天时间
select last_day(to_date('2020-02-01', 'YYYY-MM-DD')) AS cal_result;
--获取2020年1月的最后一天时间
select last_day(to_date('2020-01-01', 'YYYY-MM-DD')) AS cal_result;
--获取2020年12月的最后一天时间
select last_day(to_date('2020-12-01', 'YYYY-MM-DD')) AS cal_result;