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

-- FIND ALL EMPLOYEES EXCEPT ENGINEERS	 
SELECT first_name, last_name FROM employees
WHERE job_title NOT LIKE '%engineer%'
ORDER BY employee_id;
 
-- FIND TOWNS WITH NAME LENGHT 
SELECT name FROM towns
WHERE LENGTH(name) = 5 OR LENGTH(name) = 6
ORDER by name;

-- FIND TOWNS STARTING WITH
SELECT town_id, name FROM towns
WHERE LEFT(name, 1) IN('M', 'K', 'B', 'E')
ORDER BY name;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
