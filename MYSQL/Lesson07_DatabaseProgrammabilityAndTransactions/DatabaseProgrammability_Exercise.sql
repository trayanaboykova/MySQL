-- EMPLOYEES WITH SALARY ABOVE 35000
DELIMITER $
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT first_name, last_name FROM employees
    WHERE salary > 35000
    ORDER BY first_name, last_name, employee_id;
END $

DELIMITER ;
CALL usp_get_employees_salary_above_35000();

-- EMPLOYEES WITH SALARY ABOVE NUMBER
DELIMITER $
CREATE PROCEDURE usp_get_employees_salary_above(target_salary DECIMAL(10,4))
BEGIN
	SELECT first_name, last_name FROM employees
    WHERE salary >= target_salary
    ORDER BY first_name, last_name, employee_id;
END $

DELIMITER ;

CALL usp_get_employees_salary_above(70000);

-- TOWN NAMES STARTING WITH
DELIMITER $
CREATE PROCEDURE usp_get_towns_starting_with(symbol VARCHAR(20))
BEGIN
	SELECT name FROM towns
    WHERE name LIKE CONCAT(symbol, '%')
    ORDER BY name;
END $

DELIMITER ;

CALL usp_get_towns_starting_with('s');

-- EMPLOYEES FROM TOWN
DELIMITER $
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(100))
BEGIN
	SELECT e.first_name, e.last_name FROM employees e 
    JOIN addresses a ON e.address_id = a.address_id
    JOIN towns t ON a.town_id = t.town_id
    WHERE t.name = town_name
    ORDER BY e.first_name, e.last_name, e.employee_id;
END $

DELIMITER ;

CALL usp_get_employees_from_town('Sofia');

-- SALARY LEVEL FUNCTION


-- EMPLOYEES BY SALARY LEVEL


-- DEFINE FUNCTION


-- FIND FULL NAME


-- PEOPLE WITH BALANCE HIGHER THAN


-- FUTURE VALUE FUNCTION


-- CALCULATING INTEREST


-- DEPOSIT MONEY


-- WITHDRAW MONEY


-- MONEY TRANSFER


-- LOG ACCOUNTS TRIGGER


-- EMAILS TRIGGER
