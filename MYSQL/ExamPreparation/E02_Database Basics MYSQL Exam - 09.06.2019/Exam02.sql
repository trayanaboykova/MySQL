CREATE DATABASE exam_02;
USE exam_02;

-- TABLE DESIGN
CREATE TABLE branches(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE employees(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(10,2) NOT NULL, 
    started_on DATE NOT NULL, 
    branch_id INT NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES branches(id)
);

CREATE TABLE clients(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    full_name VARCHAR(50) NOT NULL,
    age INT NOT NULL
);

CREATE TABLE employees_clients(
	employee_id INT, 
    client_id INT, 
    FOREIGN KEY (employee_id) REFERENCES employees(id),
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE TABLE bank_accounts(
	id INT PRIMARY KEY AUTO_INCREMENT,
    account_number VARCHAR(10) NOT NULL, 
    balance DECIMAL(10,2) NOT NULL, 
    client_id INT NOT NULL UNIQUE, 
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE TABLE cards(
	id INT PRIMARY KEY AUTO_INCREMENT,
    card_number VARCHAR(19) NOT NULL,
    card_status VARCHAR(7) NOT NULL,
    bank_account_id INT NOT NULL, 
    FOREIGN KEY (bank_account_id) REFERENCES bank_accounts(id)
);

-- INSERT
INSERT INTO cards (card_number, card_status, bank_account_id)
SELECT REVERSE(c.full_name), 'Active', c.id
FROM clients c
WHERE c.id BETWEEN 191 AND 200;

-- UPDATE
UPDATE employees_clients AS ec
JOIN (
    SELECT ec2.employee_id
    FROM employees_clients AS ec2
    GROUP BY ec2.employee_id
    ORDER BY COUNT(ec2.client_id)
    LIMIT 1
) AS eid ON ec.employee_id = ec.client_id
SET ec.employee_id = eid.employee_id;

-- DELETE
DELETE FROM employees
WHERE id NOT IN (
    SELECT DISTINCT employee_id
    FROM employees_clients
);

-- CLIENTS
SELECT id, full_name
FROM clients
ORDER BY id ASC;

-- NEWBIES
SELECT id,
       CONCAT(first_name, ' ', last_name) AS full_name,
       CONCAT('$', salary) AS salary,
       started_on
FROM employees
WHERE salary >= 100000 AND started_on >= '2018-01-01'
ORDER BY salary DESC, id;

-- CARDS AGAINST HUMANITY
SELECT c.id,
       CONCAT(c.card_number, ' : ', cl.full_name) AS card_token
FROM cards c
JOIN bank_accounts ba ON c.bank_account_id = ba.id
JOIN clients cl ON ba.client_id = cl.id
ORDER BY c.id DESC;

-- TOP 5 EMPLOYEES
SELECT CONCAT(e.first_name, ' ', e.last_name) AS name,
       e.started_on,
       COUNT(ec.client_id) AS count_of_clients
FROM employees e
LEFT JOIN employees_clients ec ON e.id = ec.employee_id
GROUP BY e.id
ORDER BY count_of_clients DESC, e.id ASC
LIMIT 5;

-- BRANCH CARDS
SELECT b.name AS name, COUNT(c.id) AS count_of_cards
FROM branches b
LEFT JOIN employees e ON b.id = e.branch_id
LEFT JOIN employees_clients ec ON e.id = ec.employee_id
LEFT JOIN clients cl ON ec.client_id = cl.id
LEFT JOIN bank_accounts ba ON cl.id = ba.client_id
LEFT JOIN cards c ON ba.id = c.bank_account_id
GROUP BY b.id
ORDER BY count_of_cards DESC, name;

-- EXTRACT CARD'S COUNT
DELIMITER $

CREATE FUNCTION udf_client_cards_count(full_name VARCHAR(50))
RETURNS INT
BEGIN
    DECLARE card_count INT;
    
    SELECT COUNT(cards.id) INTO card_count
    FROM clients
    JOIN bank_accounts ON clients.id = bank_accounts.client_id
    JOIN cards ON bank_accounts.id = cards.bank_account_id
    WHERE clients.full_name = full_name;
    
    RETURN card_count;
END$

DELIMITER ;

-- CLIENT INFO
DELIMITER $

CREATE PROCEDURE udp_clientinfo(
    IN p_full_name VARCHAR(50)
)
BEGIN
    DECLARE v_age INT;
    DECLARE v_account_number VARCHAR(10);
    DECLARE v_balance DECIMAL(10,2);
    
    SELECT age, account_number, REPLACE(FORMAT(balance, 2), ',', '') AS balance
    INTO v_age, v_account_number, v_balance
    FROM (
        SELECT c.age, ba.account_number, SUM(b.balance) AS balance
        FROM clients c
        JOIN bank_accounts ba ON c.id = ba.client_id
        JOIN bank_accounts b ON c.id = b.client_id
        WHERE c.full_name = p_full_name
        GROUP BY c.age, ba.account_number
    ) AS temp;
    
    SELECT p_full_name, v_age, v_account_number, CONCAT('$', v_balance);
END$

DELIMITER ;