CREATE DATABASE exam_10;
USE exam_10;

-- TABLE DESIGN
CREATE TABLE countries(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    continent VARCHAR(30) NOT NULL,
    currency VARCHAR(5) NOT NULL
);

CREATE TABLE genres(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE actors(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthdate DATE NOT NULL, 
    height INT,
    awards INT,
    country_id INT NOT NULL,
	CONSTRAINT fk_actors_countries
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE TABLE movies_additional_info(
	id INT PRIMARY KEY AUTO_INCREMENT,
    rating DECIMAL(10,2) NOT NULL,
    runtime INT NOT NULL,
    picture_url VARCHAR(80) NOT NULL,
    budget DECIMAL(10,2),
    release_date DATE NOT NULL,
    has_subtitles BOOLEAN,
    description TEXT
);

CREATE TABLE movies(
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(70) NOT NULL UNIQUE,
    country_id INT NOT NULL, 
    movie_info_id INT NOT NULL UNIQUE,
	CONSTRAINT fk_movies_countries
	FOREIGN KEY (country_id) REFERENCES countries(id),
    CONSTRAINT fk_movies_movies_additional_info
	FOREIGN KEY (movie_info_id) REFERENCES movies_additional_info(id)
);

CREATE TABLE movies_actors(
	movie_id INT,
    actor_id INT, 
    CONSTRAINT fk_movies_actors_movies
	FOREIGN KEY (movie_id) REFERENCES movies(id),
    CONSTRAINT fk_movies_actors_actors
	FOREIGN KEY (actor_id) REFERENCES actors(id)
);

CREATE TABLE genres_movies(
	genre_id INT,
    movie_id INT, 
	CONSTRAINT fk_genres_movies_genres 
	FOREIGN KEY (genre_id) REFERENCES genres(id),
    CONSTRAINT fk_genres_movies_movies
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- INSERT
INSERT INTO actors (first_name, last_name, birthdate, height, awards, country_id)
SELECT
    REVERSE(first_name),
    REVERSE(last_name),
    DATE_SUB(birthdate, INTERVAL 2 DAY),
    height + 10,
    country_id,
    (SELECT id FROM countries WHERE name = 'Armenia')
FROM actors
WHERE id <= 10;

-- UPDATE
UPDATE movies_additional_info
SET runtime = runtime - 10
WHERE id >= 15 AND id <= 25;

-- DELETE
DELETE FROM countries
WHERE id NOT IN (SELECT DISTINCT country_id FROM movies);

-- COUNTRIES
SELECT id, name, continent, currency
FROM countries
ORDER BY currency DESC, id;

-- OLD MOVIES
SELECT m.id, m.title, mai.runtime, mai.budget, mai.release_date
FROM movies_additional_info mai
JOIN movies m ON mai.id = m.movie_info_id
WHERE YEAR(mai.release_date) BETWEEN 1996 AND 1999
ORDER BY mai.runtime ASC, m.id ASC
LIMIT 20;

-- MOVIE CASTING
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    CONCAT(
        REVERSE(last_name),
        LENGTH(last_name),
        '@cast.com'
    ) AS email,
    2022 - YEAR(birthdate) AS age,
    height
FROM actors
WHERE id NOT IN (
    SELECT DISTINCT actor_id
    FROM movies_actors
)
ORDER BY height ASC;

-- INTERNATIONAL FESTIVAL
SELECT 
    c.name AS name,
    COUNT(m.id) AS movies_count
FROM countries c
LEFT JOIN movies m ON c.id = m.country_id
GROUP BY c.name
HAVING movies_count >= 7
ORDER BY name DESC;

-- RATING SYSTEM
SELECT 
    m.title,
    CASE 
        WHEN mai.rating <= 4 THEN 'poor'
        WHEN mai.rating <= 7 THEN 'good'
        ELSE 'excellent'
    END AS rating,
    CASE 
        WHEN mai.has_subtitles = 1 THEN 'english'
        ELSE '-'
    END AS subtitles,
    mai.budget
FROM movies_additional_info mai
JOIN movies m ON mai.id = m.movie_info_id
ORDER BY mai.budget DESC;

-- HISTORY MOVIES
DELIMITER $

CREATE FUNCTION udf_actor_history_movies_count(actor_name VARCHAR(50))
RETURNS INT
BEGIN
    DECLARE history_count INT;
    
    SELECT COUNT(DISTINCT m.id) INTO history_count
    FROM movies m
    JOIN movies_actors ma ON m.id = ma.movie_id
    JOIN actors a ON ma.actor_id = a.id
    JOIN genres_movies gm ON m.id = gm.movie_id
    JOIN genres g ON gm.genre_id = g.id
    WHERE CONCAT(a.first_name, ' ', a.last_name) = actor_name
    AND g.name = 'History';
    
    RETURN history_count;
END $

DELIMITER ;

-- MOVIE AWARDS
DELIMITER $

CREATE PROCEDURE udp_award_movie(IN movie_title VARCHAR(50))
BEGIN
    DECLARE movie_id INT;
    SELECT id INTO movie_id
    FROM movies
    WHERE title = movie_title;
	UPDATE actors a
    SET a.awards = a.awards + 1
    WHERE EXISTS (
        SELECT 1
        FROM movies_actors ma
        WHERE ma.movie_id = movie_id AND ma.actor_id = a.id
    );
END $

DELIMITER ;