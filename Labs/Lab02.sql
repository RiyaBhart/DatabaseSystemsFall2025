-- in lab tasks
SELECT SUM(salary) AS total_salary FROM hr.employees;
SELECT AVG(salary) AS average_salary FROM hr.employees;
SELECT manager_id, COUNT(*) AS num_employees FROM hr.employees GROUP BY manager_id;
SELECT * FROM hr.employees WHERE salary = (SELECT MIN(salary) FROM hr.employees);
SELECT TO_CHAR(SYSDATE, 'DD-MM-YYYY') AS current_date FROM dual;
SELECT TO_CHAR(SYSDATE, 'DAY MONTH YEAR') AS current_date FROM dual;
SELECT * FROM hr.employees WHERE TO_CHAR(hire_date, 'DAY') = 'Wednesday';
SELECT MONTHS_BETWEEN(TO_DATE('01-JAN-2025', 'DD-MON-YYYY'), TO_DATE('01-NOV-2024', 'DD-MON-YYYY')) AS months_diff FROM dual;
SELECT employee_id, first_name, last_name, FLOOR(MONTHS_BETWEEN(SYSDATE,hire_date)) AS months_worked FROM hr.employees;
SELECT SUBSTR(last_name,1,5) AS last_name_5chars FROM hr.employees;

-- post lab tasks 
SELECT employee_id, first_name, LPAD(first_name, 15, '*') AS padded FROM hr.employees; 
SELECT LTRIM('  Oracle') AS new_text FROM dual;
SELECT INITCAP(first_name || ' ' || last_name) as new_name FROM hr.employees;
SELECT NEXT_DAY(TO_DATE('20-AUG-2022','DD-MON-YYYY'), 'MONDAY') AS next_monday FROM dual;
SELECT TO_CHAR(TO_DATE('25-DEC-2023', 'DD-MON-YYYY'), 'MM-YYYY') AS month_year FROM dual;
SELECT DISTINCT salary FROM hr.employees ORDER BY salary ASC;
SELECT employee_id, salary, ROUND(salary, -2) AS updated_salary FROM hr.employees;
SELECT department_id, COUNT(*) AS num_employees FROM hr.employees GROUP BY department_id HAVING COUNT(*) = (SELECT MAX(emp_count) FROM (SELECT COUNT(*) AS emp_count FROM hr.employees GROUP BY department_id));
SELECT department_id, SUM(salary) AS total_salary FROM hr.employees GROUP BY department_id ORDER BY total_salary DESC;
SELECT department_id, COUNT(*) AS num_employees FROM hr.employees GROUP BY department_id HAVING COUNT(*)=(SELECT MAX(emp_count) FROM (SELECT COUNT(*) AS emp_count FROM hr.employees GROUP BY department_id));

