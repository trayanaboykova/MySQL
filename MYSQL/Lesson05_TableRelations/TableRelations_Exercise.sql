-- ONE-TO-ONE RELATIONSHIP
CREATE DATABASE relations;

USE relations;

CREATE TABLE passports(
passport_id INT PRIMARY KEY AUTO_INCREMENT,
passport_number VARCHAR(10) UNIQUE
);

INSERT INTO passports(passport_id, passport_number) VALUES 
(101, 'N34FG21B'), 
(102, 'K65LO4R7'), 
(103, 'ZE657QP2');

CREATE TABLE people(
person_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50),
salary DECIMAL(10,2),
passport_id INT UNIQUE,
FOREIGN KEY (passport_id)
REFERENCES passports(passport_id)
);

INSERT INTO people (first_name, salary, passport_id) VALUES
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101);

-- ONE-TO-MANY RELATIONSHIPS
CREATE TABLE manufacturers(
manufacturer_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) UNIQUE,
established_on DATE
);

INSERT INTO manufacturers(name, established_on) VALUES 
('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01');

CREATE TABLE models(
model_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50),
manufacturer_id INT,
FOREIGN KEY (manufacturer_id)
REFERENCES manufacturers(manufacturer_id)
);

INSERT INTO models VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3);

-- MANY-TO-MANY RELATIONSHIPS
CREATE TABLE students(
student_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50)
);

INSERT INTO students(student_id, name) VALUES
(1, 'Mila'), 
(2, 'Toni'), 
(3, 'Ron');

CREATE TABLE exams(
exam_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) 
);

INSERT INTO exams(exam_id, name) VALUES
(101, 'Spring MVC'), 
(102, 'Neo4j'), 
(103, 'Oracle 11g');

CREATE TABLE students_exams(
student_id INT,
exam_id INT,
PRIMARY KEY(student_id, exam_id),
FOREIGN KEY (student_id) REFERENCES students(student_id),
FOREIGN KEY (exam_id) REFERENCES exams(exam_id)
);

INSERT INTO students_exams(student_id, exam_id) VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);

-- SELF-REFERENCING


-- ONLINE STORE DATABASE


-- UNIVERSITY DATABASE


-- PEAKS IN RILLA
