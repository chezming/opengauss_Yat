-- @testpoint: 数组操作符||，数组与数组/元素与数组/数组与元素

--数组与数组进行连接
select array[1,2,3] || array[4,5,6] as result;
select array[1,2,3] || array[[4,5,6],[7,8,9]] as result;

--元素与数组进行连接
select 3 || array[4,5,6] as result;

--数组与元素进行连接
select array[4,5,6] || 7 as result;
