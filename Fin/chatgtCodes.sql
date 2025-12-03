
--**Q1. PL/SQL block for salary check & update**

```sql
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
```

---

### **Q2. Procedure to add location**

```sql
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
```

**Example call:**

```sql
BEGIN
    add_location('Street 1','Karachi','PK');
END;
/
```

---

### **Q3. Function to get department average salary**

```sql
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

-- Call function
SELECT getDeptAvg(10) AS dept10_avg_salary FROM dual;
```

---

## 🟧 **SECTION B — TRIGGERS (25 Marks)**

### **Q4. Audit trigger**

```sql
CREATE TABLE emp_audit (
    old_name   VARCHAR2(50),
    new_name   VARCHAR2(50),
    user_name  VARCHAR2(50),
    entry_date DATE,
    operation  VARCHAR2(20)
);

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
```

---

### **Q5. Salary change trigger**

```sql
CREATE TABLE salary_audit (
    emp_id     NUMBER,
    old_salary NUMBER,
    new_salary NUMBER,
    change_date DATE
);

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
```

---

## 🟩 **SECTION C — TRANSACTIONS (20 Marks)**

### **Q6. Transfer 5000 between accounts with rollback**

```sql
DECLARE
    v_balance NUMBER;
BEGIN
    -- Start transaction
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
```

---

### **Q7. Update dept 10 salaries with exception handling**

```sql
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
```

---

## 🟥 **SECTION D — CURSORS (15 Marks)**

### **Q8. Explicit cursor to update salaries**

```sql
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
```

---

## 🟪 **SECTION E — MONGODB (15 Marks)**

### **Q9. Basic MongoDB queries**

```javascript
// 1. Insert document
db.students.insertOne({
    name: "Riya",
    age: 21,
    department: "CS",
    gpa: 3.8
});

// 2. Update GPA
db.students.updateOne(
    { name: "Riya" },
    { $set: { gpa: 3.9 } }
);

// 3. Delete students with GPA < 2.0
db.students.deleteMany({ gpa: { $lt: 2.0 } });
```

---

### **Q10. Orders collection MongoDB queries**

```javascript
// 1. Find orders with total > 3000
db.orders.find({ total: { $gt: 3000 } });

// 2. Increase price of all items by 10%
db.orders.updateMany(
    {},
    { $mul: { "items.$[].price": 1.10 } }
);

// 3. Add a new item
db.orders.updateMany(
    {},
    { $push: { items: { name: "Headset", qty: 1, price: 2500 } } }
);

// 4. Aggregation to calculate total sum of all orders
db.orders.aggregate([
    { $group: { _id: null, total_sum: { $sum: "$total" } } }
]);
```

---

