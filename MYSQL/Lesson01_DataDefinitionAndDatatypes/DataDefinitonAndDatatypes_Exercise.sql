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
INSERT INTO towns (name) VALUES
('Sofia'),
('Plovdiv'),
('Varna');

INSERT INTO minions (name, age, town_id) VALUES
('Kevin', 22, 1),
('Bob', 15, 3),
('Steward', NULL, 2);



