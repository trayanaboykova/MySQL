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
SELECT * FROM employees;



