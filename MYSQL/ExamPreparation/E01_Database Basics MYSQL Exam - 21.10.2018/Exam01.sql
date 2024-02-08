CREATE DATABASE exam_01;
USE exam_01;

-- TABLE DESIGN
CREATE TABLE planets(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE spaceports(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    planet_id INT,
    FOREIGN KEY (planet_id) REFERENCES planets(id)
);

CREATE TABLE spaceships(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    manufacturer VARCHAR(30) NOT NULL,
    light_speed_rate INT DEFAULT 0
);

CREATE TABLE colonists(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    ucn CHAR(10) NOT NULL UNIQUE, 
    birth_date DATE NOT NULL
);

CREATE TABLE journeys (
    id INT AUTO_INCREMENT PRIMARY KEY,
    journey_start DATETIME NOT NULL,
    journey_end DATETIME NOT NULL,
    purpose ENUM ('Medical', 'Technical', 'Educational', 'Military'),
    destination_spaceport_id INT,
    spaceship_id INT,
    FOREIGN KEY (destination_spaceport_id) REFERENCES spaceports(id),
    FOREIGN KEY (spaceship_id) REFERENCES spaceships(id)
);

CREATE TABLE travel_cards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    card_number CHAR(10) NOT NULL UNIQUE,
    job_during_journey ENUM ('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook'),
    colonist_id INT,
    journey_id INT,
    FOREIGN KEY (colonist_id) REFERENCES colonists(id),
    FOREIGN KEY (journey_id) REFERENCES journeys(id)
);

-- INSERT
INSERT INTO travel_cards (card_number, job_during_journey, colonist_id, journey_id)
SELECT 
    CASE 
        WHEN c.birth_date > '1980-01-01' THEN CONCAT(YEAR(c.birth_date), DAY(c.birth_date), LEFT(c.ucn, 4))
        ELSE CONCAT(YEAR(c.birth_date), MONTH(c.birth_date), RIGHT(c.ucn, 4))
    END AS card_number,
    CASE 
        WHEN c.id % 2 = 0 THEN 'Pilot'
        WHEN c.id % 3 = 0 THEN 'Cook'
        ELSE 'Engineer'
    END AS job_during_journey,
    c.id AS colonist_id,
    LEFT(c.ucn, 1) AS journey_id
FROM colonists c
WHERE c.id BETWEEN 96 AND 100;

-- UPDATE
UPDATE journeys 
INNER JOIN (
    SELECT id,
           CASE 
               WHEN id % 2 = 0 THEN 'Medical'
               WHEN id % 3 = 0 THEN 'Technical'
               WHEN id % 5 = 0 THEN 'Educational'
               WHEN id % 7 = 0 THEN 'Military'
           END AS new_purpose
    FROM journeys 
    WHERE id % 2 = 0 OR id % 3 = 0 OR id % 5 = 0 OR id % 7 = 0
) AS derived_table ON journeys.id = derived_table.id
SET journeys.purpose = derived_table.new_purpose;

-- DELETE
DELETE FROM colonists
WHERE id NOT IN (
    SELECT colonist_id FROM travel_cards
);

-- EXTRACT ALL TRAVEL CARDS
-- EXTRACT ALL COLONISTS
-- EXTRACT ALL MILITARY JOURNEYS
-- EXTRACT ALL PILOTS
-- COUNT ALL COLONISTS
-- EXTRACT THE FASTEST SPACESHIP
-- EXTRACT - PILOTS YOUNGER THAN 30 YEARS
-- EXTRACT ALL EDUCATIONAL MISSION
-- EXTRACT ALL PLANETS AND THEIR JOURNEY COUNT
-- EXTRACT THE SHORTEST JOURNEY
-- EXTRACT THE LESS POPULAR JOB
-- GET COLONISTS COUNT
-- MODIFY SPACESHIP