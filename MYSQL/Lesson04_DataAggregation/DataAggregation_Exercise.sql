-- RECORDS COUNT
SELECT COUNT(*) AS count FROM wizzard_deposits;

-- LONGEST MAGIC WAND
SELECT MAX(magic_wand_size) AS longest_magic_wand
FROM wizzard_deposits;

-- LONGEST MAGIC PER DEPOSIT GROUPS
SELECT deposit_group, MAX(magic_wand_size) AS longest_magic_wand
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY longest_magic_wand, deposit_group;

-- SMALLEST DEPOSIT GROUP PER MAGIC WAND SIZE
SELECT deposit_group
FROM wizzard_deposits
GROUP BY deposit_group
LIMIT 1;

-- DEPOSITS SUM
SELECT deposit_group, SUM(deposit_amount) AS total_sum
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY total_sum;

-- DEPOSITS SUM FOR OLLIVANDER FAMILY
SELECT deposit_group, SUM(deposit_amount) AS total_sum
FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group
ORDER BY deposit_group;

-- DEPOSITS FILTER
SELECT deposit_group, SUM(deposit_amount) AS total_sum
FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group
HAVING total_sum < 150000
ORDER BY total_sum DESC;

-- DEPOSIT CHARGE
SELECT deposit_group, magic_wand_creator, MIN(deposit_charge) AS min_deposit_charge
FROM wizzard_deposits
GROUP BY deposit_group, magic_wand_creator
ORDER BY magic_wand_creator, deposit_group;

-- AGE GROUPS
SELECT 
	CASE
		WHEN age < 11 THEN '[0-10]'
		WHEN age < 21 THEN '[11-20]'
		WHEN age < 31 THEN '[21-30]'
		WHEN age < 41 THEN '[31-40]'
		WHEN age < 51 THEN '[41-50]'
		WHEN age < 61 THEN '[51-60]'
		WHEN age >= 61 THEN '[61+]'
    END AS age_group,
    COUNT(*) AS wizard_count
FROM wizzard_deposits
GROUP BY age_group
ORDER BY wizard_count;

-- FIRST LETTER


-- AVERAGE INTEREST


-- EMPLOYEES MINIMUM SALARIES


-- EMPLOYEES AVERAGE SALARIES


-- EMPLOYEES MAXIMUM SALARIES


-- EMPLOYEES COUNT SALARIES


-- 3RD HIGHEST SALARY


-- SALARY CHALLANGE


-- DEPARTMENTS TOTAL SALARIES

