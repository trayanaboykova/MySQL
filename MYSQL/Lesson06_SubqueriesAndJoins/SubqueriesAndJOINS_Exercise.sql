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
SELECT e.employee_id, e.first_name, e.last_name, d.name
FROM employees AS e
JOIN departments d 
ON e.department_id = d.department_id
ORDER BY e.employee_id DESC;

-- EMPLOYEE DEPARTMENTS
-- EMPLOYEE WITHOUT PROJECTS
-- EMPLOYEE HIRED AFTER
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