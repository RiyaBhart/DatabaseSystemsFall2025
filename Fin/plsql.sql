-- pl sql

-- sum of two numbers 
SET SERVEROUTPUT ON;

declare 
a int; 
b int;
c int;
begin
a:=&a;
b:=&b;
c:=a+b;
dbms_output.put_line('sum of a and b is '||c);
end;
/
-- for loop 
declare 
d number(2);
begin
for d in 0..10
loop
dbms_output.put_line(d);
end loop;
end;
/
-- while loop
declare
a int;
b int;
begin
a:=0;
b:=&b;
while a<b
loop 
a:=a+1;
dbms_output.put_line(a);
end loop;
end;
/
-- even numbers from 1-10 using for loop
set serveroutput on;
declare 
a number;
begin
for a in 1..10 loop
if mod(a,2)=0 then
dbms_output.put_line(a);
end if;
end loop;
end;
/

-- creating a procedure
set serveroutput on;
create or replace procedure check_even_odd(num in number)
is 
begin
if mod(num,2)=0 then
dbms_output.put_line(num||' is even');
else
dbms_output.put_line(num||' is odd');
end if;
end;
/
-- 
begin
check_even_odd(7);
end;
/
--

-- creating a function
create or replace function calculateSal(dept_id number)
return number
is 
total_salary number;
begin 
select sum(salary) into total_salary
from employees where department_id = dept_id;

return total_salary;
end;
/
SELECT CalculateSAL(80) FROM dual;

-- explicit cursor
DECLARE
    CURSOR emp_cur IS
        SELECT employee_id, first_name, salary FROM employees;

    rec emp_cur%ROWTYPE;
BEGIN
    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO rec;
        EXIT WHEN emp_cur%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(rec.employee_id || ' - ' ||
                             rec.first_name || ' - ' ||
                             rec.salary);
    END LOOP;
    CLOSE emp_cur;
END;
/

