-- FIND NAMES OF ALL EMPLOYEES BY FIRST NAME
SELECT first_name, last_name FROM employees
WHERE first_name LIKE 'Sa%'
ORDER BY employee_id;

-- FIND NAMES OF ALL EMPLOYEES BY LAST NAME
SELECT first_name, last_name FROM employees
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;