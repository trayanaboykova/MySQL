-- FIND ALL INFORMATION ABOUT DEPARTMENTS
SELECT * FROM departments;

-- FIND ALL DEPARTMENT NAMES 
SELECT name FROM departments ORDER BY department_id;

-- FIND SALARY FOR EACH EMPLOYEE
 SELECT first_name, last_name, salary FROM employees ORDER BY employee_id;
 
 -- FIND FULL NAME OF EACH EMPLOYEE
 SELECT first_name, middle_name, last_name FROM employees ORDER BY employee_id;

-- FIND EMAIL ADDRESS OF EACH EMPLOYEE
SELECT CONCAT(first_name, '.', last_name, '@softuni.bg') FROM employees;

-- FIND ALL DIFFERENT EMPLOYEES' SALARIES
SELECT DISTINCT salary FROM employees;

-- FIND ALL INFORMATION ABOUT EMPLOYEES
SELECT * FROM employees
WHERE job_title = 'Sales Representative' ORDER BY employee_id; 

-- FIND NAMES OF ALL EMPLOYEES BY SALARY IN RANGE
SELECT first_name, last_name, job_title FROM employees
WHERE salary >= 20000 AND salary <= 30000
-- this can also be:
-- WHERE salary BETWEEN 20000 AND 30000;
ORDER BY employee_id;

-- FIND NAMES OF ALL EMPLOYEES
SELECT CONCAT(first_name, ' ', middle_name, ' ', last_name) AS `Full Name`
FROM employees
WHERE salary = 25000 OR 
	  salary = 14000 OR 
	  salary = 12500 OR 
	  salary = 23600;
-- this can also be:
-- WHERE salary IN(25000, 14000, 12500, 23600);

-- FIND ALL EMPLOYEES WITHOUT A MANAGER
SELECT first_name, last_name FROM employees 
WHERE manager_id IS NULL;

-- FIND ALL EMPLOYEES WITH SALARY MORE THAN 50000
SELECT first_name, last_name, salary FROM employees
WHERE salary > 50000
ORDER BY salary DESC;

-- FIND 5 BEST PAID EMPLOYEES
SELECT first_name, last_name FROM employees
ORDER BY salary DESC
LIMIT 5;

-- FIND ALL EMPLOYEES EXCEPT MARKETING
SELECT first_name, last_name FROM employees
WHERE department_id != 4;

-- SORT EMPLOYEES TABLE
SELECT * FROM employees
ORDER BY salary DESC, first_name, last_name DESC, middle_name;

-- CREATE VIEW EMPLOYEES WITH SALARIES
CREATE VIEW v_employees_salaries AS
SELECT first_name, last_name, salary FROM employees;

-- CREATE VIEW EMPLOYEES WITH JOB TITLES
CREATE VIEW v_employees_job_titles AS
SELECT CONCAT(first_name, ' ', IF(middle_name IS NOT NULL, CONCAT(middle_name, ' '), ' '), last_name) AS full_name, job_title
FROM employees;
















