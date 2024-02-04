CREATE DATABASE exam_12;
USE exam_12;

-- TABLE DESIGN
CREATE TABLE countries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    description TEXT,
    currency VARCHAR(5) NOT NULL
);

CREATE TABLE airplanes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    model VARCHAR(50) NOT NULL UNIQUE,
    passengers_capacity INT NOT NULL,
    tank_capacity DECIMAL(19 , 2 ) NOT NULL,
    cost DECIMAL(19 , 2 ) NOT NULL
);

CREATE TABLE passengers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id)
		REFERENCES countries(id)
);

CREATE TABLE flights (
    id INT PRIMARY KEY AUTO_INCREMENT,
    flight_code VARCHAR(30) NOT NULL UNIQUE,
    departure_country INT,
    destination_country INT, 
    airplane_id INT,
    has_delay BOOLEAN,
    departure DATETIME,
    FOREIGN KEY (departure_country)
		REFERENCES countries(id),
	FOREIGN KEY (destination_country)
		REFERENCES countries(id),
	FOREIGN KEY (airplane_id)
		REFERENCES airplanes(id)
);

CREATE TABLE flights_passengers (
    flight_id INT,
    passenger_id INT,
    FOREIGN KEY (flight_id)
        REFERENCES flights (id),
    FOREIGN KEY (passenger_id)
        REFERENCES passengers (id)
);

-- INSERT
INSERT INTO airplanes (model, passengers_capacity, tank_capacity, cost)
SELECT
    CONCAT(REVERSE(first_name), '797') AS model,
    LENGTH(last_name) * 17 AS passengers_capacity,
    id * 790 AS tank_capacity,
    LENGTH(first_name) * 50.6 AS cost
FROM passengers
WHERE id <= 5;

-- UPDATE
UPDATE flights
SET airplane_id = airplane_id + 1
WHERE departure_country = (SELECT id FROM countries WHERE name = 'Armenia');

-- DELETE
DELETE FROM flights
WHERE id NOT IN (SELECT DISTINCT flight_id FROM flights_passengers);

-- AIRPLANES
SELECT
    id,
    model,
    passengers_capacity,
    tank_capacity,
    cost
FROM
    airplanes
ORDER BY
    cost DESC, id DESC;

