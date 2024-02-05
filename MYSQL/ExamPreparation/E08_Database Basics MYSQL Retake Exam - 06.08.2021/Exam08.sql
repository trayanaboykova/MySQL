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
LEFT JOIN games_categories ON categories.id = games_categories.category_id
LEFT JOIN games ON games_categories.game_id = games.id
GROUP BY categories.name
HAVING max_rating > 9.5
ORDER BY games_count DESC, name;

-- GAMES OF 2022