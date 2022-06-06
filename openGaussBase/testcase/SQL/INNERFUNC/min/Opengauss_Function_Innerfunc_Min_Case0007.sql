-- @testpoint: inet类型网络地址/子网掩码/主机地址组合测试取最小值--ipv6

--step1:创建表; expect:成功
drop table if exists t_min_case0007;
create table t_min_case0007(id int, i inet);

--step2:网络地址/子网掩码相同，主机地址不同; expect:2001:4f8:3:ba::0/64
insert into t_min_case0007 values(1,'2001:4f8:3:ba::1/64'),(2,'2001:4f8:3:ba::0/64');
select min(i) from  t_min_case0007;

--step3:网络地址/子网掩码相同，主机地址相同; expect:1,'2001:4f8:3:ba::1/64'
delete from t_min_case0007;
insert into t_min_case0007 values(1,'2001:4f8:3:ba::1/64'),(2,'2001:4f8:3:ba::1/64');
select min(i) from  t_min_case0007;

--step4:子网掩码不同:网络地址（子网掩码同长度部分相同，不同部分不相同），; expect:'2001:4f8:3:ba::1/64'
delete from t_min_case0007;
insert into t_min_case0007 values(1,'2001:4f8:3:ba::1/64'),(2,'2001:4f8:3:ba:f::0/65');
select min(i) from  t_min_case0007;

--step5:子网掩码不同:网络地址（子网掩码同长度部分不相同），; expect:2001:4f8:3:bb::1/65
delete from t_min_case0007;
insert into t_min_case0007 values(1,'2001:4f8:4::/64'),(2,'2001:4f8:3:bb::1/65');
select min(i) from  t_min_case0007;

--step6:网络地址不同，子网掩码相同，; expect:::2001:4f8:4/127
delete from t_min_case0007;
insert into t_min_case0007 values(1,'::2001:4f8:4/127'),(2,'2001:4f8:4::1/127');
select min(i) from  t_min_case0007;

--step7:网络地址不同，子网掩码不同，主机地址相同; expect:2001:4f8:4:3::1/64
delete from t_min_case0007;
insert into t_min_case0007 values(1,'2001:4f8:4:3::1/64'),(2,'2001:4f8:4:3::1/65');
select min(i) from  t_min_case0007;

--step8:网络地址不同，子网掩码不同，主机地址不相; expect:2001:4f8::4:3:1/66
delete from t_min_case0007;
insert into t_min_case0007 values(1,'2001:4f8::4:3:1/66'),(2,'2001:4f8:4:3::1/65');
select min(i) from  t_min_case0007;

--step9:全1地址与全0地址; expect:::
delete from t_min_case0007;
insert into t_min_case0007 values(1,'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff'),(2,'::');
select min(i) from  t_min_case0007;

--tearDown
drop table if exists t_min_case0007;