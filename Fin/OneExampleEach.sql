-- ##################################################
-- FINAL EXAM – DATABASE SYSTEMS (FULL FILE)
-- Contains: SQL, Joins, PL/SQL, Triggers, Transactions, Cursors, MongoDB & TCL
-- ##################################################

-- ===========================
-- 1. SCHEMA SETUP
-- ===========================

-- EMPLOYEES table
CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(50),
    department_id NUMBER,
    salary NUMBER
);

-- DEPARTMENTS table
CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    dept_name VARCHAR2(50)
);

-- LOCATIONS table
CREATE TABLE locations (
    location_id NUMBER PRIMARY KEY,
    street VARCHAR2(50),
    city VARCHAR2(50),
    country CHAR(2)
);

-- ACCOUNTS table
CREATE TABLE accounts (
    account_id CHAR(1) PRIMARY KEY,
    balance NUMBER
);

-- AUDIT TABLES
CREATE TABLE emp_audit (
    old_name   VARCHAR2(50),
    new_name   VARCHAR2(50),
    user_name  VARCHAR2(50),
    entry_date DATE,
    operation  VARCHAR2(20)
);

CREATE TABLE salary_audit (
    emp_id     NUMBER,
    old_salary NUMBER,
    new_salary NUMBER,
    change_date DATE
);

-- ===========================
-- 2. JOINS EXAMPLES
-- ===========================

-- Inner Join: Employees with Departments
SELECT e.emp_name, e.salary, d.dept_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;

-- Left Join: All Employees with department info
SELECT e.emp_name, e.salary, d.dept_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;

-- Aggregation with GROUP BY
SELECT department_id, COUNT(*) AS num_employees, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;

-- ===========================
-- 3. PL/SQL BLOCKS, PROCEDURES & FUNCTIONS
-- ===========================

-- Q1: PL/SQL block to check salary
DECLARE
    v_salary EMPLOYEES.salary%TYPE;
    v_emp_id EMPLOYEES.employee_id%TYPE := &emp_id;
BEGIN
    SELECT salary INTO v_salary 
    FROM employees 
    WHERE employee_id = v_emp_id;

    IF v_salary > 25000 THEN
        DBMS_OUTPUT.PUT_LINE('High Salary');
    ELSE
        v_salary := v_salary * 1.15;
        UPDATE employees
        SET salary = v_salary
        WHERE employee_id = v_emp_id;
        DBMS_OUTPUT.PUT_LINE('New Salary: ' || v_salary);
    END IF;
END;
/

-- Q2: Procedure to add location
CREATE OR REPLACE PROCEDURE add_location (
    p_street IN VARCHAR2,
    p_city IN VARCHAR2,
    p_country IN CHAR
)
IS
    v_location_id NUMBER;
BEGIN
    SELECT NVL(MAX(location_id),0)+1
    INTO v_location_id
    FROM locations;

    INSERT INTO locations(location_id, street, city, country)
    VALUES (v_location_id, p_street, p_city, p_country);

    DBMS_OUTPUT.PUT_LINE('Location added with ID: ' || v_location_id);
END;
/

-- Q3: Function to get department average salary
CREATE OR REPLACE FUNCTION getDeptAvg(deptid NUMBER)
RETURN NUMBER
IS
    avg_salary NUMBER;
BEGIN
    SELECT AVG(salary) INTO avg_salary
    FROM employees
    WHERE department_id = deptid;

    RETURN avg_salary;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

-- ===========================
-- 4. TRIGGERS
-- ===========================

-- Q4: Audit trigger
CREATE OR REPLACE TRIGGER audit_emp
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW
DECLARE
    v_user VARCHAR2(50);
