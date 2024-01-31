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


-- APPETIZERS COUNT


-- MENU PRICES
