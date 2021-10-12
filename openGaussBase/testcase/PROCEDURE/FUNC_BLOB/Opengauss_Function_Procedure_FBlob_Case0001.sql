-- @testpoint: 自定义函数blob数据类型的测试-测试blob类型为空

--创建自定义函数
create or replace function fvt_proc_blob_001(v1 blob) return varchar
is
v2 varchar(200);
begin
  if v1 is null
  then
    v2:='v1 is null';
  else
    v2:='v1 is not null';
  end if;
    return v2;
end;
/
--调用自定义函数
select fvt_proc_blob_001('');

--恢复环境
drop function if exists fvt_proc_blob_001;
