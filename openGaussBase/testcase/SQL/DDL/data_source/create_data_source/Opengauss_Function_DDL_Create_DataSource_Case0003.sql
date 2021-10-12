--  @testpoint:创建数据源对象，Data Source名称符合标识符的命名规范
--创建数据源对象，不含任何信息，名称以下划线开头
DROP DATA SOURCE if exists _ds_test1$;
CREATE DATA SOURCE _ds_test1$;
--查询创建的数据源对象信息
select srcname,srctype,srcversion,srcacl,srcoptions from PG_EXTENSION_DATA_SOURCE where srcname = '_ds_test1$';
--创建数据源对象，Data Source名称不符合标识符的命名规范，合理报错
CREATE DATA SOURCE *#ds_test1;
--删除创建的数据源对象
DROP DATA SOURCE _ds_test1$;