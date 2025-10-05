DROP TABLE Orders_new;
DROP TABLE Customer_new;
DROP TABLE Enrollment_new;
DROP TABLE Student_new;
DROP TABLE Course_new;
DROP TABLE Teacher_new;
DROP TABLE EmployeeProject_new;
DROP TABLE Project_new;
DROP TABLE Employee_new;
DROP TABLE Department_new;


/* =======================
   CREATE TABLES
   ======================= */

-- Departments
CREATE TABLE Department_new (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Employees
CREATE TABLE Employee_new (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    dept_id INT,
    manager_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department_new(dept_id),
    FOREIGN KEY (manager_id) REFERENCES Employee_new(emp_id)
);

-- Projects
CREATE TABLE Project_new (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50)
);

CREATE TABLE EmployeeProject_new (
    emp_id INT,
    project_id INT,
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES Employee_new(emp_id),
    FOREIGN KEY (project_id) REFERENCES Project_new(project_id)
);

-- Teachers
CREATE TABLE Teacher_new (
    teacher_id INT PRIMARY KEY,
    teacher_name VARCHAR(50),
    city VARCHAR(50)
);

-- Courses
CREATE TABLE Course_new (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES Teacher_new(teacher_id)
);

-- Students
CREATE TABLE Student_new (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE Enrollment_new (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student_new(student_id),
    FOREIGN KEY (course_id) REFERENCES Course_new(course_id)
);

-- Customers & Orders
CREATE TABLE Customer_new (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(50)
);

CREATE TABLE Orders_new (
    order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    FOREIGN KEY (cust_id) REFERENCES Customer_new(cust_id)
);

-- Departments
INSERT INTO Department_new VALUES (1, 'HR');
INSERT INTO Department_new VALUES (2, 'IT');
INSERT INTO Department_new VALUES (3, 'Finance');
INSERT INTO Department_new VALUES (4, 'Marketing');

-- Employees 
INSERT INTO Employee_new VALUES (101, 'Ali', 60000, TO_DATE('2021-05-10','YYYY-MM-DD'), 2, NULL);
INSERT INTO Employee_new VALUES (102, 'Sara', 45000, TO_DATE('2022-02-15','YYYY-MM-DD'), 2, 101);
INSERT INTO Employee_new VALUES (103, 'Bilal', 55000, TO_DATE('2020-07-20','YYYY-MM-DD'), 1, 101);
INSERT INTO Employee_new VALUES (104, 'Hina', 70000, TO_DATE('2019-11-01','YYYY-MM-DD'), 3, NULL);
INSERT INTO Employee_new VALUES (105, 'Usman', 28000, TO_DATE('2022-12-01','YYYY-MM-DD'), NULL, 101);

-- Projects
INSERT INTO Project_new VALUES (1, 'ERP System');
INSERT INTO Project_new VALUES (2, 'Website Redesign');

INSERT INTO EmployeeProject_new VALUES (101, 1);
INSERT INTO EmployeeProject_new VALUES (102, 2);

-- Teachers
INSERT INTO Teacher_new VALUES (1, 'Sir Ali', 'Lahore');
INSERT INTO Teacher_new VALUES (2, 'Miss Sana', 'Karachi');

-- Courses
INSERT INTO Course_new VALUES (1, 'Database Systems', 1);
INSERT INTO Course_new VALUES (2, 'Operating Systems', 2);

-- Students
INSERT INTO Student_new VALUES (1, 'Riya', 'Lahore');
INSERT INTO Student_new VALUES (2, 'Rayyan', 'Karachi');
INSERT INTO Student_new VALUES (3, 'Rija', 'Lahore');

-- Enrollments
INSERT INTO Enrollment_new VALUES (1, 1);
INSERT INTO Enrollment_new VALUES (2, 2);
INSERT INTO Enrollment_new VALUES (3, 1);

-- Customers
INSERT INTO Customer_new VALUES (1, 'Adeel');
INSERT INTO Customer_new VALUES (2, 'Hassan');
INSERT INTO Customer_new VALUES (3, 'Nida');

-- Orders (fix dates with TO_DATE)
INSERT INTO Orders_new VALUES (1001, 1, TO_DATE('2023-06-01','YYYY-MM-DD'));
INSERT INTO Orders_new VALUES (1002, 2, TO_DATE('2023-06-05','YYYY-MM-DD'));

-- 1. 
SELECT e.emp_name, d.dept_name
FROM Employee_new e
CROSS JOIN Department_new d;

-- 2. 
SELECT d.dept_name, e.emp_name
FROM Department_new d
LEFT JOIN Employee_new e ON d.dept_id = e.dept_id;

-- 3. 
SELECT e.emp_name AS Employee, m.emp_name AS Manager
FROM Employee_new e
LEFT JOIN Employee_new m ON e.manager_id = m.emp_id;

-- 4. 
SELECT e.emp_name
FROM Employee_new e
LEFT JOIN EmployeeProject_new ep ON e.emp_id = ep.emp_id
WHERE ep.project_id IS NULL;

-- 5.
SELECT s.student_name, c.course_name
FROM Student_new s
JOIN Enrollment_new en ON s.student_id = en.student_id
JOIN Course_new c ON en.course_id = c.course_id;

-- 6. 
SELECT c.cust_name, o.order_id, o.order_date
FROM Customer_new c
LEFT JOIN Orders_new o ON c.cust_id = o.cust_id;

-- 7. 
SELECT d.dept_name, e.emp_name
FROM Department_new d
LEFT JOIN Employee_new e ON d.dept_id = e.dept_id;

-- 8. 
SELECT t.teacher_name, c.course_name
FROM Teacher_new t
LEFT JOIN Course_new c ON t.teacher_id = c.teacher_id;

-- 9. 
SELECT d.dept_name, COUNT(e.emp_id) AS total_employees
FROM Department_new d
LEFT JOIN Employee_new e ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- 10. 
SELECT s.student_name, c.course_name, t.teacher_name
FROM Student_new s
JOIN Enrollment_new en ON s.student_id = en.student_id
JOIN Course_new c ON en.course_id = c.course_id
JOIN Teacher_new t ON c.teacher_id = t.teacher_id;


-- 11. 
SELECT s.student_name, t.teacher_name, s.city
FROM Student_new s
JOIN Teacher_new t ON s.city = t.city;

-- 12. 
SELECT e.emp_name AS Employee, m.emp_name AS Manager
FROM Employee_new e
LEFT JOIN Employee_new m ON e.manager_id = m.emp_id;

-- 13.
SELECT emp_name
FROM Employee_new
WHERE dept_id IS NULL;

-- 14.
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM Department_new d
JOIN Employee_new e ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 50000;

-- 15. 
SELECT e.emp_name, e.salary, d.dept_name
FROM Employee_new e
JOIN Department_new d ON e.dept_id = d.dept_id
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee_new e2
    WHERE e2.dept_id = e.dept_id
);

