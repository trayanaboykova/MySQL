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
SELECT 
    AVG(salary) AS min_average_salary
FROM
    employees
GROUP BY department_id
ORDER BY min_average_salary
LIMIT 1;

-- HIGHEST PEAKS IN BULGARIA
SELECT 
    c.country_code, 
    m.mountain_range, 
    p.peak_name, 
    p.elevation
FROM
    countries c
        JOIN
    mountains_countries mc ON c.country_code = mc.country_code
        JOIN
    mountains m ON mc.mountain_id = m.id
        JOIN
    peaks p ON m.id = p.mountain_id
WHERE
    c.country_code = 'BG'
        AND p.elevation > 2835
ORDER BY p.elevation DESC;

-- COUNT MOUNTAIN RANGES
SELECT 
    mc.country_code, COUNT(*) AS mountain_range
FROM
    mountains_countries mc
WHERE
    mc.country_code IN ('BG' , 'RU', 'US')
GROUP BY mc.country_code
ORDER BY mountain_range DESC;

-- COUNTRIES WITH RIVERS
SELECT 
    c.country_name, r.river_name
FROM
    countries c
        LEFT JOIN
    countries_rivers cr ON c.country_code = cr.country_code
        LEFT JOIN
    rivers r ON cr.river_id = r.id
WHERE
    c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;

-- CONTINENTS AND CURRENCIES
SELECT 
    c.continent_code,
    c.currency_code,
    COUNT(*) AS currency_usage
FROM
    countries c
GROUP BY c.continent_code , c.currency_code
HAVING currency_usage > 1
    AND currency_usage = (SELECT 
        COUNT(*) AS max_usage
    FROM
        countries
    WHERE
        continent_code = c.continent_code
    GROUP BY currency_code
    ORDER BY max_usage DESC
    LIMIT 1)
ORDER BY c.continent_code , c.currency_code;

-- COUNTRIES WITHOUT ANY MOUNTAINS 
-- HIGHEST PEAK AND LONGEST RIVER BY COUNTRY