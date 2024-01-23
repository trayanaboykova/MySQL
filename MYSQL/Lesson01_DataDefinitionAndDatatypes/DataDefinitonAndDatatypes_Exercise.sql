-- create database
CREATE DATABASE minions;

-- create tables
CREATE TABLE minions (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT
);

CREATE TABLE towns (
 town_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

-- alter minions table
ALTER TABLE minions
ADD COLUMN town_id INT;

ALTER TABLE minions
ADD CONSTRAINT fk_town
FOREIGN KEY (town_id)
REFERENCES towns(id);

-- insert records in both tables
INSERT INTO towns (id, name) VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

INSERT INTO minions (id, name, age, town_id) VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);




