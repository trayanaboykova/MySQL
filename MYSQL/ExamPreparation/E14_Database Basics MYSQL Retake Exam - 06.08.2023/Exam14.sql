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






