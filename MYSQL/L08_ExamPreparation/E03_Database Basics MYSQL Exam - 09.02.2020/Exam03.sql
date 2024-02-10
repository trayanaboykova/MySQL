CREATE DATABASE exam_03;
USE exam_03;

-- TABLE DESIGN 
CREATE TABLE coaches(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(10,2) NOT NULL DEFAULT 0,
    coach_level INT NOT NULL DEFAULT 0
);

CREATE TABLE skills_data(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    dribbling INT DEFAULT 0,
    pace INT DEFAULT 0,
    passing INT DEFAULT 0,
    shooting INT DEFAULT 0,
    speed INT DEFAULT 0,
    strength INT DEFAULT 0
);

CREATE TABLE countries(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL
);

CREATE TABLE towns(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE TABLE stadiums(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    capacity INT NOT NULL,
    town_id INT NOT NULL,
    FOREIGN KEY (town_id) REFERENCES towns(id)
);

CREATE TABLE teams(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    established DATE NOT NULL, 
    fan_base BIGINT(20) NOT NULL DEFAULT 0,
    stadium_id INT NOT NULL,
    FOREIGN KEY (stadium_id) REFERENCES stadiums(id)
);

CREATE TABLE players(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    age INT NOT NULL DEFAULT 0,
    position CHAR(1) NOT NULL, 
    salary DECIMAL(10,2) NOT NULL DEFAULT 0,
    hire_date DATETIME,
    skills_data_id INT NOT NULL, 
    team_id INT,
    FOREIGN KEY (skills_data_id) REFERENCES skills_data(id),
    FOREIGN KEY (team_id) REFERENCES teams(id)
);

CREATE TABLE players_coaches(
	player_id INT,
    coach_id INT, 
	FOREIGN KEY (player_id) REFERENCES players(id),
    FOREIGN KEY (coach_id) REFERENCES coaches(id)
);

-- INSERT
INSERT INTO coaches (first_name, last_name, salary, coach_level)
SELECT 
    first_name,
    last_name,
    salary * 2,
    LENGTH(first_name) AS coach_level
FROM players
WHERE age >= 45;

-- UPDATE
UPDATE coaches 
SET coach_level = coach_level + 1
WHERE id IN (
    SELECT coach_id
    FROM (
        SELECT DISTINCT pc.coach_id
        FROM players_coaches pc
        INNER JOIN coaches c ON pc.coach_id = c.id
        INNER JOIN players p ON pc.player_id = p.id
        WHERE c.first_name LIKE 'A%'
    ) AS temp
);

-- DELETE
DELETE FROM players
WHERE id IN (
    SELECT id
    FROM (
        SELECT p.id
        FROM players p
        LEFT JOIN players_coaches pc ON p.id = pc.player_id
        WHERE pc.player_id IS NULL
    ) AS temp
);

-- PLAYERS
SELECT first_name, age, salary
FROM players
ORDER BY salary DESC;

-- YOUNG OFFENSE PLAYERS WITHOUT CONTRACT
SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS full_name, p.age, p.position, p.hire_date
FROM players p
JOIN skills_data s ON p.skills_data_id = s.id
WHERE p.age < 23
AND p.position = 'A'
AND p.hire_date IS NULL
AND s.strength > 50
ORDER BY p.salary ASC, p.age ASC;

-- DETAIL INFO FOR ALL TEAMS
SELECT 
    t.name AS team_name, 
    t.established, 
    t.fan_base, 
    COUNT(p.id) AS count_of_players
FROM 
    teams t
LEFT JOIN 
    players p ON t.id = p.team_id
GROUP BY 
    t.id
ORDER BY 
    count_of_players DESC, 
    t.fan_base DESC;

-- THE FASTEST PLAYER BY TOWNS
SELECT 
    MAX(s.speed) AS max_speed,
    t.name AS town_name
FROM 
    players p
JOIN 
    teams tm ON p.team_id = tm.id
JOIN 
    stadiums std ON tm.stadium_id = std.id
JOIN 
    towns t ON std.town_id = t.id
JOIN 
    skills_data s ON p.skills_data_id = s.id
WHERE 
    tm.name != 'Devify'
GROUP BY 
    t.id
ORDER BY 
    max_speed DESC, 
    t.name;

-- TOTAL SALARIES AND PLAYERS BY COUNTRY
SELECT 
    c.name AS name,
    COUNT(p.id) AS total_count_of_players,
    IFNULL(SUM(p.salary), NULL) AS total_sum_of_salaries
FROM 
    countries c
LEFT JOIN 
    towns t ON c.id = t.country_id
LEFT JOIN 
    stadiums s ON t.id = s.town_id
LEFT JOIN 
    teams tm ON s.id = tm.stadium_id
LEFT JOIN 
    players p ON tm.id = p.team_id
GROUP BY 
    c.id
ORDER BY 
    total_count_of_players DESC,
    c.name;

-- FIND ALL PLAYERS THAT PLAY ON STADIUM
DELIMITER $

CREATE FUNCTION udf_stadium_players_count (stadium_name VARCHAR(30))
RETURNS INT
BEGIN
    DECLARE player_count INT;
    SELECT COUNT(p.id) INTO player_count
    FROM players p
    JOIN teams t ON p.team_id = t.id
    JOIN stadiums s ON t.stadium_id = s.id
    WHERE s.name = stadium_name;
    RETURN player_count;
END $

DELIMITER ;

-- FIND GOOD PLAYMAKER BY TEAMS
DELIMITER //
CREATE PROCEDURE udp_find_playmaker (
    IN min_dribble_points INT,
    IN team_name VARCHAR(45)
)
BEGIN
    SELECT 
        CONCAT(p.first_name, ' ', p.last_name) AS full_name,
        p.age,
        p.salary,
        s.dribbling,
        s.speed,
        t.name AS team_name
    FROM 
        players p
    JOIN 
        teams t ON p.team_id = t.id
    JOIN 
        skills_data s ON p.skills_data_id = s.id
    WHERE 
        s.dribbling > min_dribble_points
        AND t.name = team_name
        AND s.speed > (SELECT AVG(s2.speed) FROM skills_data s2)
    ORDER BY 
        s.speed DESC
    LIMIT 1;
END //
DELIMITER ;