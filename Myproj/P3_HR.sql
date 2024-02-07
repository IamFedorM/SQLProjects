-- Active: 1705924926922@@localhost@3306
CREATE DATABASE Human_Resources;
USE Human_Resources;

-- Use Wizaerd to import a table COMMENT

-- **1. Data cleaning**
Select * from hrr;
DESCRIBE hrr;

-- Must have to do when cleaming:
SET sql_safe_updates = 0;
-- Let's make birthdate date the same format 
-- Convert birthdate back to 'YYYY-MM-DD' format
UPDATE hrr
SET birthdate = CASE
    WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%y'), '%Y-%m-%d')
    ELSE NULL
END;

-- Change the column type to DATE
ALTER TABLE hrr
MODIFY COLUMN birthdate DATE;

-- Do the same with a hiring date
UPDATE hrr
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%y'), '%Y-%m-%d')
    WHEN hire_date LIKE '____-__-__' THEN hire_date
    ELSE NULL
END;

ALTER TABLE hrr
MODIFY COLUMN hire_date DATE;

-- Do the same with a termination date
UPDATE hrr
SET termdate = CASE
    WHEN termdate = '' THEN NULL
    ELSE date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
END
WHERE termdate IS NOT NULL;

ALTER TABLE hrr
MODIFY COLUMN termdate DATE;

-- Let's add age column 
ALTER TABLE hrr ADD COLUMN age int;
UPDATE hrr
SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());

-- Let's check that we did the correct calculations
SELECT birthdate, age from hrr;
-- Well done Fedor 

Select
    MIN(age) as youngest,
    MAX(age) as oldest
from hrr;
-- Youngest is -45, which is obviously a mistake. Let's check it out
SELECT count(*) from hrr where age < 18;
-- We take into the account that there are 967 people who have a negative age

-- **2. Analysis**
-- 1. What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*) AS count
FROM hrr
WHERE age >= 18
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS count
FROM hrr
WHERE age >= 18
GROUP BY race;

-- 3. What is the age distribution of employees in the company?
SELECT
min(age) AS youngest,
max(age) AS oldest
FROM hrr
WHERE age >= 18;

-- I also want to know a gender distribution
SELECT 
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        WHEN age >= 65 THEN '65+'
    END AS age_group, gender,
    COUNT(*) AS count
FROM hrr
WHERE age >= 18
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquarters versus remote locations?
SELECT location, COUNT(*) AS count
FROM hrr
WHERE age >= 18
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT
round(avg(datediff(termdate, hire_date))/365,0) AS avg_length_employment
FROM hrr
WHERE termdate <= curdate() AND age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?
SELECT department, gender, COUNT(*) AS count
FROM hrr
WHERE age >= 18
GROUP BY department, gender
ORDER BY department, gender;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*) AS count
FROM hrr
WHERE age >= 18
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?
SELECT department, total_count, terminated_count, terminated_count/total_count AS turnover_rate
FROM (
    SELECT department, 
    COUNT(*) AS total_count,
    SUM(CASE WHEN termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM hrr
    WHERE age >= 18
    GROUP BY department
) as subquery
ORDER BY total_count DESC;

-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, COUNT(*) AS count
FROM hrr
WHERE age >= 18 
GROUP BY location_state
ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT 
    YEAR(hire_date) AS year,
    COUNT(*) AS hired_count,
    SUM(CASE WHEN termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count,
    COUNT(*) - SUM(CASE WHEN termdate <= curdate() THEN 1 ELSE 0 END) AS net_growth,
    ((COUNT(*) - SUM(CASE WHEN termdate <= curdate() THEN 1 ELSE 0 END)) / COUNT(*)) * 100 AS net_change_percent
FROM hrr
WHERE age >= 18
GROUP BY year
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
SELECT department, 
    COUNT(*) AS count,
    round(avg(datediff(termdate, hire_date))/365,0) AS avg_tenure
FROM hrr
WHERE termdate <= curdate() AND age >= 18
GROUP BY department
ORDER BY avg_tenure DESC;

-- Now we move to Power BI, project in SQL is finished