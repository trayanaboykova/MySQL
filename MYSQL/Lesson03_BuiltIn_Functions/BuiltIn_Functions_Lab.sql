-- FIND BOOK TITLES
SELECT title
FROM books
WHERE SUBSTRING(title, 1, 4) = 'The '
ORDER BY id;

-- REPLACE TITLES
SELECT 
	REPLACE(title,  'The', '***') AS 'title'
FROM books
WHERE SUBSTRING(title, 1, 4) = 'The ';

-- SUM COST OF ALL BOOKS
SELECT ROUND(SUM(`cost`), 2)
FROM `books`;

-- DAYS LIVED
SELECT 
	CONCAT(first_name, ' ', last_name) AS 'Full Name',
    TIMESTAMPDIFF(DAY, born, died) AS 'Days Lived'
FROM authors;