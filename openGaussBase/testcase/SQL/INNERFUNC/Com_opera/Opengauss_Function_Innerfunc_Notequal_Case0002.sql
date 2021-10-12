-- @testpoint: opengauss比较操作符<>，货币类型
-- 货币类型,比较的是小数位四舍五入保留小数点后两位的数值大小
select '0.0999'::money <> '0.1000'::money;
SELECT '9.99'::money <> '10.00'::money;
SELECT '9.999'::money <> '10.00'::money;
SELECT '9.99'::money <> '9.95'::money;
select '52093.89'::money <> '52093.891'::money;
select '52093.891'::money <> '52093.897'::money;
select '0.001'::money <> '0.0'::money;
select '0.099'::money <> '0.1'::money;
SELECT '1'::money <> '1.00'::money;