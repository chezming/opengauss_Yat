--  @testpoint:clob:隐式转换支持to_date：success
SELECT TO_DATE(to_clob('05 Dec 2010'),'DD Mon YYYY');