CREATE DATABASE exam_04;
USE exam_04;

-- TABLE DESIGN
CREATE TABLE users(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    username VARCHAR(30) NOT NULL UNIQUE, 
    password VARCHAR(30) NOT NULL, 
    email VARCHAR(50) NOT NULL, 
    gender CHAR(1) NOT NULL, 
    age INT NOT NULL, 
    job_title VARCHAR(40) NOT NULL, 
    ip VARCHAR(30) NOT NULL
);

CREATE TABLE addresses(
	id INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(30) NOT NULL, 
    town VARCHAR(30) NOT NULL, 
    country VARCHAR(30) NOT NULL,
    user_id INT NOT NULL, 
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE photos(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    description TEXT NOT NULL, 
    date DATETIME NOT NULL, 
    views INT NOT NULL DEFAULT 0
);

CREATE TABLE comments(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    comment VARCHAR(255) NOT NULL, 
    date DATETIME NOT NULL, 
    photo_id INT NOT NULL, 
    FOREIGN KEY (photo_id) REFERENCES photos(id)
);

CREATE TABLE users_photos(
	user_id INT NOT NULL, 
    photo_id INT NOT NULL, 
	FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (photo_id) REFERENCES photos(id)
);

CREATE TABLE likes(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    photo_id INT,
	user_id INT, 
    FOREIGN KEY (photo_id) REFERENCES photos(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- INSERT
INSERT INTO addresses (address, town, country, user_id)
SELECT username, password, ip, age
FROM users
WHERE gender = 'M';

-- UPDATE
UPDATE addresses
SET country = CASE 
                WHEN country LIKE 'B%' THEN 'Blocked'
                WHEN country LIKE 'T%' THEN 'Test'
                WHEN country LIKE 'P%' THEN 'In Progress'
                ELSE country
             END;

-- DELETE
DELETE FROM addresses
WHERE id % 3 = 0;
