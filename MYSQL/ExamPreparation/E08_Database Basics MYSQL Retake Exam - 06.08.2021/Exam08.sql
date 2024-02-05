CREATE DATABASE exam_08;
USE exam_08;

-- TABLE DESIGN
CREATE TABLE addresses(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE categories(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(10) NOT NULL
);

CREATE TABLE offices(
	id INT PRIMARY KEY AUTO_INCREMENT,
    workspace_capacity INT NOT NULL, 
    website VARCHAR(50),
    address_id INT NOT NULL, 
    FOREIGN KEY (address_id) REFERENCES addresses(id)
);

CREATE TABLE employees(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age INT NOT NULL, 
    salary DECIMAL(10,2) NOT NULL, 
    job_title VARCHAR(20) NOT NULL, 
    happiness_level CHAR(1) NOT NULL
);

CREATE TABLE teams(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    office_id INT NOT NULL, 
    leader_id INT NOT NULL UNIQUE, 
    FOREIGN KEY (office_id) REFERENCES offices(id),
    FOREIGN KEY (leader_id) REFERENCES employees(id)
);

CREATE TABLE games(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    rating FLOAT NOT NULL DEFAULT 5.5,
    budget DECIMAL(10,2) NOT NULL,
    release_date DATE,
	team_id INT NOT NULL, 
    FOREIGN KEY (team_id) REFERENCES teams(id)
);

CREATE TABLE games_categories(
	game_id INT NOT NULL, 
    category_id INT NOT NULL, 
    FOREIGN KEY (game_id) REFERENCES games(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- INSERT 
INSERT INTO games (name, rating, budget, team_id)
SELECT LOWER(REVERSE(SUBSTRING(name, 2))),
	t.id,
    t.leader_id * 1000,
    t.id
FROM teams as t
WHERE t.id BETWEEN 1 AND 9;

-- UPDATE 
UPDATE employees AS e
JOIN teams AS t ON e.id = t.leader_id
SET e.salary = e.salary + 1000
WHERE e.age < 40 AND e.salary < 5000;

-- DELETE
DELETE FROM games
WHERE NOT EXISTS (
    SELECT 1
    FROM games_categories gc
    WHERE gc.game_id = games.id
) AND release_date IS NULL;

-- EMPLOYEES
SELECT
    first_name,
    last_name,
    age,
    salary,
    happiness_level
FROM employees
ORDER BY salary, id;

-- ADDRESSES OF THE TEAMS 
SELECT
    teams.name AS team_name,
    addresses.name AS address_name,
    LENGTH(addresses.name) AS count_of_characters
FROM teams
JOIN offices ON teams.office_id = offices.id
JOIN addresses ON offices.address_id = addresses.id
WHERE offices.website IS NOT NULL
ORDER BY team_name, address_name;

-- CATEGORIES INFO
SELECT
    categories.name AS name,
    COUNT(games.id) AS games_count,
    ROUND(AVG(games.budget), 2) AS avg_budget,
    MAX(games.rating) AS max_rating
FROM categories
JOIN games_categories ON categories.id = games_categories.category_id
JOIN games ON games_categories.game_id = games.id
GROUP BY categories.name
HAVING max_rating >= 9.5
ORDER BY games_count DESC, name;

-- GAMES OF 2022
SELECT 
    g.name,
    g.release_date,
    CONCAT(SUBSTRING(g.description, 1, 10), '...') AS summary,
    (CASE
        WHEN MONTH(g.release_date) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(g.release_date) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(g.release_date) BETWEEN 7 AND 9 THEN 'Q3'
        WHEN MONTH(g.release_date) BETWEEN 10 AND 12 THEN 'Q4'
    END) AS querter,
    t.name AS team_name
FROM
    games AS g
        JOIN
    teams AS t ON t.id = g.team_id
WHERE
    YEAR(g.release_date) = 2022
        AND MONTH(g.release_date) IS NOT NULL
        AND MONTH(g.release_date) % 2 = 0
        AND g.name LIKE '%2'
ORDER BY querter;

-- FULL INFO FOR GAMES
SELECT
    games.name AS name,
    CASE
        WHEN games.budget < 50000 THEN 'Normal budget'
        ELSE 'Insufficient budget'
    END AS budget_level,
    teams.name AS team_name,
    addresses.name AS address_name
FROM games
LEFT JOIN games_categories ON games.id = games_categories.game_id
LEFT JOIN teams ON games.team_id = teams.id
LEFT JOIN offices ON teams.office_id = offices.id
LEFT JOIN addresses ON offices.address_id = addresses.id
WHERE games.release_date IS NULL AND games_categories.category_id IS NULL
ORDER BY games.name;

-- FIND ALL BASIC INFORMATION FOR A GAME
DELIMITER //

CREATE FUNCTION udf_game_info_by_name(game_name VARCHAR(20))
RETURNS VARCHAR(255)
BEGIN
    DECLARE game_info VARCHAR(255);
    
    SELECT CONCAT('The ', game_name, ' is developed by a ', t.name,
                  ' in an office with an address ', a.name)
    INTO game_info
    FROM games g
    JOIN teams t ON g.team_id = t.id
    JOIN offices o ON t.office_id = o.id
    JOIN addresses a ON o.address_id = a.id
    WHERE g.name = game_name;
    
    RETURN game_info;
END //

DELIMITER ;

-- UPDATE THE BUDGET OF THE GAMES
DELIMITER //

CREATE PROCEDURE udp_update_budget(min_game_rating FLOAT)
BEGIN
    UPDATE games
    SET
        budget = budget + 100000,
        release_date = DATE_ADD(release_date, INTERVAL 1 YEAR)
    WHERE
        rating > min_game_rating
        AND release_date IS NOT NULL
        AND id NOT IN (
            SELECT DISTINCT game_id
            FROM games_categories
        );
END //

DELIMITER ;