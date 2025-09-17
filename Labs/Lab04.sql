DROP TABLE Enrollment;
DROP TABLE Student;
DROP TABLE Faculty;
DROP TABLE Course;
DROP TABLE Department;

-- ==========================
-- Department Table
-- ==========================
CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO Department(dept_id,dept_name)
VALUES(1, 'Computer Science');
INSERT INTO Department(dept_id,dept_name)
VALUES(2, 'Mathematics');
INSERT INTO Department(dept_id,dept_name)
VALUES (3, 'Physics');
INSERT INTO Department(dept_id,dept_name)
VALUES(4, 'AI AND Data Science');

-- ==========================
-- Student Table
-- ==========================
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    dept_id INT,
    gpa DECIMAL(3,2),
    fee_paid DECIMAL(10,2),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

INSERT INTO Student VALUES
(101, 'Ali', 1, 3.60, 50000);
INSERT INTO Student VALUES
(102, 'Sara', 1, 2.90, 45000);
INSERT INTO Student VALUES
(103, 'Usman', 2, 3.20, 60000);
INSERT INTO Student VALUES
(104, 'Hina', 2, 3.80, 70000);
INSERT INTO Student VALUES
(105, 'Zain', 3, 2.70, 30000);
INSERT INTO Student VALUES
(106, 'Maryam', 3, 3.10, 35000);
INSERT INTO Student VALUES
(107, 'Hamza', 4, 3.90, 80000);
INSERT INTO Student VALUES
(108, 'Ayesha', 4, 2.50, 20000);
INSERT INTO Student VALUES
(109, 'Bilal', 1, 3.40, 55000);
INSERT INTO Student VALUES
(110, 'Fatima', 2, 3.00, 40000);

-- ==========================
-- Faculty Table
-- ==========================
CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY,
    name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2),
    joining_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

INSERT INTO Faculty VALUES (201, 'Dr. Ahmed', 1, 120000, TO_DATE('2000-01-10','YYYY-MM-DD'));
INSERT INTO Faculty VALUES (202, 'Dr. Khan', 1, 90000,  TO_DATE('2005-03-20','YYYY-MM-DD'));
INSERT INTO Faculty VALUES (203, 'Dr. Smith', 2, 110000, TO_DATE('2010-06-15','YYYY-MM-DD'));
INSERT INTO Faculty VALUES (204, 'Dr. John', 2, 95000,  TO_DATE('2015-09-01','YYYY-MM-DD'));
INSERT INTO Faculty VALUES (205, 'Dr. Ali', 3, 130000, TO_DATE('1995-02-11','YYYY-MM-DD'));
INSERT INTO Faculty VALUES (206, 'Dr. Sana', 3, 85000,  TO_DATE('2018-12-10','YYYY-MM-DD'));
INSERT INTO Faculty VALUES (207, 'Dr. Yasir', 4, 140000, TO_DATE('2002-07-19','YYYY-MM-DD'));
INSERT INTO Faculty VALUES (208, 'Dr. Noor', 4, 125000, TO_DATE('2003-11-25','YYYY-MM-DD'));
INSERT INTO Faculty VALUES (209, 'Dr. Waqar', 1, 105000, TO_DATE('2020-08-05','YYYY-MM-DD'));
INSERT INTO Faculty VALUES (210, 'Dr. Rehan', 2, 102000, TO_DATE('2008-04-09','YYYY-MM-DD'));

-- ==========================
-- Course Table
-- ==========================
CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

INSERT INTO Course VALUES (301, 'Database Systems', 1);
INSERT INTO Course VALUES (302, 'Operating Systems', 1);
INSERT INTO Course VALUES (303, 'Calculus', 2);
INSERT INTO Course VALUES (304, 'Linear Algebra', 2);
INSERT INTO Course VALUES (305, 'Quantum Mechanics', 3);
INSERT INTO Course VALUES (306, 'Electromagnetism', 3);
INSERT INTO Course VALUES (307, 'Machine Learning', 4);
INSERT INTO Course VALUES (308, 'Deep Learning', 4);