-- 16.
SELECT d.dept_name
FROM Department_new d
JOIN Employee_new e ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING MIN(e.salary) >= 30000;

-- 17.
SELECT s.student_name, c.course_name
FROM Student_new s
JOIN Enrollment_new en ON s.student_id = en.student_id
JOIN Course_new c ON en.course_id = c.course_id
WHERE s.city = 'Lahore';

-- 18. 
SELECT e.emp_name, m.emp_name AS Manager, d.dept_name, e.hire_date
FROM Employee_new e
LEFT JOIN Employee_new m ON e.manager_id = m.emp_id
LEFT JOIN Department_new d ON e.dept_id = d.dept_id
WHERE e.hire_date BETWEEN TO_DATE('2020-01-01','YYYY-MM-DD') 
                      AND TO_DATE('2023-01-01','YYYY-MM-DD');

-- 19. 
SELECT s.student_name, c.course_name
FROM Student_new s
JOIN Enrollment_new en ON s.student_id = en.student_id
JOIN Course_new c ON en.course_id = c.course_id
JOIN Teacher_new t ON c.teacher_id = t.teacher_id
WHERE t.teacher_name = 'Sir Ali';

-- 20. 
SELECT e.emp_name, m.emp_name AS Manager, d.dept_name
FROM Employee_new e
JOIN Employee_new m ON e.manager_id = m.emp_id
JOIN Department_new d ON e.dept_id = d.dept_id
WHERE e.dept_id = m.dept_id;
