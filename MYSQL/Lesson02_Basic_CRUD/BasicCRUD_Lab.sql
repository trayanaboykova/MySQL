-- SELECT EMPLOYEE INFORMATION
SELECT id, first_name, last_name, job_title
FROM employees
ORDER BY id;

-- SELECT EMPLOYEES WITH FILTER
SELECT 
	id,
	CONCAT (first_name, ' ', last_name) AS 'full_name',
	job_title,
    salary
FROM employees
WHERE salary > 1000
ORDER BY id;

-- UPDATE EMPLOYEES SALARY
UPDATE employees 
SET salary = salary + 100
WHERE job_title = 'Manager';
SELECT salary FROM employees;

-- TOP PAID EMPLOYEE
CREATE VIEW top_paid_employee AS
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 1;
SELECT * FROM top_paid_employee;

-- SELECT EMPLOYEES BY MULTIPLE FILTERS
SELECT *
FROM employees
WHERE department_id = 4 AND salary >= 1000
ORDER BY id;

-- DELETE FROM TABLE
DELETE FROM employees
WHERE department_id IN (1, 2);
SELECT *
FROM employees
ORDER BY id;


