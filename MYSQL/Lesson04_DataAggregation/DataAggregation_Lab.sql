-- DEPARTMENTS INFO
SELECT department_id, COUNT(id) AS 'Number of employees'
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- AVERAGE SALARY
SELECT department_id, ROUND(AVG(salary), 2) AS 'Average salary'
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- MINIMUM SALARY
SELECT department_id, MIN(ROUND(salary, 2)) AS min_salary
FROM employees
GROUP BY department_id
HAVING MIN(salary) > 800
ORDER BY department_id;  

-- APPETIZERS COUNT
SELECT COUNT(*)
FROM products
WHERE category_id = 2 AND price > 8;

-- MENU PRICES
