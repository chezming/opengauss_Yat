-- @testpoint: opengauss内置函数length，作为函数名

select length('a b c'::tsvector  || 'd e f'::tsvector);