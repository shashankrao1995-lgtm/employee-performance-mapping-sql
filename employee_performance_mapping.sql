-- Employee Performance Mapping - ScienceQtech
-- Course-end project 1

-- Q1. create database and import the 3 csv files
CREATE DATABASE employee;
USE employee;

-- imported data_science_team.csv, proj_table.csv and emp_record_table.csv
-- using Table Data Import Wizard (right click on employee > Table Data Import Wizard)

-- checking the imports
SHOW TABLES;
SELECT * FROM emp_record_table;
SELECT * FROM proj_table;
SELECT * FROM data_science_team;


-- Q2. employee list with department details
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT
FROM emp_record_table
ORDER BY DEPT, EMP_ID;


-- Q3. employees by rating band

-- rating less than 2
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING < 2;

-- rating between 2 and 4
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING BETWEEN 2 AND 4;

-- rating greater than 4
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING > 4;


-- Q4. employees in leadership positions
SELECT EMP_ID, FIRST_NAME, ROLE, DEPT AS DEPARTMENT
FROM emp_record_table
WHERE ROLE IN ('MANAGER', 'PRESIDENT', 'CEO')
ORDER BY ROLE;


-- Q5. employee details grouped by department, with max rating in each dept
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT AS DEPARTMENT, EMP_RATING,
       MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS MAX_DEPT_RATING
FROM emp_record_table
ORDER BY DEPT, EMP_RATING DESC;


-- Q6. min and max salary for each role
SELECT ROLE,
       MIN(SALARY) AS MIN_SALARY,
       MAX(SALARY) AS MAX_SALARY
FROM emp_record_table
GROUP BY ROLE
ORDER BY MAX_SALARY DESC;


-- Q7. rank employees on years of experience
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, EXP,
       RANK() OVER (ORDER BY EXP DESC) AS EXP_RANK,
       DENSE_RANK() OVER (ORDER BY EXP DESC) AS EXP_DENSE_RANK
FROM emp_record_table;


-- Q8. view - employees in various countries with salary more than 6000
CREATE VIEW emp_salary_above_6000 AS
SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY
FROM emp_record_table
WHERE SALARY > 6000;

SELECT * FROM emp_salary_above_6000
ORDER BY COUNTRY, SALARY DESC;


-- Q9. view - employees across countries earning more than 6000
-- Q8 already lists them row by row, so this view groups them country wise
-- (count of such employees + their names per country)
CREATE VIEW country_wise_high_earners AS
SELECT COUNTRY,
       COUNT(EMP_ID) AS NO_OF_EMPLOYEES,
       GROUP_CONCAT(CONCAT(FIRST_NAME, ' ', LAST_NAME)
                    ORDER BY SALARY DESC SEPARATOR ', ') AS EMPLOYEES
FROM emp_record_table
WHERE SALARY > 6000
GROUP BY COUNTRY;

SELECT * FROM country_wise_high_earners
ORDER BY NO_OF_EMPLOYEES DESC;


-- Q10. index on FIRST_NAME for the 'Eric' lookup

-- execution plan before index (type = ALL, full table scan)
EXPLAIN SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';

-- FIRST_NAME came in as text from the import wizard so a prefix length is needed
CREATE INDEX idx_first_name ON emp_record_table (FIRST_NAME(20));

-- execution plan after index (type = ref, uses idx_first_name)
EXPLAIN SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';

SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';


-- Q11. average salary distribution by continent and country
SELECT CONTINENT, COUNTRY,
       COUNT(EMP_ID) AS NO_OF_EMPLOYEES,
       ROUND(AVG(SALARY), 2) AS AVG_SALARY
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY
ORDER BY CONTINENT, AVG_SALARY DESC;

-- continent level average for comparison
SELECT CONTINENT,
       COUNT(EMP_ID) AS NO_OF_EMPLOYEES,
       ROUND(AVG(SALARY), 2) AS AVG_SALARY
FROM emp_record_table
GROUP BY CONTINENT
ORDER BY AVG_SALARY DESC;


-- Q12. additional (from the tasks section) - bonus estimate and training need

-- bonus taken as 5% of salary x employee rating
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, SALARY, EMP_RATING,
       ROUND(0.05 * SALARY * EMP_RATING, 2) AS BONUS
FROM emp_record_table
ORDER BY BONUS DESC;

SELECT ROUND(SUM(0.05 * SALARY * EMP_RATING), 2) AS TOTAL_BONUS_COST
FROM emp_record_table;

-- employees with rating below 2 flagged for training
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING < 2;
