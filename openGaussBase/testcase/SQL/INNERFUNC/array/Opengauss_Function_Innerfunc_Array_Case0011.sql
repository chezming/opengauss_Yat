-- @testpoint: 函数array_append，向数组末尾添加元素，只支持一维数组

select array_append(array[]::int[],3) as result;
select array_append(array[1,2],3) as result;
select array_append(array[1,2,3,2,4.1]::int[],3) as result;
