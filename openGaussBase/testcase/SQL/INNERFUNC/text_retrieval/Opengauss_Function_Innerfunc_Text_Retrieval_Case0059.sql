-- @testpoint: 文本检索函数length函数，获取tsvector类型词汇的单词数

select length('fat:2,4 cat:3 rat:5a'::tsvector);