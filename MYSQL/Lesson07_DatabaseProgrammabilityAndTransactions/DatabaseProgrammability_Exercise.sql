-- EMPLOYEES WITH SALARY ABOVE 35000
DELIMITER $
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT first_name, last_name FROM employees
    WHERE salary > 35000
    ORDER BY first_name, last_name, employee_id;
END $

CALL usp_get_employees_salary_above_35000();

-- EMPLOYEES WITH SALARY ABOVE NUMBER
DELIMITER $
CREATE PROCEDURE usp_get_employees_salary_above(target_salary DECIMAL(10,4))
BEGIN
	SELECT first_name, last_name FROM employees
    WHERE salary >= target_salary
    ORDER BY first_name, last_name, employee_id;
END $

CALL usp_get_employees_salary_above(70000);

-- TOWN NAMES STARTING WITH


-- EMPLOYEES FROM TOWN


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
