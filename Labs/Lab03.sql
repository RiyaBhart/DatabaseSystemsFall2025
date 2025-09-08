-- TASK 1
CREATE TABLE employees(
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR2(50) NOT NULL,
    salary NUMBER(10,2) CONSTRAINT chk_salary CHECK (salary > 20000),
    dept_id INT
);


-- TASK 2

ALTER TABLE employees 
RENAME COLUMN emp_name TO full_name;


-- TASK 3
ALTER TABLE employees
DROP CONSTRAINT chk_salary;

INSERT INTO employees (emp_id, full_name, salary, dept_id)
VALUES (1, 'Rohan', 5000, 1);


-- TASK 4
CREATE TABLE departments(
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR2(15) UNIQUE
);

INSERT INTO departments (dept_id, dept_name) VALUES (1, 'ACADEMICS');
INSERT INTO departments (dept_id, dept_name) VALUES (2, 'MANAGEMENT');
INSERT INTO departments (dept_id, dept_name) VALUES (3, 'SALES');


-- TASK 5
ALTER TABLE employees
ADD CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id);


-- TASK 6
ALTER TABLE employees
ADD bonus NUMBER(6,2) DEFAULT 1000;


-- TASK 7
ALTER TABLE employees
ADD city VARCHAR2(20) DEFAULT 'Karachi';

ALTER TABLE employees
ADD age NUMBER CHECK (age > 18);


-- TASK 8
DELETE FROM employees WHERE emp_id IN (1,3);


-- TASK 9 
ALTER TABLE employees MODIFY (full_name VARCHAR2(20));
ALTER TABLE employees MODIFY (city VARCHAR2(20));


-- TASK 10
ALTER TABLE employees
ADD email VARCHAR2(50) UNIQUE;

-- TASK 11
ALTER TABLE employees
ADD CONSTRAINT uq_bonus UNIQUE (bonus);

INSERT INTO employees (emp_id, full_name, salary, dept_id, bonus) 
VALUES (2, 'Ali', 25000, 1, 2000);

INSERT INTO employees (emp_id, full_name, salary, dept_id, bonus) 
VALUES (3, 'Sara', 30000, 2, 2000);  -- this will fail 

-- TASK 12
ALTER TABLE employees
ADD dob DATE; -- age already checked in previous task

-- TASK 13
INSERT INTO EMPLOYEES (emp_id, full_name, salary, dept_id, city, age, email, dob)
VALUES (20, 'Alia', 25000, 2, 'Karachi', 17, 'alia@example.com', DATE '2014-07-06');

-- TASK 14
ALTER TABLE employees DROP CONSTRAINT fk_dept;

INSERT INTO EMPLOYEES (emp_id, full_name, salary, dept_id, city, age, dob, email)
VALUES (30, 'Manahil', 40000, 999, 'Islamabad', 25, DATE '1998-08-19', 'manaheel@example.com');

ALTER TABLE EMPLOYEES
ADD CONSTRAINT fk_dept
FOREIGN KEY (dept_id) REFERENCES DEPARTMENTS(dept_id);

-- TASK 15
ALTER TABLE EMPLOYEES
DROP COLUMN age;
ALTER TABLE EMPLOYEES
DROP COLUMN city;

-- TASK 16
select d.dept_id, d.dept_name, e.emp_id, e.full_name
from departments d
left join employees e
ON d.dept_id = e.dept_id;

-- TASK 17

ALTER TABLE EMPLOYEES
RENAME COLUMN salary TO monthly_salary;

-- TASK 18
select d.dept_id, d.dept_name
from departments d
left join employees e
ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;

-- TASK 19

TRUNCATE TABLE students;

-- TASK 20
SELECT dept_id, COUNT(*) AS emp_count
FROM employees
GROUP BY dept_id
ORDER BY emp_count DESC
FETCH FIRST 1 ROWS ONLY;

