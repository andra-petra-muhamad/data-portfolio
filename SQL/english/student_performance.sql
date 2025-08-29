/*
A school wants to analyze the academic performance of its students.  
The collected data includes: gender, race/ethnicity, parental level of education,  
lunch type (standard or free/reduced), participation in test preparation courses,  
and scores in math, reading, and writing.  

With this database, the school expects teachers and staff to be able to:  
1. Understand the distribution of student performance based on gender and race/ethnicity.  
2. Examine the impact of parents' education level on students’ academic performance.  
3. Identify students who may need additional support.  
4. Generate summary reports on overall academic achievement.  
*/

-- Create database
CREATE DATABASE ds_student_performance;

-- Use database
USE ds_student_performance;

/* Questions & Queries */
-- 1. How to query all data from the table?
SELECT * FROM students_performance;

-- 2. What race/ethnicity groups are available in the dataset?
SELECT DISTINCT race_or_ethnicity
FROM students_performance
ORDER BY race_or_ethnicity;

-- 3. Which group has students with a math score of 0?
SELECT * FROM students_performance
WHERE math_score = 0;

-- Sort math scores from lowest to highest
SELECT * FROM students_performance
ORDER BY math_score ASC;

-- 4. What is the lowest writing score among students whose parents have an associate's degree?
SELECT * FROM students_performance
WHERE parental_level_of_education = "associate's degree"
ORDER BY writing_score ASC
LIMIT 1;

-- 5. If the lowest writing score from group A is added to the lowest from group B, what is the result?
SELECT * FROM students_performance
WHERE race_or_ethnicity IN ('group A', 'group B')
ORDER BY writing_score ASC
LIMIT 1;

-- 6. How many students scored less than 65 in math but more than 80 in writing?
SELECT * FROM students_performance
WHERE writing_score > 80
AND math_score < 65
ORDER BY writing_score ASC;

-- 7. If data is filtered with reading scores greater than 10 but less than 25, 
-- what parental education levels appear in that subset?
SELECT * FROM students_performance
WHERE reading_score > 10
AND reading_score < 25
ORDER BY reading_score ASC;

-- or using BETWEEN
SELECT * FROM students_performance
WHERE reading_score BETWEEN 11 AND 24
ORDER BY reading_score ASC;

-- 8. What are the average math, reading, and writing scores for each gender?
SELECT gender, 
       AVG(math_score) AS avg_math, 
       AVG(reading_score) AS avg_reading, 
       AVG(writing_score) AS avg_writing
FROM students_performance
GROUP BY gender;

-- 9. Which race/ethnicity group has the highest average reading score?
SELECT race_or_ethnicity, AVG(reading_score) AS avg_reading
FROM students_performance
GROUP BY race_or_ethnicity
ORDER BY avg_reading DESC
LIMIT 1;

-- 10. How many students completed the test preparation course and how many did not?
SELECT test_preparation_course, COUNT(*) AS total
FROM students_performance
GROUP BY test_preparation_course;

-- 11. Which students (gender and ethnicity) scored above 90 in math?
SELECT gender, race_or_ethnicity, math_score
FROM students_performance
WHERE math_score > 90;

-- 12. Do students with free/reduced lunch tend to have lower average scores than those with standard lunch?
SELECT lunch, 
       AVG(math_score) AS avg_math, 
       AVG(reading_score) AS avg_reading, 
       AVG(writing_score) AS avg_writing
FROM students_performance
GROUP BY lunch;

-- 13. Find the top 5 students with the highest total scores (math + reading + writing).
SELECT gender, race_or_ethnicity, 
       (math_score + reading_score + writing_score) AS total_score
FROM students_performance
ORDER BY total_score DESC
LIMIT 5;

-- 14. Retrieve all records where parental education contains "high"
SELECT * FROM students_performance
WHERE parental_level_of_education LIKE '%high%'
AND race_or_ethnicity NOT IN ('group A', 'group B')
AND reading_score < 35;

-- 15. Retrieve all records where parental education starts with "high"
SELECT * FROM students_performance
WHERE parental_level_of_education LIKE 'high%'
AND race_or_ethnicity NOT IN ('group A', 'group B')
AND reading_score < 35;

