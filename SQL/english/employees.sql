/*
A company is rapidly growing with an increasing number of employees 
across various departments such as IT, HR, Finance, and Marketing. 
The company needs a database system to record employee information 
as well as department structure so that HR management becomes more efficient.

Therefore, the `company_employees` database is built with the main structure:
1. `departments` table to store department data (ID and department name).
2. `employee` table to store employee data (name, birth date, hire date, salary, and department).

With this system, the company can:
- View the list of employees along with their departments.
- Manage salary information and hiring dates.
- See the distribution of employees in each department.
- Assist HR analysis, such as finding the highest-paid employee or the average salary per department.
*/

-- Create employee database
CREATE DATABASE employees;
USE employees;

-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

-- Create employee table
CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE,
    hire_date DATE,
    salary DECIMAL(10,2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Insert departments data
INSERT INTO departments (department_id, department_name) VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing');

-- Insert employee data
INSERT INTO employee (employee_id, first_name, last_name, birth_date, hire_date, salary, department_id) VALUES
(1, 'John', 'Smith', '1980-05-15', '2015-02-28', 60000, 1),
(2, 'Jane', 'Doe', '1985-08-22', '2018-07-15', 70000, 2),
(3, 'Robert', 'Johnson', '1990-12-10', '2020-01-10', 80000, 1),
(4, 'Alice', 'Brown', '1982-03-05', '2016-09-20', 65000, 3),
(5, 'Emily', 'Davis', '1988-07-30', '2017-11-12', 75000, 2);

-- Check tables
SELECT * FROM departments;
SELECT * FROM employee;

-- 1. Show the list of all employees along with their department names
SELECT e.first_name, e.last_name, d.department_name
FROM employee e
JOIN departments d ON e.department_id = d.department_id;

-- 2. Find the employee with the highest salary
SELECT first_name, last_name, salary
FROM employee
ORDER BY salary DESC
LIMIT 1;

-- 3. Calculate the average salary of employees in each department
SELECT d.department_name, AVG(e.salary) AS average_salary
FROM employee e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 4. Show the employee who was hired the earliest (longest working)
SELECT first_name, last_name, hire_date
FROM employee
ORDER BY hire_date ASC
LIMIT 1;

-- 5. Count the number of employees in each department
SELECT d.department_name, COUNT(e.employee_id) AS total_employees
FROM employee e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 6. Find employees born before 1985
SELECT first_name, last_name, birth_date
FROM employee
WHERE birth_date < '1985-01-01';

-- 7. Show the total salary expense for all employees
SELECT SUM(salary) AS total_company_salary
FROM employee;

-- 8. Show the top 3 employees with the highest salaries
SELECT first_name, last_name, salary
FROM employee
ORDER BY salary DESC
LIMIT 3;

-- 9. Find employees working in the HR department with salary above 70,000
SELECT e.first_name, e.last_name, e.salary
FROM employee e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'HR' AND e.salary > 70000;

-- 10. Calculate how many years each employee has been working at the company
SELECT first_name, last_name, 
       TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_of_service
FROM employee;

-- 11. Display the list of employees along with their department names
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.birth_date,
    e.hire_date,
    e.salary,
    d.department_name
FROM employee e
JOIN departments d 
    ON e.department_id = d.department_id
ORDER BY e.employee_id;

-- 12. Create a query to generate separate year and month columns for each record
SELECT 
    employee_id,
    first_name,
    last_name,
    YEAR(hire_date) AS hire_year,
    MONTH(hire_date) AS hire_month
FROM employee;

-- 13. Create a query to display employees with a service period of 5–10 years
SELECT 
    employee_id,
    first_name,
    last_name,
    hire_date,
    TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_of_service
FROM employee
WHERE TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) BETWEEN 5 AND 10;

-- 14. Create a query to display employee names and departments 
-- in the format Last Name, First Name_Department
SELECT 
    CONCAT(e.last_name, ', ', e.first_name, '_', d.department_name) 
    AS name_department
FROM employee e
JOIN departments d ON e.department_id = d.department_id;

-- 15. Show employees who have birthdays in the current month
SELECT 
    employee_id,
    first_name,
    last_name,
    birth_date
FROM employee
WHERE MONTH(birth_date) = MONTH(CURDATE());
