CREATE DATABASE exam_11;
USE exam_11;

-- TABLE DESIGN
CREATE TABLE products(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    type VARCHAR(30) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE clients(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthdate DATE, 
    card VARCHAR(50),
    review TEXT
);

CREATE TABLE tables(
	id INT PRIMARY KEY AUTO_INCREMENT,
    floor INT NOT NULL, 
    reserved BOOLEAN,
    capacity INT NOT NULL
);

CREATE TABLE waiters(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    salary DECIMAL(10,2)
);

CREATE TABLE orders(
	id INT PRIMARY KEY AUTO_INCREMENT,
    table_id INT NOT NULL,
    waiter_id INT NOT NULL, 
    order_time TIME, 
    payed_status BOOLEAN,
    FOREIGN KEY (table_id) REFERENCES tables(id),
    FOREIGN KEY (waiter_id) REFERENCES waiters(id)
);

CREATE TABLE orders_clients(
	order_id INT,
    client_id INT, 
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE TABLE orders_products(
	order_id INT,
    product_id INT, 
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- INSERT 
INSERT INTO products (name, type, price)
SELECT CONCAT(last_name, ' specialty'), 'Cocktail', CEIL(salary * 0.01)
FROM waiters
WHERE id > 6;

-- UPDATE
UPDATE orders
SET table_id = table_id - 1
WHERE id BETWEEN 12 AND 23;

-- DELETE
DELETE FROM waiters
WHERE id NOT IN (SELECT DISTINCT waiter_id FROM orders);


-- CLIENTS
SELECT id, first_name, last_name, birthdate, card, review
FROM clients
ORDER BY birthdate DESC, id DESC;

-- BIRTHDATE
SELECT first_name, last_name, birthdate, review
FROM clients
WHERE card IS NULL AND birthdate BETWEEN '1978-01-01' AND '1993-12-31'
ORDER BY last_name DESC, id ASC
LIMIT 5;

-- ACCOUNTS
SELECT CONCAT(last_name, first_name, LENGTH(first_name), 'Restaurant') AS username,
       REVERSE(SUBSTRING(email, 2, 12)) AS password
FROM waiters
WHERE salary IS NOT NULL
ORDER BY password DESC;

-- TOP FROM MENU
SELECT op.product_id AS id,
       p.name,
       COUNT(op.product_id) AS count
FROM orders_products op
JOIN products p ON op.product_id = p.id
GROUP BY op.product_id, p.name
HAVING count >= 5
ORDER BY count DESC, p.name ASC;

-- AVAILABILITY
SELECT
    t.id AS table_id,
    t.capacity,
    COUNT(oc.client_id) AS count_clients,
    CASE
        WHEN COUNT(oc.client_id) < t.capacity THEN 'Free seats'
        WHEN COUNT(oc.client_id) = t.capacity THEN 'Full'
        ELSE 'Extra seats'
    END AS availability
FROM
    tables t
JOIN orders o ON t.id = o.table_id
JOIN orders_clients oc ON o.id = oc.order_id
WHERE
    t.floor = 1
GROUP BY
    t.id
ORDER BY
    t.id DESC;

-- EXTRACT BILL
DELIMITER $

CREATE FUNCTION udf_client_bill(full_name VARCHAR(50)) RETURNS DECIMAL(19,2)
BEGIN
    DECLARE total_bill DECIMAL(19,2);

    SELECT
        SUM(p.price) INTO total_bill
    FROM
        clients c
    JOIN orders_clients oc ON c.id = oc.client_id
    JOIN orders o ON oc.order_id = o.id
    JOIN orders_products op ON o.id = op.order_id
    JOIN products p ON op.product_id = p.id
    WHERE
        CONCAT(c.first_name, ' ', c.last_name) = full_name;

    RETURN total_bill;
END $

DELIMITER ;

-- HAPPY HOUR
DELIMITER $$

CREATE PROCEDURE udp_happy_hour(IN product_type VARCHAR(50))
BEGIN
    UPDATE products
    SET price = price * 0.8
    WHERE type = product_type AND price >= 10;
END $$

DELIMITER ;