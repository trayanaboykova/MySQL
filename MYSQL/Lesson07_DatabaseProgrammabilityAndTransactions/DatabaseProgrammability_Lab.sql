-- COUNT EMPLOYEES BY TOWN
DELIMITER  $
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50)) RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE result INT;
    SET @result := (SELECT COUNT(*) FROM employees e
					JOIN addresses a 
                    ON e.address_id = a.address_id
                    JOIN towns t
                    ON a.town_id = t.town_id
                    WHERE t.name = town_name);
    RETURN @result;
END $

-- EMPLOYEES PROMOTION
DELIMITER $
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR (50))
BEGIN
	UPDATE employees e
    JOIN departments d
    ON e.department_id = d.department_id
    SET e.salary = e.salary * 1.05
    WHERE d.name = department_name;
END $

SELECT employee_id, first_name, salary FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE d.name = 'Finance'
ORDER BY first_name, salary;

CALL usp_raise_salaries('Finance');

-- EMPLOYEES PROMOTION BY ID


-- TRIGGERED