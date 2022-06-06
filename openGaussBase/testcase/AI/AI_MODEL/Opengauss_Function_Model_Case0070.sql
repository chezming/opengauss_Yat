-- @testpoint: logistic_regression创建mode带超参seed最大值,超参seed最小值0（代表随机值)

--step1: 建表并插入数据;expect: 建表并插入数据成功
drop table if exists t_model_tab_0070;
create table t_model_tab_0070(id integer not null,second_attack integer,treatment integer,trait_anxiety integer );
insert into t_model_tab_0070 values (1,1,1,70),(2,1,1,80),(3,1,1,50),(4,1,0,60),(5,1,0,40),(6,1,0,65),(7,1,0,75),(8,1,0,80),(9,1,0,70),(10,1,0,60),(11,0,1,65),(12,0,1,50),(13,0,1,45),(14,0,1,35),(15,0,1,40),(16,0,1,50),(17,0,0,55),(18,0,0,45),(19,0,0,50),(20,0,0,60);

--step2: logistic_regression创建mode带超参seed最大值;expect: 创建成功
create model m_model_seed_max_0070 using logistic_regression features treatment,trait_anxiety target second_attack from t_model_tab_0070  with seed=2147483647;

--step3: 查找系统表;expect: 返回创建model的modelname值m_model_seed_max_0070
select modelname from gs_model_warehouse;

--step4: logistic_regression创建mode带超参seed最小值;expect: 创建成功
create model m_model_seed_min_0070  using logistic_regression features treatment,trait_anxiety target second_attack from t_model_tab_0070  with seed=0;

--step5: 查找系统表;expect: 返回创建model的modelname值m_model_seed_min_0070
select modelname from gs_model_warehouse order by modelname;

--step6: 清理环境;expext: 清理成功
drop table t_model_tab_0070;
drop model m_model_seed_max_0070;
drop model m_model_seed_min_0070;