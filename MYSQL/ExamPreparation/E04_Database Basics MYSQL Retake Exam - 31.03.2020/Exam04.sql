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

-- USERS
SELECT username, gender, age
FROM users
ORDER BY age DESC, username ASC;

-- EXTRACT 5 MOST COMMENTED PHOTOS
SELECT p.id, p.date AS date_and_time, p.description, COUNT(c.id) AS commentsCount
FROM photos p
LEFT JOIN comments c ON p.id = c.photo_id
GROUP BY p.id, p.date, p.description
ORDER BY commentsCount DESC, p.id ASC
LIMIT 5;

-- LUCKY USERS
SELECT CONCAT(u.id, ' ', u.username) AS id_username, u.email
FROM users u
JOIN users_photos up ON u.id = up.user_id
JOIN photos p ON up.photo_id = p.id
WHERE u.id = p.id
ORDER BY u.id ASC;

-- COUNT LIKES AND COMMENTS
SELECT 
    p.id AS photo_id, 
    COUNT(DISTINCT l.id) AS likes_count, 
    COUNT(DISTINCT c.id) AS comments_count
FROM 
    photos p
LEFT JOIN 
    likes l ON p.id = l.photo_id
LEFT JOIN 
    comments c ON p.id = c.photo_id
GROUP BY 
    p.id
ORDER BY 
    likes_count DESC, 
    comments_count DESC, 
    photo_id ASC;
    
-- THE PHOTO ON THE TENTH DAY OF THE MONTH
SELECT 
    CONCAT(SUBSTRING(description, 1, 30), '...') AS summary, 
    date
FROM 
    photos
WHERE 
    DAY(date) = 10
ORDER BY 
    date DESC;
    
-- GET USER'S PHOTOS COUNT
DELIMITER $
CREATE FUNCTION udf_users_photos_count(username VARCHAR(30))
RETURNS INT
BEGIN
    DECLARE photos_count INT;
    SELECT COUNT(*) INTO photos_count
    FROM users u
    JOIN users_photos up ON u.id = up.user_id
    WHERE u.username = username;
    RETURN photos_count;
END $

DELIMITER ;

-- INCREASE USER AGE
DELIMITER $

CREATE PROCEDURE udp_modify_user (IN address VARCHAR(30), IN town VARCHAR(30))
BEGIN
    -- Update the user's age
    UPDATE users u
    JOIN addresses a ON u.id = a.user_id
    SET u.age = u.age + 10
    WHERE a.address = address AND a.town = town;
END $

DELIMITER ;