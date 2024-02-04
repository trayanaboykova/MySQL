CREATE DATABASE exam_13;
USE exam_13;

-- TABLE DESIGN 
CREATE TABLE countries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE cities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    population INT,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id)
        REFERENCES countries (id)
);

CREATE TABLE universities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(60) NOT NULL UNIQUE,
    address VARCHAR(80) NOT NULL UNIQUE,
    tuition_fee DECIMAL(19 , 2 ) NOT NULL,
    number_of_staff INT,
    city_id INT,
    FOREIGN KEY (city_id)
        REFERENCES cities (id)
);

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    duration_hours DECIMAL(19 , 2 ),
    start_date DATE,
    teacher_name VARCHAR(60) NOT NULL UNIQUE,
    description TEXT,
    university_id INT,
    FOREIGN KEY (university_id)
        REFERENCES universities (id)
);

CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    age INT,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    is_graduated BOOLEAN NOT NULL,
    city_id INT,
    FOREIGN KEY (city_id)
        REFERENCES cities (id)
);

CREATE TABLE students_courses (
    grade DECIMAL(19 , 2 ) NOT NULL,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    FOREIGN KEY (student_id)
        REFERENCES students (id),
    FOREIGN KEY (course_id)
        REFERENCES courses (id)
);

-- INSERT
INSERT INTO courses(name, 
					duration_hours, 
                    start_date, 
                    teacher_name, 
                    description, 
                    university_id)
SELECT CONCAT(teacher_name, ' course'),
	   LENGTH(name) / 10,
	   DATE_ADD(start_date, INTERVAL 5 DAY),
       REVERSE(teacher_name),
       CONCAT('Course ', teacher_name, REVERSE(description)),
       DAY(start_date)
FROM courses
WHERE id <= 5;

-- UPDATE
UPDATE universities 
SET 
    tuition_fee = tuition_fee + 300
WHERE
    id BETWEEN 5 AND 12;

-- DELETE
DELETE FROM universities 
WHERE
    number_of_staff IS NULL;

-- CITIES 
SELECT 
    *
FROM
    cities
ORDER BY population DESC;

-- STUDENTS AGE
SELECT 
    first_name, last_name, age, phone, email
FROM
    students
WHERE
    age >= 21
ORDER BY first_name DESC , email ASC , id ASC
LIMIT 10;

-- NEW STUDENTS
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
    SUBSTRING(s.email, 2, 10) AS username,
    REVERSE(s.phone) AS password
FROM
    students s
        LEFT JOIN
    students_courses st ON s.id = st.student_id
WHERE
    st.course_id IS NULL
ORDER BY password DESC;

-- STUDENT COUNT
SELECT 
    COUNT(*) AS students_count, u.name AS university_name
FROM
    universities u
        JOIN
    courses c ON u.id = c.university_id
        JOIN
    students_courses sc ON c.id = sc.course_id
GROUP BY university_name
HAVING students_count >= 8
ORDER BY students_count DESC, university_name DESC;











