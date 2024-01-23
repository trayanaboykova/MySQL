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
MODIFY id INT NOT NULL,
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users PRIMARY KEY (id, username);

-- set default value of a field
ALTER TABLE users
MODIFY COLUMN last_login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- set unique field
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users PRIMARY KEY users (id),
MODIFY COLUMN username Varchar(30) unique;

-- movie database
CREATE DATABASE movies;

CREATE TABLE directors (
id INT NOT NULL AUTO_INCREMENT,
director_name VARCHAR(50) NOT NULL,
notes TEXT,
PRIMARY KEY (id)
);

INSERT INTO directors (director_name, notes) VALUES
('Director1', 'Note 1'),
('Director2', 'Note 2'),
('Director3', 'Note 3'),
('Director4', 'Note 4'),
('Director5', 'Note 5');

CREATE TABLE genres (
id INT NOT NULL AUTO_INCREMENT,
genre_name VARCHAR(50) NOT NULL,
notes TEXT,
PRIMARY KEY (id)
);

INSERT INTO genres (genre_name, notes) VALUES
('Genre1', 'Note 1'),
('Genre2', 'Note 2'),
('Genre3', 'Note 3'),
('Genre4', 'Note 4'),
('Genre5', 'Note 5');

CREATE TABLE categories (
id INT NOT NULL AUTO_INCREMENT,
category_name VARCHAR(50) NOT NULL,
notes TEXT,
PRIMARY KEY (id)
);

INSERT INTO categories (category_name, notes) VALUES
('Category1', 'Note 1'),
('Category2', 'Note 2'),
('Category3', 'Note 3'),
('Category4', 'Note 4'),
('Category5', 'Note 5');

CREATE TABLE movies (
id INT NOT NULL AUTO_INCREMENT,
title VARCHAR(50) NOT NULL,
director_ID INT,
copyright_year YEAR,
length TIME,
genre_id INT,
category_id INT,
rating DOUBLE,
notes TEXT,
PRIMARY KEY (id)
);

INSERT INTO movies (title, director_id, copyright_year, length, genre_id, category_id, rating, notes) VALUES
('Movie1', 1, 2000, 120, 1, 1, 7.5, 'Note 1'),
('Movie2', 2, 2005, 140, 2, 2, 8.0, 'Note 2'),
('Movie3', 3, 2010, 110, 3, 3, 6.5, 'Note 3'),
('Movie4', 4, 2015, 140, 4, 4, 9.0, 'Note 4'),
('Movie5', 5, 2020, 130, 5, 5, 7.8, 'Note 5');

-- car rental database
CREATE DATABASE car_rental;

CREATE TABLE categories (
id INT NOT NULL AUTO_INCREMENT,
category VARCHAR(50) NOT NULL,
daily_rate DOUBLE 	NOT NULL,
weekly_rate DOUBLE,
monthly_rate DOUBLE,
weekend_rate DOUBLE,
PRIMARY KEY (id)
);

INSERT INTO categories (category, daily_rate, weekly_rate, monthly_rate, weekend_rate) VALUES
('Compact', 25.99, 149.99, 499.99, 39.99),
('SUV', 34.99, 199.99, 649.99, 49.99),
('Luxury', 49.99, 299.99, 999.99, 69.99);

CREATE TABLE cars (
id INT NOT NULL AUTO_INCREMENT,
plate_number VARCHAR(10) NOT NULL,
make VARCHAR(20) NOT NULL,
model VARCHAR(20) NOT NULL,
car_year YEAR,
category_id INT,
doors INT,
picture	 BLOB, 
car_condition VARCHAR(20),
available BOOLEAN, 
PRIMARY KEY (id)
);

INSERT INTO cars (plate_number, make, model, car_year, category_id, doors, picture, car_condition, available)
VALUES
('ABC123', 'Toyota', 'Corolla', 2020, 1, 4, NULL, 'Excellent', TRUE),
('XYZ456', 'Honda', 'Civic', 2018, 2, 4, NULL, 'Good', TRUE),
('DEF789', 'Ford', 'Escape', 2019, 3, 4, NULL, 'Very Good', FALSE);

