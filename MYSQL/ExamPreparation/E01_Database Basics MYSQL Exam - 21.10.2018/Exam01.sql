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
SELECT card_number, job_during_journey
FROM travel_cards
ORDER BY card_number ASC;

-- EXTRACT ALL COLONISTS
SELECT id,
       CONCAT(first_name, ' ', last_name) AS full_name,
       ucn
FROM colonists
ORDER BY first_name ASC, last_name ASC, id ASC;

-- EXTRACT ALL MILITARY JOURNEYS
SELECT id, journey_start, journey_end
FROM journeys
WHERE purpose = 'Military'
ORDER BY journey_start ASC;

-- EXTRACT ALL PILOTS
SELECT c.id,
       CONCAT(c.first_name, ' ', c.last_name) AS full_name
FROM colonists c
JOIN travel_cards tc ON c.id = tc.colonist_id
WHERE tc.job_during_journey = 'Pilot'
ORDER BY c.id ASC;

-- COUNT ALL COLONISTS
SELECT COUNT(DISTINCT colonist_id) AS count
FROM travel_cards
WHERE journey_id IN (
    SELECT id
    FROM journeys
    WHERE purpose = 'Technical'
);

-- EXTRACT THE FASTEST SPACESHIP
SELECT s.name AS spaceship_name, 
       sp.name AS spaceport_name
FROM spaceships s
JOIN journeys j ON s.id = j.spaceship_id
JOIN spaceports sp ON j.destination_spaceport_id = sp.id
WHERE s.light_speed_rate = (
    SELECT MAX(light_speed_rate) FROM spaceships
);

-- EXTRACT - PILOTS YOUNGER THAN 30 YEARS
SELECT DISTINCT s.name, s.manufacturer
FROM spaceships s
WHERE s.id IN (
    SELECT DISTINCT j.spaceship_id
    FROM journeys j
    JOIN travel_cards tc ON j.id = tc.journey_id
    JOIN colonists c ON tc.colonist_id = c.id
    WHERE c.birth_date > DATE_SUB('2019-01-01', INTERVAL 30 YEAR)
    AND tc.job_during_journey = 'Pilot'
)
ORDER BY s.name ASC;

-- EXTRACT ALL EDUCATIONAL MISSION
SELECT DISTINCT p.name AS planet_name, sp.name AS spaceport_name
FROM planets p
JOIN spaceports sp ON p.id = sp.planet_id
JOIN journeys j ON sp.id = j.destination_spaceport_id
WHERE j.purpose = 'Educational'
ORDER BY sp.name DESC;

-- EXTRACT ALL PLANETS AND THEIR JOURNEY COUNT
WITH JourneyCounts AS (
    SELECT sp.planet_id, COUNT(j.id) AS journeys_count
    FROM spaceports sp
    LEFT JOIN journeys j ON sp.id = j.destination_spaceport_id
    GROUP BY sp.planet_id
)
SELECT p.name AS planet_name, jc.journeys_count AS journeys_count
FROM planets p
JOIN JourneyCounts jc ON p.id = jc.planet_id
WHERE jc.journeys_count > 0
ORDER BY journeys_count DESC, planet_name ASC;

-- EXTRACT THE SHORTEST JOURNEY
SELECT j.id AS id,
       p.name AS planet_name,
       sp.name AS spaceport_name,
       j.purpose AS journey_purpose
FROM journeys j
JOIN spaceports sp ON j.destination_spaceport_id = sp.id
JOIN planets p ON sp.planet_id = p.id
ORDER BY TIMESTAMPDIFF(SECOND, j.journey_start, j.journey_end) ASC
LIMIT 1;

-- EXTRACT THE LESS POPULAR JOB
SELECT tc.job_during_journey AS job_name
FROM journeys j
JOIN travel_cards tc ON j.id = tc.journey_id
WHERE j.journey_end - j.journey_start = (
    SELECT MAX(journey_end - journey_start)
    FROM journeys
)
GROUP BY tc.job_during_journey
ORDER BY COUNT(tc.colonist_id) ASC
LIMIT 1;

-- GET COLONISTS COUNT
DELIMITER $
CREATE FUNCTION udf_count_colonists_by_destination_planet(planet_name VARCHAR(30))
RETURNS INT
BEGIN
    DECLARE colonist_count INT;
    
    SELECT COUNT(c.id) INTO colonist_count
    FROM colonists c
    JOIN travel_cards tc ON c.id = tc.colonist_id
    JOIN journeys j ON tc.journey_id = j.id
    JOIN spaceports sp ON j.destination_spaceport_id = sp.id
    JOIN planets p ON sp.planet_id = p.id
    WHERE p.name = planet_name;

    RETURN colonist_count;
END$

DELIMITER ;

-- MODIFY SPACESHIP
DELIMITER //

CREATE PROCEDURE udp_modify_spaceship_light_speed_rate(
    IN spaceship_name VARCHAR(50),
    IN light_speed_rate_increase INT
)
BEGIN
    DECLARE existing_spaceship INT;
	SELECT COUNT(*) INTO existing_spaceship
    FROM spaceships
    WHERE name = spaceship_name;
    IF existing_spaceship = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Spaceship you are trying to modify does not exist.';
    ELSE
        UPDATE spaceships
        SET light_speed_rate = light_speed_rate + light_speed_rate_increase
        WHERE name = spaceship_name;
    END IF;
END //

DELIMITER ;
