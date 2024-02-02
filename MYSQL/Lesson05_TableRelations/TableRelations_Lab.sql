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

