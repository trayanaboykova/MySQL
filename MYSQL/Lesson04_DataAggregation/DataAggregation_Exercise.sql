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


-- DEPOSITS FILTER


-- DEPOSIT CHARGE


-- AGE GROUPS


-- FIRST LETTER


-- AVERAGE INTEREST


-- EMPLOYEES MINIMUM SALARIES


-- EMPLOYEES AVERAGE SALARIES


-- EMPLOYEES MAXIMUM SALARIES


-- EMPLOYEES COUNT SALARIES


-- 3RD HIGHEST SALARY


-- SALARY CHALLANGE


-- DEPARTMENTS TOTAL SALARIES
