-- @testpoint:str的数值满足当前bits反转后输出时make_set的运算

-- str值不包含null或空值
select make_set(31,'a','b','c','d','e','f');
select make_set(1,'a','b');
select make_set(2,'a','b');
select make_set(3,'a','b');
select make_set(3,'a','b');
select make_set(4,'a','b','e','f');
select make_set(78,'t1','t2','t3','t4','t5','t6','t7','t8','t9','t10','t11','t12','t13','t14','t15','t16','t17','t18','t19','t20','t21','t22','t23','t24','t25','t26','t27','t28','t29','t30','t31','t32','t33','t34','t35','t36','t37','t38','t39','t40','t41','t42','t43','t44','t45','t46','t47','t48','t49','t50','t51','t52','t53','t54','t55','t56','t57','t58','t59','t60','t61','t62','t63','t64','t65','t66','t67','t68','t69','t70','t71','t72','t73','t74','t75','t76','t77','t78','t79','t80','t81','t82','t83','t84','t85','t86','t87','t88','t89','t90','t91','t92','t93','t94','t95','t96','t97','t98','t99','t100');

-- str值包含null或空值
select make_set(31,null,'b','c','d','e','f');
select make_set(1,null,'b');
select make_set(2,'a',null);
select make_set(3,null,'');
select make_set(3,'a','');
select make_set(4,'a','','e','f');
select make_set(3,'a',null);


