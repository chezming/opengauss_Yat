-- @testpoint: 三权分立关闭时验证超级用户可以查询用户私有模式下的全局临时表(超级用户为sysadmin权限，访问auditadmin用户创建的全局临时表)

--step1: 查询三权分立参数enableSeparationOfDuty; expect:显示默认值off
show enableSeparationOfDuty;

--step2: 创建用户; expect:成功
drop user if exists u_selectprivilege_0020;
drop user if exists u_selectprivilege_0020_1;
create user u_selectprivilege_0020  auditadmin  password 'test@123';
create user u_selectprivilege_0020_1  sysadmin   password 'test@123';

--step3: 切换auditadmin用户创建全局临时表并向表中插入数据; expect:成功
set role u_selectprivilege_0020 password 'test@123';
select current_user;
create temp table t_selectprivilege_0020(id int,name varchar(100));
insert into t_selectprivilege_0020 values(1,'beijing'),(2,'shanghai');

--step4: 重置当前用户; expect:重置成功
reset role;
select current_user;

--step5: 切换超级sysadmin权限用户查询全局临时表; expect:查询结果与插入数据一致
set role u_selectprivilege_0020_1 password 'test@123';
select current_user;
select * from  t_selectprivilege_0020;

--step6: 重置当前用户; expect:重置成功
reset role;
select current_user;

--step7: 清理环境; expect:环境清理成功
drop table t_selectprivilege_0020 cascade;
drop user u_selectprivilege_0020 cascade;
drop user u_selectprivilege_0020_1 cascade;