CREATE TABLE employees (
id INT NOT NULL AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50),
title VARCHAR(30) NOT NULL,
notes TEXT,
PRIMARY KEY (id)
);

INSERT INTO employees (first_name, last_name, title, notes)
VALUES
('John', 'Doe', 'Manager', 'Excellent employee with strong leadership skills.'),
('Jane', 'Smith', 'Developer', 'Experienced software developer with expertise in Java.'),
('Bob', 'Johnson', 'Analyst', 'Detail-oriented data analyst with strong analytical skills.');

CREATE TABLE customers (
id INT NOT NULL AUTO_INCREMENT,
driver_licence_number INT NOT NULL,
full_name VARCHAR(50) NOT NULL,
address VARCHAR(100) NOT NULL,
city VARCHAR(50) NOT NULL,
zip_code VARCHAR(20) NOT NULL,
notes TEXT,
PRIMARY KEY (id)
);

INSERT INTO customers (driver_licence_number, full_name, address, city, zip_code, notes)
VALUES
('12345', 'Alice Johnson', '123 Main St', 'Cityville', '12345', 'Regular customer, preferred contact via email.'),
('67890', 'Bob Smith', '456 Oak Ave', 'Townsville', '56789', 'Frequent renter, prefers phone contact.'),
('13579', 'Charlie Brown', '789 Pine Ln', 'Villagetown', '98765', 'New customer, special request for a specific car model.');
 
 CREATE TABLE rental_orders (
id INT NOT NULL AUTO_INCREMENT,
employee_id INT NOT NULL,
customer_id INT NOT NULL,
car_id INT NOT NULL,
car_condition VARCHAR(20),
tank_level DOUBLE,
kilometrage_start DOUBLE,
kilometrage_end DOUBLE,
total_kilometrage DOUBLE,
start_date DATE,
end_date DATE,
total_days INT,
rate_applied DOUBLE,
tax_rate DOUBLE,
order_status VARCHAR(20),
notes TEXT,
PRIMARY KEY (id)
);

INSERT INTO rental_orders (employee_id, customer_id, car_id, car_condition, tank_level, kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date, total_days, rate_applied, tax_rate, order_status, notes)
VALUES
(1, 1, 1, 'Good', 0.75, 10000, 10500, 500, '2022-01-01', '2022-01-05', 5, 35.99, 0.1, 'Completed', 'Customer was satisfied with the service.'),
(2, 2, 2, 'Excellent', 0.90, 8000, 8100, 100, '2022-02-10', '2022-02-15', 5, 42.99, 0.12, 'Completed', 'Regular customer with a discount applied.'),
(3, 3, 3, 'Very Good', 0.80, 12000, 12500, 500, '2022-03-20', '2022-03-25', 5, 38.99, 0.15, 'Completed', 'Special request for a specific car model.');

-- basic insert
CREATE DATABASE soft_uni;
 
CREATE TABLE towns (
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
PRIMARY KEY (id)
);

INSERT INTO towns (name)
VALUES ('Sofia'),
       ('Plovdiv'),
       ('Varna'),
       ('Burgas');
 
 CREATE TABLE addresses (
id INT NOT NULL AUTO_INCREMENT,
address_text VARCHAR(100),
town_id INT,
PRIMARY KEY (id)
);

CREATE TABLE departments (
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(100),
PRIMARY KEY (id)
);

INSERT INTO departments (name)
VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

CREATE TABLE employees (
id INT NOT NULL AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL,
middle_name VARCHAR(50),
last_name VARCHAR(50) NOT NULL,
job_title VARCHAR(50), 
department_id INT,
hire_date DATE,
salary DOUBLE,
address_id INT,
PRIMARY KEY (id)
);

ALTER TABLE addresses
ADD CONSTRAINT fk_AddressesTowns
FOREIGN KEY(town_id) REFERENCES addresses (id);

ALTER TABLE employees
ADD CONSTRAINT fk_EmployeesTowns
FOREIGN KEY(department_id) REFERENCES departments (id);

ALTER TABLE employees
ADD CONSTRAINT fk_Employees
FOREIGN KEY(address_id) REFERENCES addresses (id);

INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
VALUES ('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
       ('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
       ('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
       ('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
       ('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);

-- basic select all fields
SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

