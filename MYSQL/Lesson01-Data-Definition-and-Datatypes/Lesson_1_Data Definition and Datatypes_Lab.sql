-- create new database
CREATE DATABASE gamebar;

-- create table employees
CREATE TABLE employees (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

-- create table categories
CREATE TABLE categories (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- create table products
CREATE TABLE products (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    category_id INT NOT NULL
);

-- insert data in tables
INSERT INTO employees (first_name, last_name)
VALUES 
("Field", "List"),
("Second", "Entry"),
("Third", "Employee");

-- alter tables
ALTER TABLE employees
ADD COLUMN middle_name VARCHAR(50) NOT NULL;

-- adding constraints
ALTER TABLE products
ADD CONSTRAINT fk_category
FOREIGN KEY (category_id)
REFERENCES categories(id);

-- modifying columns
ALTER TABLE employees
MODIFY COLUMN middle_name VARCHAR(100);