-- @testpoint: 存储过程中case语句

create or replace procedure proc_case_branch(pi_result in integer, pi_return out integer)
as
    begin
        case pi_result
            when 1 then
                pi_return := 111;
            when 2 then
                pi_return := 222;
            when 3 then
                pi_return := 333;
            when 4 then
                pi_return := 444;
            when 5 then
                pi_return := 555;
            when 6 then
                pi_return := 666;
            when 7 then
                pi_return := 777;
            when 8 then
                pi_return := 888;
            when 9 then
                pi_return := 999;
            else
                pi_return := 000;
        end case;
        raise info 'pi_return : %',pi_return ;
end;
/

call proc_case_branch(3,0);
call proc_case_branch(6,0);
drop procedure proc_case_branch;

