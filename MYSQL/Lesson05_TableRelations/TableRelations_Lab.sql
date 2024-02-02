-- MOUNTAINS AND PEAKS
CREATE TABLE mountains (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
CREATE TABLE peaks(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    mountain_id INT,
    CONSTRAINT fk_peaks_mountain_id_mountains_id
    FOREIGN KEY (mountain_id)
    REFERENCES mountains(id)
);
-- TRIP ORGANIZATION


-- SOFTUNI HIKING


-- DELETE MOUNTAINS

