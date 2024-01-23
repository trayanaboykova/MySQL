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

-- truncate table minions
USE minions;
TRUNCATE TABLE minions;

-- drop all tables
USE minions;
DROP table minions, towns;

-- create table people
CREATE TABLE people (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    picture BLOB,
    height DOUBLE,
    weight DOUBLE,
    gender ENUM('m', 'f') NOT NULL,
    birthdate VARCHAR(200) NOT NULL,
    biography TEXT
);

INSERT INTO people (name, picture, height, weight, gender, birthdate, biography) VALUES
('John Doe', NULL, 1.75, 70.5, 'm', '1990-01-15', 'A short biography of John Doe.'),
('Jane Smith', NULL, 1.62, 55.2, 'f', '1985-07-25', 'A short biography of Jane Smith.'),
('Bob Johnson', NULL, 1.80, 85.0, 'm', '1982-03-10', 'A short biography of Bob Johnson.'),
('Alice Brown', NULL, 1.68, 60.8, 'f', '1995-11-03', 'A short biography of Alice Brown.'),
('Charlie Wilson', NULL, 1.88, 78.3, 'm', '1988-09-18', 'A short biography of Charlie Wilson.');

-- create table users
CREATE TABLE users (
id INT NOT NULL AUTO_INCREMENT,
username VARCHAR(30) unique,
password VARCHAR(26),
profile_picture BLOB,
last_login_time TIME,
is_deleted BOOLEAN,
PRIMARY KEY (id)
);

INSERT INTO users (username, password, profile_picture, last_login_time, is_deleted) VALUES
('Margo', 'password1', NULL, NULL, true),
('Anna', 'password2', NULL, NULL, true),
('Dorothea', 'password3', NULL, NULL, false),
('Augustine', 'password4', NULL, NULL, true),
('Betty', 'password5', NULL, NULL, false);

-- change primary key
ALTER TABLE users
MODIFY id BIGINT NOT NULL,
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users PRIMARY KEY (id, username);

