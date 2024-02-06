CREATE DATABASE exam_07;
USE exam_07;

-- TABLE DESIGN
CREATE TABLE addresses(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE categories(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(10) NOT NULL 
);

CREATE TABLE clients(
	id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age INT NOT NULL,
	rating FLOAT DEFAULT 5.5
);

CREATE TABLE cars(
	id INT PRIMARY KEY AUTO_INCREMENT,
    make VARCHAR(20) NOT NULL, 
    model VARCHAR(20),
    year INT NOT NULL DEFAULT 0,
    mileage INT DEFAULT 0,
    `condition` CHAR(1) NOT NULL,
    category_id INT NOT NULL, 
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE courses(
	id INT PRIMARY KEY AUTO_INCREMENT,
    from_address_id INT NOT NULL,
    start DATETIME NOT NULL, 
    car_id INT, 
    client_id INT,
    bill DECIMAL(10,2) DEFAULT 10,
	FOREIGN KEY (from_address_id) REFERENCES addresses(id),
	FOREIGN KEY (car_id) REFERENCES cars(id),
	FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE TABLE cars_drivers(
	car_id INT NOT NULL,
    driver_id INT NOT NULL,
    PRIMARY KEY (car_id, driver_id),
    FOREIGN KEY (car_id) REFERENCES cars(id),
    FOREIGN KEY (driver_id) REFERENCES drivers(id)
);

-- INSERT
INSERT INTO clients (full_name, phone_number)
SELECT CONCAT(first_name, ' ', last_name), CONCAT('(088) 9999', id * 2)
FROM drivers
WHERE id BETWEEN 10 AND 20;

-- UPDATE
UPDATE cars
SET `condition` = 'C'
WHERE (mileage > 800000 OR mileage IS NULL) AND year <= 2010 AND make != 'Mercedes-Benz';

-- DELETE
DELETE FROM clients
WHERE LENGTH(full_name) > 3
AND id NOT IN (SELECT DISTINCT client_id FROM courses);

-- CARS
SELECT make, model, `condition`
FROM cars
ORDER BY id;

-- DRIVERS AND CARS
SELECT
    d.first_name,
    d.last_name,
    c.make,
    c.model,
    c.mileage
FROM
    drivers d
JOIN
    cars_drivers cd ON d.id = cd.driver_id
JOIN
    cars c ON cd.car_id = c.id
WHERE
    c.mileage IS NOT NULL
ORDER BY
    c.mileage DESC,
    d.first_name;

-- NUMBER OF COURSES
SELECT
    c.id AS car_id,
    c.make,
    c.mileage,
    IFNULL(COUNT(co.car_id), 0) AS count_of_courses,
    ROUND(AVG(co.bill), 2) AS avg_bill
FROM
    cars c
LEFT JOIN
    courses co ON c.id = co.car_id
GROUP BY
    c.id, c.make, c.mileage
HAVING
    count_of_courses != 2 OR count_of_courses IS NULL
ORDER BY
    count_of_courses DESC,
    car_id;

-- REGULAR CLIENTS
SELECT
    c.full_name,
    COUNT(DISTINCT co.car_id) AS count_of_cars,
    SUM(co.bill) AS total_sum
FROM
    clients c
JOIN
    courses co ON c.id = co.client_id
WHERE
    SUBSTRING(c.full_name, 2, 1) = 'a'
GROUP BY
    c.full_name
HAVING
    count_of_cars > 1
ORDER BY
    c.full_name;

-- FULL INFO FOR COURSES
SELECT
    a.name AS name,
    CASE
        WHEN HOUR(co.start) BETWEEN 6 AND 20 THEN 'Day'
        ELSE 'Night'
    END AS day_time,
    co.bill AS bill,
    cl.full_name AS full_name,
    ca.make AS make,
    ca.model AS model,
    cat.name AS category_name
FROM
    courses co
JOIN
    addresses a ON co.from_address_id = a.id
JOIN
    clients cl ON co.client_id = cl.id
JOIN
    cars ca ON co.car_id = ca.id
JOIN
    categories cat ON ca.category_id = cat.id
ORDER BY
    co.id;

-- FIND ALL COURSES BY CLIENT’S PHONE NUMBER
-- FULL INFO FOR ADDRESS