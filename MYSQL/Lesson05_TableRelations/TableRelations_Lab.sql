-- MOUNTAINS AND PEAKS
CREATE TABLE mountains (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
CREATE TABLE peaks(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    mountain_id INT,
    CONSTRAINT fk_peaks_mountains
    FOREIGN KEY (mountain_id)
    REFERENCES mountains(id)
);

-- TRIP ORGANIZATION
SELECT 
	vehicles.driver_id, 
    vehicle_type ,
    CONCAT(campers.first_name, ' ', campers.last_name) AS 'driver_name'
FROM vehicles
	JOIN campers ON vehicles.driver_id = campers.id;

-- SOFTUNI HIKING
SELECT
	starting_point AS 'route_starting_point',
    end_point AS 'route_end_point',
    leader_id,
	CONCAT(first_name, ' ', last_name) AS 'leader_name'
FROM routes
	JOIN campers ON routes.leader_id = campers.id;

-- DELETE MOUNTAINS
CREATE TABLE mountains (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
CREATE TABLE peaks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    mountain_id INT,
    CONSTRAINT fk_peaks_mountains FOREIGN KEY (mountain_id)
        REFERENCES mountains (id)
        ON DELETE CASCADE
);

-- PROJECT MANAGEMENT DB
CREATE DATABASE project_management_db;

CREATE TABLE clients
(
    id          INT(11) PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(100)
);
CREATE TABLE projects
(
    id              INT(11) PRIMARY KEY AUTO_INCREMENT,
    client_id       INT(11),
    project_lead_id INT(11)
);
CREATE TABLE employees
(
    id         INT(11) PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30),
    last_name  VARCHAR(30),
    project_id INT(11)
);
ALTER TABLE projects
    ADD CONSTRAINT fk_projects_clients
        FOREIGN KEY (client_id)
            REFERENCES clients (id),
    ADD CONSTRAINT fk_projects_employees
        FOREIGN KEY (project_lead_id)
            REFERENCES employees (id);
ALTER TABLE employees
    ADD CONSTRAINT fk_employees_projects
        FOREIGN KEY (project_id)
            REFERENCES projects (id);