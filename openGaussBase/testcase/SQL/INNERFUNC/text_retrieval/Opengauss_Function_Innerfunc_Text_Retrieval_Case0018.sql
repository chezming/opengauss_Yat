-- @testpoint: 文本检索操作符||，连接两次tsvector类型的词汇

select  to_tsvector('fat cats ate ate' )|| 'a b c'::tsvector  || 'd e f'::tsvector as result;