-- @testpoint: opengauss内置函数length，先用to_tsvector解析文档，再获取词汇数

select length(to_tsvector('the fat cats ate rats'));