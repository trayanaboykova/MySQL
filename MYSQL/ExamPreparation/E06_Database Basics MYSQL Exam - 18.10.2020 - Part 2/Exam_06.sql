CREATE DATABASE exam_06;
USE exam_06;

-- TABLE DESIGN
CREATE TABLE pictures(
	id INT PRIMARY KEY AUTO_INCREMENT,
    url VARCHAR(100) NOT NULL, 
    added_on DATETIME NOT NULL
);

CREATE TABLE categories(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE products(
	id INT PRIMARY KEY AUTO_INCREMENT, 
	name VARCHAR(40) NOT NULL UNIQUE,
    best_before DATE,
    price DECIMAL(10,2) NOT NULL, 
    description TEXT, 
    category_id INT NOT NULL,
    picture_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (picture_id) REFERENCES pictures(id)
);

CREATE TABLE towns(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE addresses(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    town_id INT NOT NULL,
    FOREIGN KEY (town_id) REFERENCES towns(id)
);

CREATE TABLE stores(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(20) NOT NULL UNIQUE, 
    rating FLOAT NOT NULL,
    has_parking BOOLEAN DEFAULT FALSE,
    address_id INT NOT NULL,  
    FOREIGN KEY (address_id) REFERENCES addresses(id)
);

CREATE TABLE products_stores (
    product_id INT NOT NULL,
    store_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (store_id) REFERENCES stores(id),
    PRIMARY KEY (product_id, store_id)
);

CREATE TABLE employees(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    first_name VARCHAR(15) NOT NULL, 
    middle_name CHAR(1),
    last_name VARCHAR(20) NOT NULL, 
    salary DECIMAL(19,2) DEFAULT 0, 
    hire_date DATE NOT NULL, 
    manager_id INT, 
    store_id INT NOT NULL,
	FOREIGN KEY (manager_id) REFERENCES employees (id),
	FOREIGN KEY (store_id) REFERENCES stores (id)
);

-- INSERT
INSERT INTO products_stores (product_id, store_id)
SELECT p.id AS product_id, 1 AS store_id
FROM products p
LEFT JOIN products_stores ps ON p.id = ps.product_id
WHERE ps.product_id IS NULL;

-- UPDATE
UPDATE employees
SET manager_id = 3, salary = salary - 500
WHERE YEAR(hire_date) > 2003
  AND store_id NOT IN (SELECT id FROM stores WHERE name IN ('Cardguard', 'Veribet'));

-- DELETE
DELETE FROM employees
WHERE manager_id IS NOT NULL
  AND salary >= 6000;

-- EMPLOYEES
SELECT
    first_name,
    middle_name,
    last_name,
    salary,
    hire_date
FROM
    employees
ORDER BY
    hire_date DESC;

-- PRODUCTS WITH OLD PICTURES
SELECT
    name AS product_name,
    price,
    best_before,
    CONCAT(SUBSTRING(description, 1, 10), '...') AS short_description,
    pictures.url AS url
FROM
    products
JOIN
    pictures ON products.picture_id = pictures.id
WHERE
    LENGTH(description) > 100
    AND YEAR(pictures.added_on) < 2019
    AND price > 20
ORDER BY
    price DESC;

-- COUNTS OF PRODUCTS IN STORES
SELECT
    s.name AS store_name,
    COUNT(ps.product_id) AS product_count,
    ROUND(AVG(p.price), 2) AS avg
FROM
    stores s
LEFT JOIN
    products_stores ps ON s.id = ps.store_id
LEFT JOIN
    products p ON ps.product_id = p.id
GROUP BY
    s.id, s.name
ORDER BY
    product_count DESC, avg DESC, s.id;

-- SPECIFIC EMPLOYEE
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS Full_name,
    s.name AS Store_name,
    a.name AS Address,
    e.salary
FROM
    employees e
JOIN
    stores s ON e.store_id = s.id
JOIN
    addresses a ON s.address_id = a.id
WHERE
    e.salary < 4000
    AND a.name LIKE '%5%'
    AND LENGTH(s.name) > 8
    AND e.last_name LIKE '%n';

-- FIND ALL INFORMATION OF STORES
SELECT
    REVERSE(s.name) AS reversed_name,
    CONCAT(UPPER(t.name), '-', a.name) AS full_address,
    IFNULL(COUNT(e.id), 0) AS employees_count
FROM
    stores s
JOIN
    addresses a ON s.address_id = a.id
JOIN
    towns t ON a.town_id = t.id
LEFT JOIN
    employees e ON s.id = e.store_id
GROUP BY
    s.id, reversed_name, full_address
HAVING
    employees_count > 0
ORDER BY
    full_address ASC;

-- FIND NAME OF TOP PAID EMPLOYEE BY STORE NAME
DELIMITER //
CREATE FUNCTION udf_top_paid_employee_by_store(store_name VARCHAR(50)) RETURNS VARCHAR(100)
BEGIN
    DECLARE full_info VARCHAR(100);

    SELECT CONCAT(
        e.first_name, ' ', IFNULL(CONCAT(e.middle_name, '. '), ''),
        e.last_name, ' works in store for ',
        TIMESTAMPDIFF(YEAR, e.hire_date, '2020-10-18'), ' years'
    )
    INTO full_info
    FROM employees e
    JOIN stores s ON e.store_id = s.id
    WHERE s.name = store_name
    ORDER BY e.salary DESC
    LIMIT 1;

    RETURN full_info;
END//
DELIMITER ;

-- UPDATE PRODUCT PRICE BY ADDRESS
DELIMITER //
CREATE PROCEDURE udp_update_product_price (IN address_name VARCHAR(50))
BEGIN
    DECLARE price_increase DECIMAL(10, 2);
    
    IF LEFT(address_name, 1) = '0' THEN
        SET price_increase = 100;
    ELSE
        SET price_increase = 200;
    END IF;

    UPDATE products p
    JOIN products_stores ps ON p.id = ps.product_id
    JOIN stores s ON ps.store_id = s.id
    JOIN addresses a ON s.address_id = a.id
    SET p.price = p.price + price_increase
    WHERE a.name = address_name;
    
END //
DELIMITER ;