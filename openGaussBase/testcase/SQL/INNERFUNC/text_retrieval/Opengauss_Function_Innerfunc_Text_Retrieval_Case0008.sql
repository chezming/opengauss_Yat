-- @testpoint: 文本检索操作符@@，与tsvector结合使用

select 'fat cats ate fat rats'::tsvector @@ to_tsquery('fat & rat')as result;