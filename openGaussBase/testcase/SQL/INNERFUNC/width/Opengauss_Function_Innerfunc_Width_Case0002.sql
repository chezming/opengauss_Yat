-- @testpoint: 坐标为负坐标，计算矩形水平尺寸

select width(box '((-6,-3),(-1,-1))') as result;
