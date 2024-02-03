-- EMPLOYEE ADDRESS
SELECT 
    e.employee_id, e.job_title, a.address_id, a.address_text
FROM
    employees AS e
        JOIN
    addresses AS a ON e.address_id = a.address_id
ORDER BY a.address_id
LIMIT 5;

-- ADDRESSES WITH TOWNS
SELECT 
    e.first_name, e.last_name, t.name, a.address_text
FROM
    employees AS e
        JOIN
    addresses AS a ON e.address_id = a.address_id
        JOIN
    towns t ON a.town_id = t.town_id
ORDER BY e.first_name , e.last_name
LIMIT 5;

-- SALES EMPLOYEE
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.name AS department_name
FROM
    employees AS e
        JOIN
    departments d ON e.department_id = d.department_id
WHERE
    d.name = 'Sales'
ORDER BY e.employee_id DESC;

-- EMPLOYEE DEPARTMENTS
SELECT 
    e.employee_id,
    e.first_name,
    e.salary,
    d.name AS department_name
FROM
    employees AS e
        JOIN
    departments d ON e.department_id = d.department_id
WHERE
    e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;

-- EMPLOYEE WITHOUT PROJECTS
SELECT 
    e.employee_id, e.first_name
FROM
    employees AS e
        LEFT JOIN
    employees_projects ep ON e.employee_id = ep.employee_id
WHERE
    ep.project_id IS NULL
ORDER BY e.employee_id DESC
LIMIT 3;

-- EMPLOYEE HIRED AFTER
SELECT 
    e.first_name, e.last_name, e.hire_date, d.name AS dept_name
FROM
    employees AS e
        JOIN
    departments d ON e.department_id = d.department_id
WHERE
    e.hire_date > '1999-01-01'
        AND d.name IN ('Sales' , 'Finance')
ORDER BY e.hire_date ASC;

-- EMPLOYEE WITH PROJECTS
SELECT 
    e.employee_id, e.first_name, p.name AS project_name
FROM
    employees e
        JOIN
    employees_projects ep ON e.employee_id = ep.employee_id
        JOIN
    projects p ON ep.project_id = p.project_id
WHERE
    DATE(p.start_date) > '2002-08-13'
        AND p.end_date IS NULL
ORDER BY e.first_name , p.name
LIMIT 5;

-- EMPLOYEE 24
SELECT 
    e.employee_id,
    e.first_name,
    IF(YEAR(p.start_date) >= 2005,
        NULL,
        p.name) AS project_name
FROM
    employees e
        JOIN
    employees_projects ep ON e.employee_id = ep.employee_id
        JOIN
    projects p ON ep.project_id = p.project_id
WHERE
    e.employee_id = 24
ORDER BY project_name;

-- EMPLOYEE MANAGER
SELECT 
    e.employee_id,
    e.first_name,
    e.manager_id,
    m.first_name AS manager_id
FROM
    employees e
        JOIN
    employees m ON e.manager_id = m.employee_id
WHERE
    e.manager_id IN (3 , 7)
ORDER BY e.first_name;

-- EMPLOYEE SUMMARY
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    d.name AS department_name
FROM
    employees e
        JOIN
    employees m ON e.manager_id = m.employee_id
		JOIN
	departments d ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 5;

-- MIN AVERAGE SALARY
-- HIGHEST PEAKS IN BULGARIA
-- COUNT MOUNTAIN RANGES
-- COUNTRIES WITH RIVERS
-- CONTINENTS AND CURRENCIES
-- COUNTRIES WITHOUT ANY MOUNTAINS 
-- HIGHEST PEAK AND LONGEST RIVER BY COUNTRY