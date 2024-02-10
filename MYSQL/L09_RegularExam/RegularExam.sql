CREATE DATABASE preserves_db;
USE preserves_db;

-- TABLE DESIGN
CREATE TABLE continents(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE countries(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    country_code VARCHAR(10) NOT NULL UNIQUE,
    continent_id INT NOT NULL,
    FOREIGN KEY (continent_id) REFERENCES continents(id)
);

CREATE TABLE preserves(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    area INT, 
    type VARCHAR(20),
    established_on DATE
);

CREATE TABLE positions(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(40) NOT NULL UNIQUE,
    description TEXT,
    is_dangerous TINYINT(1) NOT NULL
);

CREATE TABLE workers(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    age INT,
    personal_number VARCHAR(20) NOT NULL UNIQUE,
    salary DECIMAL(19,2),
    is_armed TINYINT(1) NOT NULL, 
    start_date DATE, 
    preserve_id INT,
    position_id INT NOT NULL, 
    FOREIGN KEY (preserve_id) REFERENCES preserves(id),
    FOREIGN KEY (position_id) REFERENCES positions(id)
);

CREATE TABLE countries_preserves(
	country_id INT, 
    preserve_id INT,
    FOREIGN KEY (country_id) REFERENCES countries(id),
    FOREIGN KEY (preserve_id) REFERENCES preserves(id)
);

-- INSERT
INSERT INTO preserves (name, latitude, longitude, area, type, established_on)
SELECT CONCAT(name, ' is in South Hemisphere') AS name,
       latitude,
       longitude,
       area * id AS area,
       LOWER(type) AS type,
       established_on
FROM preserves
WHERE latitude < 0;

-- UPDATE
UPDATE workers
SET salary = salary + 500
WHERE position_id IN (5, 8, 11, 13);

-- DELETE 
DELETE FROM preserves
WHERE established_on IS NULL;

