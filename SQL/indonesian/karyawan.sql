/*
Sebuah perusahaan sedang berkembang pesat dengan jumlah karyawan yang terus bertambah 
di berbagai departemen seperti IT, HR, Finance, dan Marketing. 
Perusahaan ini membutuhkan sistem database untuk mencatat informasi karyawan 
serta struktur departemen agar pengelolaan SDM menjadi lebih efisien.

Untuk itu, dibangunlah database `perusahaan_karyawan` dengan struktur utama:
1. Tabel `departments` untuk menyimpan data departemen (ID dan nama departemen).
2. Tabel `employee` untuk menyimpan data karyawan (nama, tanggal lahir, tanggal bergabung, gaji, dan departemen).

Dengan sistem ini, perusahaan dapat:
- Mengetahui daftar karyawan beserta departemennya.
- Mengelola informasi gaji dan tanggal perekrutan.
- Melihat distribusi karyawan di setiap departemen.
- Membantu analisis SDM, seperti mencari karyawan dengan gaji tertinggi atau rata-rata gaji per departemen.
*/

-- Membuat database karyawan
CREATE DATABASE karyawan;
USE karyawan;

-- Buat tabel departments
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

-- Buat tabel employee
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

-- Insert data departments
INSERT INTO departments (department_id, department_name) VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing');

-- Insert data employee
INSERT INTO employee (employee_id, first_name, last_name, birth_date, hire_date, salary, department_id) VALUES
(1, 'John', 'Smith', '1980-05-15', '2015-02-28', 60000, 1),
(2, 'Jane', 'Doe', '1985-08-22', '2018-07-15', 70000, 2),
(3, 'Robert', 'Johnson', '1990-12-10', '2020-01-10', 80000, 1),
(4, 'Alice', 'Brown', '1982-03-05', '2016-09-20', 65000, 3),
(5, 'Emily', 'Davis', '1988-07-30', '2017-11-12', 75000, 2);

-- Memeriksa tabel
SELECT * FROM departments;
SELECT * FROM employee;

-- 1️ Tampilkan daftar semua karyawan beserta nama departemennya
SELECT e.first_name, e.last_name, d.department_name
FROM employee e
JOIN departments d ON e.department_id = d.department_id;

-- 2️. Cari karyawan dengan gaji tertinggi
SELECT first_name, last_name, salary
FROM employee
ORDER BY salary DESC
LIMIT 1;

-- 3. Hitung rata-rata gaji karyawan di setiap departemen
SELECT d.department_name, AVG(e.salary) AS rata_rata_gaji
FROM employee e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 4. Tampilkan karyawan yang direkrut paling awal (paling lama bekerja)
SELECT first_name, last_name, hire_date
FROM employee
ORDER BY hire_date ASC
LIMIT 1;

-- 5. Hitung jumlah karyawan di setiap departemen
SELECT d.department_name, COUNT(e.employee_id) AS jumlah_karyawan
FROM employee e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 6. Cari karyawan yang lahir sebelum tahun 1985
SELECT first_name, last_name, birth_date
FROM employee
WHERE birth_date < '1985-01-01';

-- 7. Tampilkan total gaji yang harus dibayarkan perusahaan untuk semua karyawan
SELECT SUM(salary) AS total_gaji_perusahaan
FROM employee;

-- 8. Tampilkan 3 karyawan dengan gaji tertinggi
SELECT first_name, last_name, salary
FROM employee
ORDER BY salary DESC
LIMIT 3;

-- 9. Cari karyawan yang bekerja di departemen HR dengan gaji di atas 70,000
SELECT e.first_name, e.last_name, e.salary
FROM employee e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'HR' AND e.salary > 70000;

-- 10. Hitung berapa tahun setiap karyawan sudah bekerja di perusahaan
SELECT first_name, last_name, 
       TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS lama_bekerja_tahun
FROM employee;

-- 11. Menampilkan daftar karyawan beserta nama departemen
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

-- 12. Buatlah query untuk membuat kolom tahun dan bulan secara terpisah untuk setiap record
SELECT 
    employee_id,
    first_name,
    last_name,
    YEAR(hire_date) AS tahun_masuk,
    MONTH(hire_date) AS bulan_masuk
FROM employee;

-- 13. Buatlah query untuk memunculkan karyawan dengan masa kerja 5-10 tahun
SELECT 
    employee_id,
    first_name,
    last_name,
    hire_date,
    TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS masa_kerja_tahun
FROM employee
WHERE TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) BETWEEN 5 AND 10;

-- 14. Buatlah query untuk memunculkan nama dan department dari 
-- masing-masing karyawan dengan format Last Name, First Name_Department
SELECT 
    CONCAT(e.last_name, ', ', e.first_name, '_', d.department_name) 
    AS nama_departemen
FROM employee e
JOIN departments d ON e.department_id = d.department_id;

-- 15. Buatlah query untuk memunculkan karyawan yang berulang tahun pada bulan ini
SELECT 
    employee_id,
    first_name,
    last_name,
    birth_date
FROM employee
WHERE MONTH(birth_date) = MONTH(CURDATE());