BEGIN
    v_user := USER;

    IF INSERTING THEN
        INSERT INTO emp_audit(old_name, new_name, user_name, entry_date, operation)
        VALUES (NULL, :NEW.emp_name, v_user, SYSDATE, 'INSERT');
    ELSIF DELETING THEN
        INSERT INTO emp_audit(old_name, new_name, user_name, entry_date, operation)
        VALUES (:OLD.emp_name, NULL, v_user, SYSDATE, 'DELETE');
    ELSIF UPDATING THEN
        INSERT INTO emp_audit(old_name, new_name, user_name, entry_date, operation)
        VALUES (:OLD.emp_name, :NEW.emp_name, v_user, SYSDATE, 'UPDATE');
    END IF;
END;
/

-- Q5: Salary change trigger
CREATE OR REPLACE TRIGGER log_salary_change
BEFORE UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
    IF :NEW.salary > :OLD.salary THEN
        DBMS_OUTPUT.PUT_LINE('Salary Increased');
    ELSIF :NEW.salary < :OLD.salary THEN
        DBMS_OUTPUT.PUT_LINE('Salary Decreased');
    END IF;

    INSERT INTO salary_audit(emp_id, old_salary, new_salary, change_date)
    VALUES (:OLD.employee_id, :OLD.salary, :NEW.salary, SYSDATE);
END;
/

-- ===========================
-- 5. TRANSACTIONS & EXCEPTION HANDLING
-- ===========================

-- Q6: Transfer between accounts
DECLARE
    v_balance NUMBER;
BEGIN
    SELECT balance INTO v_balance FROM accounts WHERE account_id = 'A';

    IF v_balance < 5000 THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Transaction Failed. Insufficient Balance.');
    ELSE
        UPDATE accounts SET balance = balance - 5000 WHERE account_id = 'A';
        UPDATE accounts SET balance = balance + 5000 WHERE account_id = 'B';
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Transaction Successful.');
    END IF;
END;
/

-- Q7: Update salaries with exception handling
DECLARE
BEGIN
    BEGIN
        UPDATE employees
        SET salary = salary * 1.10
        WHERE department_id = 10;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Salaries updated successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error occurred. Transaction rolled back.');
    END;
END;
/

-- ===========================
-- 6. CURSORS
-- ===========================

-- Q8: Explicit cursor for salary update
DECLARE
    CURSOR emp_cur IS
        SELECT employee_id, emp_name, salary FROM employees;
    v_emp emp_cur%ROWTYPE;
BEGIN
    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO v_emp;
        EXIT WHEN emp_cur%NOTFOUND;

        IF v_emp.salary < 10000 THEN
            v_emp.salary := v_emp.salary * 1.20;
        ELSE
            v_emp.salary := v_emp.salary * 1.10;
        END IF;

        UPDATE employees
        SET salary = v_emp.salary
        WHERE employee_id = v_emp.employee_id;

        DBMS_OUTPUT.PUT_LINE(v_emp.emp_name || ' - Updated Salary: ' || v_emp.salary);
    END LOOP;
    CLOSE emp_cur;
END;
/

-- ===========================
-- 7. MONGODB QUERIES
-- ===========================

/* Q9: Basic student operations */
use mydb;

// Insert
db.students.insertOne({
    name: "Riya",
    age: 21,
    department: "CS",
    gpa: 3.8
});

// Update
db.students.updateOne({ name: "Riya" }, { $set: { gpa: 3.9 } });

// Delete
db.students.deleteMany({ gpa: { $lt: 2.0 } });

/* Q10: Orders operations */
db.orders.find({ total: { $gt: 3000 } });

db.orders.updateMany({}, { $mul: { "items.$[].price": 1.10 } });

db.orders.updateMany({}, { $push: { items: { name: "Headset", qty: 1, price: 2500 } } });

db.orders.aggregate([
    { $group: { _id: null, total_sum: { $sum: "$total" } } }
]);

-- ===========================
-- 8. TCL EXAMPLES
-- ===========================

-- Connect to Oracle using SQL*Plus or tclsh
-- Example TCL snippet to run a SQL file:
# package require sqlite3
# set db [sqlite3 db "mydb.db"]
# db eval {SELECT * FROM employees;}
