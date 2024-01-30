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
 
 -- FIND TOWNS NOT STARTING WITH
SELECT town_id, name FROM towns
WHERE LEFT(name, 1) NOT IN('R', 'B', 'D')
ORDER BY name;

-- CREATE VIEW EMPLOYYES HIRED AFTER 2000 YEAR
CREATE VIEW v_employees_hired_after_2000 AS
SELECT first_name, last_name FROM employees
WHERE YEAR(hire_date) > 2000;
SELECT * FROM v_employees_hired_after_2000;

-- LENGTH OF LAST NAME
SELECT first_name, last_name
FROM employees
WHERE LENGTH(last_name) = 5;

-- COUNTRIES HOLDING 'A' 3 OR MORE TIMES
SELECT country_name, iso_code FROM countries
WHERE country_name LIKE '%A%%A%%A%'
ORDER BY iso_code;

-- MIX OF PEAK AND RIVER NAMES
SELECT peak_name, river_name,
CONCAT(LOWER(peak_name), SUBSTRING(LOWER(river_name), 2)) AS 'mix' 
FROM peaks, rivers
WHERE RIGHT(peak_name, 1) = LEFT(river_name, 1)
ORDER BY mix;

-- GAMES FROM 2011 AND 2012 YEAR
SELECT name, DATE_FORMAT(start, '%Y-%m-%d') as START FROM games
WHERE YEAR(start) IN(2011,2012)
ORDER BY start LIMIT 50;

-- USER EMAIL PROVIDERS
SELECT user_name, SUBSTRING(email, LOCATE('@',email)+1)
AS 'email_provider' FROM users
ORDER BY email_provider, user_name;

-- GET USERS WITH IP ADRDRESS LIKE PATTERN
SELECT user_name, ip_address FROM users
WHERE ip_address LIKE '___.1%.%.___'
ORDER BY user_name;

-- SHOW ALL GAMES WITH DURATION
SELECT name as game, 
CASE
	WHEN HOUR(start) < 12 THEN 'Morning'
	WHEN HOUR(start) < 18 THEN 'Afternoon'
	WHEN HOUR(start) < 24 THEN 'Evening'
END AS 'Part of the Day',
CASE
	WHEN duration < 4 THEN 'Extra Short'
	WHEN duration < 7 THEN 'Short'
	WHEN duration < 11 THEN 'Long'
    ELSE 'EXTRA LONG'
END AS 'Duration'
FROM games;