-- ==========================
-- Enrollment Table
-- ==========================
CREATE TABLE Enrollment (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

-- Student-Course Enrollments
INSERT INTO Enrollment VALUES (101, 301);
INSERT INTO Enrollment VALUES (101, 302);
INSERT INTO Enrollment VALUES (102, 301);
INSERT INTO Enrollment VALUES (103, 303);
INSERT INTO Enrollment VALUES (103, 304);
INSERT INTO Enrollment VALUES (104, 303);
INSERT INTO Enrollment VALUES (104, 304);
INSERT INTO Enrollment VALUES (105, 305);
INSERT INTO Enrollment VALUES (106, 305);
INSERT INTO Enrollment VALUES (106, 306);
INSERT INTO Enrollment VALUES (107, 307);
INSERT INTO Enrollment VALUES (107, 308);
INSERT INTO Enrollment VALUES (108, 307);
INSERT INTO Enrollment VALUES (109, 301);
INSERT INTO Enrollment VALUES (109, 302);
INSERT INTO Enrollment VALUES (109, 307);
INSERT INTO Enrollment VALUES (110, 304);


-- TASK 1 
select d.dept_name, count(s.student_id) as num_students 
FROM Department d
LEFT JOIN Student s ON d.dept_id = s.dept_id
Group BY d.dept_name ORDER BY d.dept_name;

-- TASK 2 
SELECT dept_name, AVG(gpa)
FROM Department, Student
WHERE Department.dept_id = Student.dept_id
GROUP BY dept_name
HAVING AVG(gpa) > 3.0;

-- TASK 3
SELECT c.course_name, avg(s.fee_paid) as avg_Fee
FROM Student s, Enrollment e, Course c
where s.student_id = e.student_id
and e.course_id = c.course_id
group by c.course_name;

-- TASK 4
SELECT d.dept_name, COUNT(f.faculty_id) AS faculty_count
FROM Department d
LEFT JOIN Faculty f ON d.dept_id = f.dept_id
GROUP BY d.dept_name;

-- TASK 5 
Select f.faculty_id, f.name, f.salary
from Faculty f
where f.salary>(select avg(salary) from faculty);

-- TASK 6
Select s.name, s.student_id, s.gpa
from Student s
where s.gpa > (select min(s2.gpa) from Student s2
JOIN Department d on s2.dept_id = d.dept_id
where d.dept_name ='CS');

-- TASK 7
SELECT s.name, s.gpa, s.student_id
FROM (
    SELECT student_id, name, gpa
    FROM Student
    ORDER BY gpa DESC
) s
WHERE ROWNUM <= 3;

-- TASK 8
SELECT e.student_id, s.name
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
WHERE e.course_id IN (
    SELECT course_id
    FROM Enrollment e2
    JOIN Student sa ON e2.student_id = sa.student_id
    WHERE sa.name = 'Ali'
)
GROUP BY e.student_id, s.name
HAVING COUNT(DISTINCT e.course_id) = (
    SELECT COUNT(DISTINCT e3.course_id)
    FROM Enrollment e3
    JOIN Student sa2 ON e3.student_id = sa2.student_id
    WHERE sa2.name = 'Ali'
);

-- TASK 9
Select d.dept_id, d.dept_name, SUM(s.fee_paid) as total_fees
from Department d
join Student s on d.dept_id = s.dept_id
group by d.dept_id, d.dept_name;

-- TASK 10 
SELECT DISTINCT c.course_id, c.course_name
FROM Course c
JOIN Enrollment e ON c.course_id = e.course_id
JOIN Student s ON e.student_id = s.student_id
WHERE s.gpa > 3.5;

-- TASK 11
Select d.dept_id, d.dept_name, sum(s.fee_paid) as fee_paid
from Department d
Join Student s on d.dept_id = s.dept_id
group by d.dept_id ,d.dept_name
having sum(s.fee_paid)>1000000;

-- TASK 12
Select d.dept_id, d.dept_name, count(f.faculty_id) as high_paid_faculty
from Department d
join Faculty f on d.dept_id = f.dept_id
where f.salary>100000
group by d.dept_id, d.dept_name
having count(f.faculty_id)>5;

-- TASK 13
DELETE FROM Student 
Where gpa<(SELECT AVG(gpa) FROM Student);

-- TASK 14
DELETE FROM Course
WHERE course_id NOT IN (
    SELECT DISTINCT course_id 
    FROM Enrollment
);


-- TASK 15
CREATE TABLE highfee_students as
SELECT * FROM Student 
WHERE fee_paid>(SELECT AVG(fee_paid) FROM Student);

-- TASK 16
CREATE TABLE Retired_Faculty AS
SELECT * FROM Faculty WHERE 1=0;  -- empty table with same structure

INSERT INTO Retired_faculty (faculty_id, name, dept_id, salary, joining_date)
SELECT f.faculty_id, f.name, f.dept_id, f.salary, f.joining_date
FROM Faculty f
WHERE f.joining_date<(SELECT MIN(joining_date) FROM Faculty);

-- TASK 17
SELECT dept_id, dept_name, total_fee
FROM (
    SELECT d.dept_id, d.dept_name, SUM(s.fee_paid) AS total_fee
    FROM Department d
    JOIN Student s ON d.dept_id = s.dept_id
    GROUP BY d.dept_id, d.dept_name
    ORDER BY SUM(s.fee_paid) DESC
) 
WHERE ROWNUM = 1;

-- TASK 18
SELECT course_id, course_name, num_students
FROM (
    SELECT c.course_id, c.course_name, COUNT(e.student_id) AS num_students
    FROM Course c
    LEFT JOIN Enrollment e ON c.course_id = e.course_id
    GROUP BY c.course_id, c.course_name
    ORDER BY COUNT(e.student_id) DESC
)
WHERE ROWNUM <= 3;

-- TASK 19
SELECT s.student_id, s.name, s.gpa, count(e.course_id) as enrolled_courses
From Student s 
Join Enrollment e on s.student_id = e.student_id
GROUP BY s.student_id, s.name, s.gpa
HAVING Count(e.course_id)>3 AND s.gpa>(SELECT AVG(gpa) FROM Student);

-- TASK 20 
CREATE TABLE Unassigned_faculty as
SELECT * FROM Faculty 
WHERE dept_id NOT IN (
    SELECT DISTINCT c.dept_id 
    FROM Course c
    JOIN Enrollment e on c.course_id = e.course_id
);
