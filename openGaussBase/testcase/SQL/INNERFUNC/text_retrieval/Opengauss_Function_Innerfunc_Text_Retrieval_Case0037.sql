-- @testpoint: 文本检索操作符!!，tsquery类型词汇的非关系

select !! 'cat'::tsquery as result;