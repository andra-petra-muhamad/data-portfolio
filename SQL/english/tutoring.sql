/* 
Your friend, Rangga, is managing a tutoring company 
for high school (SMA/SMK) students in Sumedang. 
Initially, Rangga recorded all data in his notebook. 
However, he found it difficult to search for specific data 
and process it efficiently. 

Rangga shared this problem with you, and you offered a solution 
to create a database using MySQL to help him manage the data better.
*/

/* Database & Table Creation */
-- Create database
CREATE DATABASE tutoring;

-- Create student table
CREATE TABLE tutoring.students (
    student_id VARCHAR(255) NOT NULL,
    student_name VARCHAR(255) NOT NULL,
    student_address VARCHAR(255) NULL,
    student_birthdate DATE NULL,
    student_class VARCHAR(255) NOT NULL,
    student_school VARCHAR(255) NULL
);

/* Insert Student Data */
INSERT INTO tutoring.students (
    student_id,
    student_name,
    student_address,
    student_birthdate,
    student_class,
    student_school
)
VALUES 
    ('A000000001', 'Rizka', 'Jalan Pegangsaan No. 800 Jakarta', '2004-10-10', '12', 'Nurul Hidayah High School'),
    ('A000000002', 'Nandang', 'Jalan Nasional No. 900 Penajam Paser Utara, East Kalimantan', NULL, '11', 'National Indonesia Raya High School'),
    ('A000000003', 'Ayu', 'Jl. Raya Bandung No. 45', '2005-01-15', '11', 'Bandung Vocational High School 1'),
    ('A000000004', 'Doni', 'Jl. Merdeka No. 12 Sumedang', '2003-07-21', '12', 'Sumedang High School 2'),
    ('A000000005', 'Sinta', 'Jl. Cihampelas No. 22 Bandung', '2004-03-11', '10', 'Bina Bangsa High School Bandung')
    ;
    
/* Questions & Queries */
-- 1. Display all registered students.
SELECT * FROM tutoring.students;

-- 2. Count how many students have been registered.
SELECT COUNT(*) AS total_students
FROM tutoring.students;

-- 3. Show students who live in Sumedang.
SELECT student_name, student_address
FROM tutoring.students
WHERE student_address LIKE '%Sumedang%';

-- 4. Show all students in grade 12.
SELECT student_name, student_school
FROM tutoring.students
WHERE student_class = '12';

-- 5. Sort students by birthdate (from oldest to youngest).
SELECT student_name, student_birthdate
FROM tutoring.students
ORDER BY student_birthdate ASC;

-- Since there are NULL values, we can filter them out:
SELECT student_name, student_birthdate
FROM tutoring.students
WHERE student_birthdate IS NOT NULL
ORDER BY student_birthdate ASC;

-- 6. Find the first 2 students registered (based on student_id).
SELECT student_id, student_name
FROM tutoring.students
ORDER BY student_id ASC
LIMIT 2;
