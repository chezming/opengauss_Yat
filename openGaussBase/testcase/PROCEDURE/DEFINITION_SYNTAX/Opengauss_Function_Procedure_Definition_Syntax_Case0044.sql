-- @testpoint: 匿名块定义 验证匿名块是否支持end if，与loop连用

DECLARE
  credit_rating NUMBER := 0;
BEGIN
  LOOP
    credit_rating := credit_rating + 1;
    IF credit_rating > 3 THEN
       EXIT;  
    END IF;
 END LOOP;
 raise info 'Credit rating:%' , TO_CHAR(credit_rating);
 IF credit_rating > 3 THEN
       RETURN;  
 END IF;
 raise info 'Credit rating:% ' , TO_CHAR(credit_rating);
END;
/
