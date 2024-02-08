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
-- NEWBIES
-- CARDS AGAINST HUMANITY
-- TOP 5 EMPLOYEES
-- BRANCH CARDS
-- EXTRACT CARD'S COUNT
-- CLIENT INFO