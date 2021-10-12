--  @testpoint:set session 和set local命令设置配置参数block_size（internal类型），合理报错
--查看block_size的默认值
show block_size;
--set session to命令设置block_size参数，合理报错,为固定参数，用户无法修改此参数，只能查看
set session block_size to 8190;
--set local 命令设置block_size参数，合理报错,为固定参数，用户无法修改此参数，只能查看
set local block_size to 8191;

--set session =命令设置block_size参数，合理报错,为固定参数，用户无法修改此参数，只能查看
set session block_size = 8192;
--set local =命令设置block_size参数，合理报错,为固定参数，用户无法修改此参数，只能查看
set local block_size = 8191;