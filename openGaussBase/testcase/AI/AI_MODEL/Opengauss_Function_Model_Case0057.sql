-- @testpoint: logistic_regression创建mode带超参max_iterations最大值和最小值

--step1: 建表并插入数据;expect: 建表并插入数据成功
drop table if exists t_model_tab_0057;
create table t_model_tab_0057(id integer not null,"position" double precision[] not null,closest_centroid integer not null,l1_distance double precision not null,l2_distance double precision not null,l2_squared_distance double precision not null,linf_distance double precision not null );
insert into t_model_tab_0057 values (214,'{82.2331969052000034,52.153098620199998,64.0339865700999933,-.325498639699999981,-64.5712142075799947,81.5499670644999952,57.5712626708999989}',3,10.0679804578999992,4.35061571650000012,18.9278571126999999,2.38415523010000019);

--step2: logistic_regression创建mode带超参max_iterations最大值;expect: 创建成功
create model m_model_max_iterations_0057 using kmeans from(select position from t_model_tab_0057) with max_iterations=10000,num_features = 7;

--step3: 查找系统表;expect: 返回创建的model m_model_max_iterations_0057
select modelname from gs_model_warehouse;

--step4: logistic_regression创建mode带超参max_iterations最小值;expect: 创建成功
create model m_model_min_iterations1_0057 using kmeans from( select position from  t_model_tab_0057  ) with max_iterations=1,num_features = 7;

--step5: 查找系统表;expect: 返回创建的model m_model_min_iterations1_0057
select modelname from gs_model_warehouse order by modelname;

--step6: 清理环境;expext: 清理成功
drop table t_model_tab_0057;
drop model m_model_max_iterations_0057;
drop model m_model_min_iterations1_0057;