-- 16. How many records exist in the dataset?
SELECT COUNT(*) as total_records
FROM students_performance;

-- 17. Compare average reading scores between male and female students
SELECT gender,
    AVG(reading_score) AS avg_reading_score
FROM students_performance
GROUP BY gender;

-- 18. Show the highest and lowest math scores for each parental education level
SELECT parental_level_of_education,
	MAX(math_score) AS max_math,
    MIN(math_score) AS min_math
FROM students_performance
GROUP BY parental_level_of_education
ORDER BY parental_level_of_education;

-- 19. What are the average math, reading, and writing scores of female students 
-- who completed the test preparation course?
SELECT gender, test_preparation_course, AVG(math_score),
    AVG(reading_score), AVG(writing_score)
FROM students_performance
WHERE gender = 'female'
AND test_preparation_course = 'completed';

-- 20. What is the average writing score of students whose parents’ education level 
-- is high school or some high school? (combined, not separated)
SELECT AVG(writing_score) AS avg_writing_score
FROM students_performance
WHERE parental_level_of_education LIKE '%high school%';

-- 21. What are the average math, reading, and writing scores grouped by gender, race/ethnicity, 
-- and test preparation course status?
SELECT gender, race_or_ethnicity, test_preparation_course,
    AVG(math_score) AS avg_math_score,
    AVG(reading_score) AS avg_reading_score,
    AVG(writing_score) AS avg_writing_score
FROM students_performance
GROUP BY gender, race_or_ethnicity, test_preparation_course
ORDER BY gender, race_or_ethnicity, test_preparation_course;

-- 22. From the grouping above, which groups have an average math score greater than 70?
SELECT gender, race_or_ethnicity, test_preparation_course,
    AVG(math_score) AS avg_math_score,
    AVG(reading_score) AS avg_reading_score,
    AVG(writing_score) AS avg_writing_score
FROM students_performance
GROUP BY gender, race_or_ethnicity, test_preparation_course
HAVING avg_math_score > 70
ORDER BY gender, race_or_ethnicity,
    test_preparation_course;
    
/* Stored Procedures
A Stored Procedure is a predefined SQL statement, named and stored in the database.  
It allows executing a group of statements repeatedly from different scripts.  

Stored Procedures can accept input parameters, perform complex operations,  
and return results that can be used in applications.  
*/

-- 23. Create a stored procedure to display all data in students_performance table
DELIMITER $$
CREATE PROCEDURE get_all_data () 
BEGIN
    SELECT * FROM students_performance;
END $$
DELIMITER ;

CALL get_all_data();

-- 24. Modify the stored procedure to display data for a specific race/ethnicity group (IN parameter)
DELIMITER $$
CREATE PROCEDURE get_all_data_by_race (IN race_group VARCHAR(100))
BEGIN
    SELECT * FROM students_performance WHERE race_or_ethnicity = race_group;
END $$ 
DELIMITER ;

SET @race = 'group A' ;
CALL get_all_data_by_race(@race);

-- 25. Create a stored procedure to calculate the average math score (OUT parameter)
DELIMITER $$
CREATE PROCEDURE get_math_score_avg (OUT math_score_avg FLOAT)
BEGIN
    SELECT AVG(students_performance.math_score) INTO math_score_avg
    FROM students_performance;
END $$
DELIMITER ;

CALL get_math_score_avg(@avg_math_score);
SELECT @avg_math_score;

-- 26. Display all data where reading score is greater than the average math score (from step 25)
SELECT * FROM students_performance WHERE reading_score > @avg_math_score;

-- 27. Stored procedure to calculate the average math score for a specific gender (IN + OUT parameters)
DELIMITER $$
CREATE PROCEDURE get_gender_math_score_avg (IN gender_var VARCHAR(255), OUT math_score_avg FLOAT)
BEGIN
    SELECT AVG(students_performance.math_score) INTO math_score_avg
    FROM students_performance WHERE gender = gender_var;
END $$ 
DELIMITER ;

SET @gender_type = 'male';
CALL get_gender_math_score_avg(@gender_type, @avg_math_score);
SELECT @gender_type, @avg_math_score;