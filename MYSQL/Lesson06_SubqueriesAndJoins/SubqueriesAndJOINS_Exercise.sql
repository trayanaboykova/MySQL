-- EMPLOYEE ADDRESS
SELECT e.employee_id, e.job_title, a.address_id, a.address_text 
FROM employees AS e
JOIN addresses AS a 
ON e.address_id = a.address_id
ORDER BY a.address_id
LIMIT 5;

-- ADDRESSES WITH TOWNS
SELECT e.first_name, e.last_name, t.name, a.address_text 
FROM employees AS e
JOIN addresses AS a 
ON e.address_id = a.address_id
JOIN towns t
ON a.town_id = t.town_id
ORDER BY e.first_name, e.last_name
LIMIT 5;

-- SALES EMPLOYEE
SELECT e.employee_id, e.first_name, e.last_name, d.name AS department_name
FROM employees AS e
JOIN departments d 
ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;

-- EMPLOYEE DEPARTMENTS
SELECT e.employee_id, e.first_name, e.salary, d.name AS department_name
FROM employees AS e
JOIN departments d 
ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;

-- EMPLOYEE WITHOUT PROJECTS
SELECT e.employee_id, e.first_name
FROM employees AS e
LEFT JOIN employees_projects ep
ON e.employee_id = ep.employee_id
WHERE ep.project_id IS NULL
ORDER BY e.employee_id DESC
LIMIT 3;

-- EMPLOYEE HIRED AFTER
SELECT e.first_name, e.last_name, e.hire_date, d.name AS dept_name
FROM employees AS e
JOIN departments d
ON e.department_id = d.department_id
WHERE e.hire_date > '1999-01-01' AND d.name IN ('Sales', 'Finance')
ORDER BY e.hire_date ASC;

-- EMPLOYEE WITH PROJECTS
-- EMPLOYEE 24
-- EMPLOYEE MANAGER
-- EMPLOYEE SUMMARY
-- MIN AVERAGE SALARY
-- HIGHEST PEAKS IN BULGARIA
-- COUNT MOUNTAIN RANGES
-- COUNTRIES WITH RIVERS
-- CONTINENTS AND CURRENCIES
-- COUNTRIES WITHOUT ANY MOUNTAINS 
-- HIGHEST PEAK AND LONGEST RIVER BY COUNTRY