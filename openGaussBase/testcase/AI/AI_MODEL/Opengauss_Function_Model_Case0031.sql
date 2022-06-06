-- @testpoint: logistic_regression创建mode,带正确的超参optimizer

--step1: 创建表并插入数据;expect: 创建表并插入数据成功
drop table if exists t_model_tab_0031;
create table t_model_tab_0031(id integer not null,second_attack integer,treatment integer,trait_anxiety integer );
insert into t_model_tab_0031 values (1,1,1,70),(2,1,1,80),(3,1,1,50),(4,1,0,60),(5,1,0,40),(6,1,0,65),(7,1,0,75),(8,1,0,80),(9,1,0,70),(10,1,0,60),(11,0,1,65),(12,0,1,50),(13,0,1,45),(14,0,1,35),(15,0,1,40),(16,0,1,50),(17,0,0,55),(18,0,0,45),(19,0,0,50),(20,0,0,60);

--step2: logistic_regression创建mode,带正确的超参optimizer;expect: 创建成功
create model m_model_features_optimizer_0031 using logistic_regression features treatment, trait_anxiety target second_attack from t_model_tab_0031 with optimizer='ngd';

create model m_model_features_optimizer1_0031 using logistic_regression features treatment, trait_anxiety target second_attack from t_model_tab_0031 with optimizer='gd';

--step3: 查询系统表中的 hyperparametersvalues;expect: 返回的内容中包含超参的取值
select hyperparametersvalues from gs_model_warehouse where modelname='m_model_features_optimizer_0031';

select hyperparametersvalues from gs_model_warehouse where modelname='m_model_features_optimizer1_0031';

--step4: 清理环境;expect: 清理环境成功
drop table t_model_tab_0031;
drop model m_model_features_optimizer_0031;
drop model m_model_features_optimizer1_0031;