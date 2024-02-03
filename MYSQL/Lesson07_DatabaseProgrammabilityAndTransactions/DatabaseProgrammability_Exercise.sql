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
DELIMITER $
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(10,4))
RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
	DECLARE result VARCHAR(20);
    IF (salary < 30000) THEN 
		SET result := 'Low';
	ELSEIF (salary >= 30000 AND salary <= 50000) THEN
		SET result := 'Average';
	ELSE
		SET result := 'High';
	END IF;
    RETURN result;
END $

DELIMITER ;

SELECT ufn_get_salary_level(55000);

-- EMPLOYEES BY SALARY LEVEL
DELIMITER $
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(20))
BEGIN
	SELECT first_name, last_name FROM employees
    WHERE salary_level = ufn_get_salary_level(salary)
    ORDER BY first_name DESC, last_name DESC;
END $

DELIMITER ;

CALL usp_get_employees_by_salary_level('High');

-- DEFINE FUNCTION
DELIMITER $
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))  
RETURNS TINYINT
DETERMINISTIC
BEGIN
	RETURN word REGEXP CONCAT('^[', set_of_letters, ']+$');
END $

DELIMITER ;

SELECT 'Sofia' REGEXP '^[oistmiahf]+$';
SELECT ufn_is_word_comprised('bobr', 'Rob');

-- FIND FULL NAME
DELIMITER $
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
	SELECT CONCAT(first_name, ' ', last_name) AS full_name
    FROM account_holders
    ORDER BY full_name;
END $

DELIMITER ;

CALL usp_get_holders_full_name();

-- PEOPLE WITH BALANCE HIGHER THAN
DELIMITER $
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(target_salary DECIMAL(19,4))
BEGIN
	SELECT ah.first_name, ah.last_name
    FROM account_holders ah
    JOIN accounts a ON ah.id = a.account_holder_id
    WHERE target_salary < (SELECT SUM(balance) 
						   FROM accounts
                           WHERE account_holder_id = ah.id
                           GROUP BY account_holder_id)
    GROUP BY ah.id
    ORDER BY ah.id;
END $

DELIMITER ;

CALL usp_get_holders_with_balance_higher_than(7000);

-- FUTURE VALUE FUNCTION
DELIMITER $
CREATE FUNCTION ufn_calculate_future_value(initial DECIMAL(19,4), interest_rate DECIMAL(19,4), numYears INT)  
RETURNS DECIMAL(19,4)
READS SQL DATA
BEGIN
	RETURN initial * POW(1 + interest_rate, numYears);
END $

DELIMITER ;

SELECT ufn_calculate_future_value(1000, 0.5, 5);

-- CALCULATING INTEREST
DELIMITER $
CREATE PROCEDURE usp_calculate_future_value_for_account(acc_id INT, interest DECIMAL(19,5))
BEGIN
	SELECT a.id AS account_id, 
    ah.first_name, ah.last_name, 
    a.balance AS current_balance,
    ufn_calculate_future_value(a.balance, interest, 5) AS balance_in_5_years
    FROM account_holders ah
    JOIN accounts a ON ah.id = a.account_holder_id
    WHERE a.id = acc_id;
END $

DELIMITER ;

CALL usp_calculate_future_value_for_account(1, 0.1);

-- DEPOSIT MONEY
DELIMITER $
CREATE PROCEDURE usp_deposit_money(acc_id INT, money_amount DECIMAL(10,4))
BEGIN
	START TRANSACTION;
	IF ((SELECT COUNT(*) FROM accounts WHERE id = acc_id) <> 1 
         OR money_amount < 0) 
         THEN ROLLBACK;
    ELSE 
		UPDATE accounts SET balance = balance + money_amount 
        WHERE id = acc_id;
        COMMIT;
	END IF; 
END $

DELIMITER ;

CALL usp_deposit_money(1, 10);

-- WITHDRAW MONEY
DELIMITER $
CREATE PROCEDURE usp_withdraw_money(acc_id INT, money_amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
	IF ((SELECT COUNT(*) FROM accounts WHERE id = acc_id) <> 1 OR
	    (SELECT balance FROM accounts WHERE id = acc_id) <= money_amount OR
	    money_amount < 0) THEN
		ROLLBACK;
	ELSE
		UPDATE accounts SET balance = balance - money_amount 
        WHERE id = acc_id;
        COMMIT;
	END IF;
END $

DELIMITER ;

CALL usp_withdraw_money(1, 10);

-- MONEY TRANSFER
DELIMITER $
CREATE PROCEDURE usp_transfer_money(acc_id INT, target_id INT, money_amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
	IF ((SELECT COUNT(*) FROM accounts WHERE id = acc_id) <> 1 
		OR (SELECT COUNT(*) FROM accounts WHERE id = target_id) <> 1 
        OR acc_id = target_id
        OR (SELECT balance FROM accounts WHERE id = acc_id) <= money_amount 
        OR money_amount < 0) 
        THEN ROLLBACK;
	ELSE
		UPDATE accounts SET balance = balance - money_amount WHERE id = acc_id;
		UPDATE accounts SET balance = balance + money_amount WHERE id = target_id;
        COMMIT;
	END IF;
END $

DELIMITER ;

CALL usp_transfer_money(1, 10);

-- LOG ACCOUNTS TRIGGER
CREATE TABLE logs(
	log_id INT PRIMARY KEY AUTO_INCREMENT,
	account_id INT NOT NULL,
	old_sum DECIMAL(19,4),
	new_sum DECIMAL(19,4)
);

DELIMITER $

CREATE TRIGGER tr_update
AFTER UPDATE
ON accounts
FOR EACH ROW
BEGIN
	INSERT INTO logs(account_id, old_sum, new_sum) 
    VALUES (old.id, old.balance, new.balance);
END $

DELIMITER ; 

CALL usp_deposit_money(1,10);
SELECT * FROM logs;

-- EMAILS TRIGGER
CREATE TABLE notification_emails(
	id INT PRIMARY KEY AUTO_INCREMENT,
	recipient INT NOT NULL,
	subject VARCHAR(2000),
	body TEXT
);

DELIMITER $

CREATE TRIGGER tr_insert
AFTER UPDATE
ON logs
FOR EACH ROW
BEGIN
	INSERT INTO notification_emails(recipient, subject, body) 
    VALUES (new.account_id,
    CONCAT('Balance change for account: ', new.account_id),
    CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y at %r'),
    ' your balance was changed from ', ROUND(new.old.sum, 0), ' to ',
    ROUND(new.new_sum, 0), '.'));
END $

DELIMITER ; 

SELECT DATE_FORMAT(NOW(), '%b %d %Y at %r');