-- MANAGERS
SELECT 
	employee_id,
    CONCAT(first_name, ' ', last_name) AS 'full_name',
    departments.department_id, 
    name AS 'department_name'
FROM departments
	JOIN employees ON departments.manager_id = employees.employee_id
ORDER BY employee_id
LIMIT 5;

-- TOWNS AND ADDRESSES
-- SOLUTION 1 WITH JOIN
SELECT 
	a.town_id,
    t.name,
    a.address_text
FROM addresses AS a
	JOIN towns AS t ON a.town_id = t.town_id
WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY town_id, address_id;
-- SOLUTION 2 WITH INNER JOIN
SELECT 
	a.town_id,
    t.name,
    a.address_text
FROM addresses AS a
	INNER JOIN towns AS t 
    ON a.town_id = t.town_id AND
    t.name IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY town_id, address_id;

-- EMPLOYEES WITHOUT MANAGERS
SELECT
	employee_id,
    first_name,
    last_name,
    department_id,
    salary
FROM employees
WHERE manager_id IS NULL;

-- HIGH SALARY
SELECT COUNT(*) AS 'count'
FROM employees
WHERE salary > (
	SELECT AVG(salary) FROM employees
);