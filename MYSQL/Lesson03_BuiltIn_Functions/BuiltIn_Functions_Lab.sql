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