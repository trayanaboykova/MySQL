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
    
-- FLIGHTS FROM 2022
SELECT
    flight_code,
    departure_country,
    airplane_id,
    departure
FROM
    flights
WHERE
    YEAR(departure) = 2022
ORDER BY
    airplane_id ASC, flight_code ASC
LIMIT 20;

-- PRIVATE FLIGHTS
SELECT
    CONCAT(UPPER(SUBSTRING(last_name, 1, 2)), country_id) AS flight_code,
    CONCAT(first_name, ' ', last_name) AS full_name,
    country_id
FROM
    passengers
WHERE
    id NOT IN (SELECT DISTINCT passenger_id FROM flights_passengers)
ORDER BY
    country_id ASC;

-- LEADING DESTINATIONS
SELECT
    c.name AS name,
    c.currency AS currency,
    COUNT(fp.passenger_id) AS booked_tickets
FROM
    countries c
JOIN
    flights f ON c.id = f.destination_country
LEFT JOIN
    flights_passengers fp ON f.id = fp.flight_id
GROUP BY
    c.id
HAVING
    booked_tickets >= 20
ORDER BY
    booked_tickets DESC;

-- PARTS OF THE DAY 
SELECT
    flight_code,
    departure,
    CASE
        WHEN TIME(departure) BETWEEN '05:00:00' AND '11:59:59' THEN 'Morning'
        WHEN TIME(departure) BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN TIME(departure) BETWEEN '17:00:00' AND '20:59:59' THEN 'Evening'
        ELSE 'Night'
    END AS day_part
FROM
    flights
ORDER BY
    flight_code DESC;
    
-- NUMBER OF FLIGHTS
DELIMITER $

CREATE FUNCTION udf_count_flights_from_country(countryName VARCHAR(50))
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE flightsCount INT;

    SELECT COUNT(*)
    INTO flightsCount
    FROM flights
    WHERE departure_country = (SELECT id FROM countries WHERE name = countryName);

    RETURN flightsCount;
END $

DELIMITER ;


-- DELAY FLIGHT
DELIMITER $

CREATE PROCEDURE udp_delay_flight(IN flightCode VARCHAR(50))
BEGIN
    DECLARE departureTime DATETIME;
    SELECT departure INTO departureTime
    FROM flights
    WHERE flight_code = flightCode;
    
    SET departureTime = DATE_ADD(departureTime, INTERVAL 30 MINUTE);
    
    UPDATE flights
    SET departure = departureTime, has_delay = 1
    WHERE flight_code = flightCode;
    
END $

DELIMITER ;