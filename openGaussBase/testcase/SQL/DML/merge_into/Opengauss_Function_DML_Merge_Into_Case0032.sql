-- @testpoint: when not matched中insert子句包含多个values，进行merge into操作,合理报错
--step1: 创建目标表和源表并插入数据; expect: 成功
drop table if exists t_mergeinto_32_01;
drop table if exists t_mergeinto_32_02;
create table t_mergeinto_32_01(product_id integer,product_name varchar2(60),
category varchar2(60));
insert into t_mergeinto_32_01 values (1501, 'vivitar 35mm', 'electrncs');
insert into t_mergeinto_32_01 values (1502, 'olympus is50', 'electrncs');
insert into t_mergeinto_32_01 values (1600, 'play gym', 'toys');
insert into t_mergeinto_32_01 values (1601, 'lamaze', 'toys');
insert into t_mergeinto_32_01 values (1666, 'harry potter', 'dvd');
create table t_mergeinto_32_02(product_id integer,product_name varchar2(60),
category varchar2(60),product_amount integer);
insert into t_mergeinto_32_02 values (1502, 'olympus camera', 'electrncs');
insert into t_mergeinto_32_02 values (1601, 'lamaze', 'toys',100);
insert into t_mergeinto_32_02 values (1666, 'harry potter', 'toys',10);
insert into t_mergeinto_32_02 values (1700, 'wait interface', 'books');
--step2: 进行merge into 操作 ;expect: 失败
merge into t_mergeinto_32_01 t1  using t_mergeinto_32_02 t2
on (t1.product_name = t2.product_name)
when not matched then
  update set t1.product_id = t2.product_id, t1.category = t2.category
  where t1.product_name != 'play gym'
when matched then
  insert values (t2.product_id, t2.product_name, t2.category,t2.product_amount)
  where t2.category = 'books';
--step3: 查询结果不变 ;expect: 成功
select * from t_mergeinto_32_01 order by product_id;
--step4: 清理环境删除表  ;expect: 成功
drop table t_mergeinto_32_01;
drop table t_mergeinto_32_02;