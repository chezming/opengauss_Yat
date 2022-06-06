-- @testpoint: kmeans创建mode，带正确的超参istance_function

--step1: 创建表并插入数据;expect: 创建表并插入数据成功
drop table if exists t_model_tab_0044;
create table t_model_tab_0044(id integer not null,"position" double precision[] not null,closest_centroid integer not null, l1_distance double precision not null, l2_distance double precision not null,l2_squared_distance double precision not null,linf_distance double precision not null );
insert into t_model_tab_0044 values (214,'{82.2331969052000034,52.153098620199998,64.0344866000999933,-.325498644699999981,-64.6012144075999947,81.5499670644999952,59.6012626708999989}',3,10.0679804558999992,4.35061551650000012,18.9278551126999999,2.38445523010000019);

--step2: kmeans创建mode带正确的超参istance_function;expect: 创建成功
create model m_model_kmeans_istance_function_0044 using kmeans from (select position from t_model_tab_0044 ) with num_features = 7,distance_function='L2_Squared';

--step3: 查询系统表中的 hyperparametersvalues;expect: 返回的内容中含设置的distance_function方法L2_Squared
select hyperparametersvalues from gs_model_warehouse where modelname='m_model_kmeans_istance_function_0044';

--step4: 清理环境;expext: 清理成功
drop table t_model_tab_0044;
drop model m_model_kmeans_istance_function_0044;