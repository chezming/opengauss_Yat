-- @testpoint: 通过123456.7898765给有效位为16位，小数位精确到小数点右10位的数赋值

declare
  v_sysdate number(16,10);
begin
    select 123456.7898765 into v_sysdate from sys_dummy;
    raise info 'result:% ',v_sysdate;
end;
/