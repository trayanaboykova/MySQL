-- FIND NAMES OF ALL EMPLOYEES BY FIRST NAME
SELECT first_name, last_name FROM employees
WHERE first_name LIKE 'Sa%'
ORDER BY employee_id;

-- FIND NAMES OF ALL EMPLOYEES BY LAST NAME
SELECT first_name, last_name FROM employees
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;

-- FIND FIRST NAMES OF ALL EMPLOYEES
SELECT first_name FROM employees
WHERE (department_id = 3 OR department_id = 10) AND
	  YEAR(hire_date) BETWEEN 1995 AND 2005
ORDER BY employee_id;
