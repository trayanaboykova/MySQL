CREATE DATABASE exam_14;
USE exam_14;

-- TABLE DESIGN
CREATE TABLE cities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE property_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(40) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE properties (
    id INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(80) NOT NULL UNIQUE,
    price DECIMAL(19 , 2 ) NOT NULL,
    area DECIMAL(19 , 2 ),
    property_type_id INT,
    city_id INT,
    FOREIGN KEY (property_type_id)
        REFERENCES property_types (id),
    FOREIGN KEY (city_id)
        REFERENCES cities (id)
);

CREATE TABLE agents (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    city_id INT,
    FOREIGN KEY (city_id)
        REFERENCES cities (id)
);

CREATE TABLE buyers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    city_id INT,
    FOREIGN KEY (city_id)
        REFERENCES cities (id)
);

CREATE TABLE property_offers (
    property_id INT NOT NULL,
    agent_id INT NOT NULL,
    price DECIMAL(19,2) NOT NULL,
    offer_datetime DATETIME,
    FOREIGN KEY (property_id)
        REFERENCES properties (id),
    FOREIGN KEY (agent_id)
        REFERENCES agents (id)
);

CREATE TABLE property_transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    buyer_id INT NOT NULL,
    transaction_date DATE,
    bank_name VARCHAR(30),
    iban VARCHAR(40) UNIQUE,
    is_successful BOOLEAN,
    FOREIGN KEY (property_id)
        REFERENCES properties (id),
    FOREIGN KEY (buyer_id)
        REFERENCES buyers (id)
);

-- INSERT
INSERT INTO property_transactions(property_id, 
								  buyer_id, 
                                  transaction_date, 
                                  bank_name, 
                                  iban, 
                                  is_successful)
SELECT
    po.agent_id + DAY(po.offer_datetime) AS property_id,
    po.agent_id + MONTH(po.offer_datetime) AS buyer_id,
    DATE(po.offer_datetime) AS transaction_date,
    CONCAT('Bank ', po.agent_id) AS bank_name,
    CONCAT('BG', po.price, po.agent_id) AS iban,
    true AS is_successful
FROM property_offers po
WHERE po.agent_id <= 2;

-- UPDATE
UPDATE properties 
SET 
    price = price - 50000
WHERE
    price >= 800000;

-- DELETE
DELETE FROM property_transactions 
WHERE
    is_successful != TRUE;
    
-- AGENTS
SELECT 
    id, first_name, last_name, phone, email, city_id
FROM
    agents
ORDER BY city_id DESC , phone DESC;

-- OFFERS FROM 2021
SELECT property_id, agent_id, price, offer_datetime
FROM property_offers
WHERE YEAR(offer_datetime) = 2021
ORDER BY price ASC
LIMIT 10;

-- PROPERTIES WITHOUT OFFERS
SELECT 
    LEFT(properties.address, 6) AS agent_name,
    LENGTH(properties.address) * 5430 AS price
FROM
    properties
        LEFT JOIN
    property_offers ON properties.id = property_offers.property_id
WHERE
    property_offers.property_id IS NULL
        AND property_offers.agent_id IS NULL
ORDER BY agent_name DESC , price DESC;

-- BEST BANKS
SELECT 
    bank_name, COUNT(DISTINCT iban) AS count
FROM
    property_transactions
GROUP BY bank_name
HAVING count >= 9
ORDER BY count DESC , bank_name ASC;

-- SIZE OF THE AREA
SELECT
    address,
    area,
    CASE
        WHEN area <= 100 THEN 'small'
        WHEN area <= 200 THEN 'medium'
        WHEN area <= 500 THEN 'large'
        ELSE 'extra large'
    END AS size
FROM
    properties
ORDER BY
    area ASC,
    address DESC;

-- OFFERS COUNT IN A CITY
DELIMITER $

CREATE FUNCTION udf_offers_from_city_name(cityName VARCHAR(50)) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE offers_count INT;
SELECT 
    COUNT(*)
INTO offers_count FROM
    property_offers po
        JOIN
    properties p ON po.property_id = p.id
        JOIN
    cities c ON p.city_id = c.id
WHERE
    c.name = cityName;

    RETURN offers_count;
END $

DELIMITER ;

-- SPECIAL OFFER
DELIMITER $

CREATE PROCEDURE udp_special_offer(IN agentFirstName VARCHAR(50))
BEGIN
    UPDATE property_offers
    SET price = price * 0.9
    WHERE agent_id IN (SELECT id FROM agents WHERE first_name = agentFirstName);
END $

DELIMITER ;