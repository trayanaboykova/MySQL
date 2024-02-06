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
-- DRIVERS AND CARS
-- NUMBER OF COURSES
-- REGULAR CLIENTS
-- FULL INFO FOR COURSES
-- FIND ALL COURSES BY CLIENT’S PHONE NUMBER
-- FULL INFO FOR ADDRESS