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