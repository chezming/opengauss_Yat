-- @testpoint: 文本检索操作符!!与@@结合使用1

select to_tsvector('fat cats ate rats') @@(!!'rat'::tsquery) as result;