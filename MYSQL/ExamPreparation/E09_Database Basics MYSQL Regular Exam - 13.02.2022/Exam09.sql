CREATE DATABASE exam_09;
USE exam_09;

-- TABLE DESIGN
CREATE TABLE brands(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE categories(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE reviews(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    content TEXT,
    rating DECIMAL(10,2) NOT NULL,
    picture_url VARCHAR(80) NOT NULL,
    published_at DATETIME NOT NULL
);

CREATE TABLE products(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL, 
    price DECIMAL(19,2) NOT NULL, 
    quantity_in_stock INT, 
    description TEXT, 
    brand_id INT NOT NULL, 
    category_id INT NOT NULL, 
    review_id INT,
    FOREIGN KEY (brand_id) REFERENCES brands(id),
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (review_id) REFERENCES reviews(id)
);

CREATE TABLE customers(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    phone VARCHAR(30) NOT NULL UNIQUE, 
    address VARCHAR(60) NOT NULL, 
	discount_card BIT(1) NOT NULL DEFAULT FALSE
);

CREATE TABLE orders(
	id INT PRIMARY KEY AUTO_INCREMENT,
    order_datetime DATETIME NOT NULL, 
    customer_id INT NOT NULL, 
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE orders_products(
	order_id INT, 
    product_id INT, 
	FOREIGN KEY (order_id) REFERENCES orders(id),
	FOREIGN KEY (product_id) REFERENCES products(id)
);

-- INSERT
INSERT INTO reviews (content, picture_url, published_at, rating)
SELECT 
    SUBSTRING(description, 1, 15) AS content,
    REVERSE(name) AS picture_url,
    '2010-10-10' AS published_at,
    price / 8 AS rating
FROM products
WHERE id >= 5;

-- UPDATE
UPDATE products
SET quantity_in_stock = quantity_in_stock - 5
WHERE quantity_in_stock BETWEEN 60 AND 70;

-- DELETE
DELETE FROM customers
WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders);

-- CATEGORIES
SELECT id, name
FROM categories
ORDER BY name DESC;

-- QUANTITY
SELECT id, brand_id, name, quantity_in_stock
FROM products
WHERE price > 1000 AND quantity_in_stock < 30
ORDER BY quantity_in_stock ASC, id ASC;

-- REVIEW
SELECT id, content, rating, picture_url, published_at
FROM reviews
WHERE content LIKE 'My%' AND LENGTH(content) > 61
ORDER BY rating DESC;

-- FIRST CUSTOMERS
SELECT CONCAT(first_name, ' ', last_name) AS full_name, address, order_datetime
FROM customers
JOIN orders ON customers.id = orders.customer_id
WHERE YEAR(order_datetime) <= 2018
ORDER BY full_name DESC;

-- BEST CATEGORIES
SELECT 
    COUNT(products.id) AS items_count,
    categories.name,
    SUM(products.quantity_in_stock) AS total_quantity
FROM 
    categories
JOIN 
    products ON categories.id = products.category_id
GROUP BY 
    categories.id, categories.name
ORDER BY 
    items_count DESC, total_quantity ASC
LIMIT 5;

-- EXTRACT CLIENT CARDS COUNT
DELIMITER //
CREATE FUNCTION udf_customer_products_count(fname VARCHAR(30)) RETURNS INT
BEGIN
    DECLARE total_count INT;
    
    SELECT COUNT(orders_products.product_id)
    INTO total_count
    FROM customers
    JOIN orders ON customers.id = orders.customer_id
    JOIN orders_products ON orders.id = orders_products.order_id
    WHERE customers.first_name = fname;
    
    RETURN total_count;
END //
DELIMITER ;

-- REDUCE PRICE
DELIMITER $$

CREATE PROCEDURE udp_reduce_price(category_name VARCHAR(50))
BEGIN
    UPDATE products AS p
    JOIN reviews AS r ON r.id = p.review_id
    JOIN categories AS c ON c.id = p.category_id
    SET p.price = ROUND(p.price * 0.7, 2)
    WHERE r.rating < 4
    AND c.name = category_name;
END $$

DELIMITER ;