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
-- UPDATE
-- DELETE
-- USERS
-- EXTRACT 5 MOST COMMENTED PHOTOS
-- LUCKY USERS
-- COUNT LIKES AND COMMENTS
-- THE PHOTO ON THE TENTH DAY OF THE MONTH
-- GET USER’S PHOTOS COUNT
-- INCREASE USER AGE