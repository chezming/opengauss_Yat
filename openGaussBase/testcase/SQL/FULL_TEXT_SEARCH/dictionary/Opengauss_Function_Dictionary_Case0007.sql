--  @testpoint:创建simple词典后，使用Simple词典
--创建字典，模板名为simple
DROP TEXT SEARCH DICTIONARY IF EXISTS public.simple_dict;
CREATE TEXT SEARCH DICTIONARY public.simple_dict (
     TEMPLATE = pg_catalog.simple,
     STOPWORDS = english
);
--测试一个数据字典，大写转小写
SELECT ts_lexize('public.simple_dict','YeS');
--忽略停用词，返回空数组
SELECT ts_lexize('public.simple_dict','The');
--删除词典
DROP TEXT SEARCH DICTIONARY public.simple_dict;