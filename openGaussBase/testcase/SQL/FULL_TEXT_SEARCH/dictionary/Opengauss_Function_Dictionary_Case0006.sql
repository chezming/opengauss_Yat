--  @testpoint:创建simple词典，且添加option选项
--通过系统表PG_TS_TEMPLATE查看模板名取值范围
select tmplname from PG_TS_TEMPLATE;
--创建字典，模板名为simple,FILEPATH参数和STOPWORDS参数同时指定
DROP TEXT SEARCH DICTIONARY IF EXISTS public.simple_dict;
CREATE TEXT SEARCH DICTIONARY public.simple_dict (
     TEMPLATE = pg_catalog.simple,
     STOPWORDS = english,
     ACCEPT = false
);
--删除词典
DROP TEXT SEARCH DICTIONARY public.simple_dict;