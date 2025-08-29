/*
Sebuah sekolah ingin melakukan analisis terhadap performa akademik siswanya. 
Data yang dikumpulkan meliputi gender, kelompok etnis (race/ethnicity), tingkat pendidikan orang tua,
jenis makan siang (standard atau free/reduced), partisipasi dalam kursus persiapan ujian, 
serta nilai matematika, membaca, dan menulis.

Sekolah berharap dengan adanya database ini, guru dan staf dapat:
1. Mengetahui distribusi performa siswa berdasarkan gender maupun kelompok etnis.
2. Melihat pengaruh latar belakang orang tua terhadap nilai akademik anak.
3. Mengidentifikasi siswa yang berpotensi membutuhkan bantuan tambahan.
4. Membuat laporan ringkas mengenai capaian akademik secara keseluruhan.
*/

-- Membuat database
CREATE DATABASE performa_siswa;

-- Menggunakan database
USE performa_siswa;

/* Pertanyaan & Jawaban */
-- 1. Bagaimana query untuk mendapatkan seluruh data dari tabel?
SELECT * FROM students_performance;

-- 2. Ada grup race/ethnicity apa saja pada dataset tersebut?
SELECT DISTINCT race_or_ethnicity
FROM students_performance
ORDER BY race_or_ethnicity;

-- 3. Orang dengan grup apa yang memiliki nilai math sama dengan 0?
SELECT * FROM students_performance
WHERE math_score = 0;

-- Mengurutkan nilai matematika dari terendah ke tertinggi
SELECT * FROM students_performance
ORDER BY math_score ASC;

-- 4. Berapa nilai writing terkecil orang yang memiliki orangtua dengan tingkat 
-- pendidikan associate's degree?
SELECT * FROM students_performance
WHERE parental_level_of_education = "associate's degree"
ORDER BY writing_score ASC
LIMIT 1;

-- 5. Jika nilai writing terendah orang di grup A dijumlahkan dengan nilai writing
-- terendah orang di grup B, maka hasilnya adalah…
SELECT * FROM students_performance
WHERE race_or_ethnicity IN ('group A', 'group B')
ORDER BY writing_score ASC
LIMIT 1;

-- 6. Berapa orang yang memiliki nilai math kurang dari 65 namun memiliki nilai
-- writing lebih besar dari 80?
SELECT * FROM students_performance
WHERE writing_score > 80
AND math_score < 65
ORDER BY writing_score ASC;

-- 7. Jika data difilter dengan nilai reading lebih dari 10 namun kurang dari 25,
-- tingkat pendidikan orangtua apa saja yang termasuk ke dalam data tersebut?
SELECT * FROM students_performance
WHERE reading_score > 10
AND reading_score < 25
ORDER BY reading_score ASC;

-- atau menggunakan between
SELECT * FROM students_performance
WHERE reading_score BETWEEN 11 AND 24
ORDER BY reading_score ASC;

-- 8. Berapa rata-rata nilai math, reading, dan writing untuk setiap gender?
SELECT gender, 
       AVG(math_score) AS avg_math, 
       AVG(reading_score) AS avg_reading, 
       AVG(writing_score) AS avg_writing
FROM students_performance
GROUP BY gender;

-- 9. Kelompok etnis mana yang memiliki nilai rata-rata reading tertinggi?
SELECT race_or_ethnicity, AVG(reading_score) AS avg_reading
FROM students_performance
GROUP BY race_or_ethnicity
ORDER BY avg_reading DESC
LIMIT 1;

-- 10. Berapa banyak siswa yang mengikuti test preparation course dan berapa banyak yang tidak?
SELECT test_preparation_course, COUNT(*) AS jumlah
FROM students_performance
GROUP BY test_preparation_course;

-- 11. Siapa saja (gender dan etnisnya) yang memiliki nilai math lebih besar dari 90?
SELECT gender, race_or_ethnicity, math_score
FROM students_performance
WHERE math_score > 90;

-- 12. Apakah siswa dengan lunch free/reduced cenderung memiliki nilai 
-- rata-rata lebih rendah dibanding yang standard?
SELECT lunch, 
       AVG(math_score) AS avg_math, 
       AVG(reading_score) AS avg_reading, 
       AVG(writing_score) AS avg_writing
FROM students_performance
GROUP BY lunch;

-- 13. Cari 5 siswa dengan nilai total (math + reading + writing) tertinggi.
SELECT gender, race_or_ethnicity, 
       (math_score + reading_score + writing_score) AS total_score
FROM students_performance
ORDER BY total_score DESC
LIMIT 5;

-- 14. Mengambil semua data yang ada kata "high" di tengah, depan, atau belakang string.
SELECT * FROM students_performance
WHERE parental_level_of_education LIKE '%high%'
AND race_or_ethnicity NOT IN ('group A', 'group B')
AND reading_score < 35;

-- 15. Mengambil hanya data yang diawali dengan "high".
SELECT * FROM students_performance
WHERE parental_level_of_education LIKE 'high%'
AND race_or_ethnicity NOT IN ('group A', 'group B')
AND reading_score < 35;

-- 16. Berapa jumlah record pada dataset tersebut?
SELECT COUNT(*) as jumlah_record
FROM students_performance;

-- 17. Tunjukkan perbandingan rata-rata nilai reading laki-laki dan perempuan
SELECT gender,
    AVG(reading_score) AS avg_reading_score
FROM students_performance
GROUP BY gender;

-- 18. Tunjukkan nilai math tertinggi dan terendah dari masing-masing tingkatan
-- pendidikan orangtua (parental level of education)
SELECT parental_level_of_education,
	MAX(math_score),
    MIN(math_score)
FROM students_performance
GROUP BY parental_level_of_education
ORDER BY parental_level_of_education;

-- 19. Berapa nilai rata-rata dari math, reading dan writing orang
-- bergender perempuan yang pernah / sudah menyelesaikan
-- kursus persiapan ujian (test_preparation_course)?
SELECT gender, test_preparation_course, AVG(math_score),
    AVG(reading_score), AVG(writing_score)
FROM students_performance
WHERE gender = 'female'
AND test_preparation_course = 'completed';

-- 20. Berapa nilai rata-rata writing orang yang memiliki
-- orangtua yang tingkat pendidikannya adalah high school /
-- some high school? (digabung, tidak terpisah)
SELECT AVG(writing_score) AS avg_writing_score
FROM students_performance
WHERE parental_level_of_education LIKE '%high school%';

-- 21. Bagaimana rata-rata nilai math, reading, dan writing 
-- jika dikelompokkan berdasarkan gender, kelompok etnis, dan 
-- status test preparation course?
SELECT gender, race_or_ethnicity, test_preparation_course,
    AVG(math_score) AS avg_math_score,
    AVG(reading_score) AS avg_reading_score,
    AVG(writing_score) AS avg_writing_score
FROM students_performance
GROUP BY gender, race_or_ethnicity,
    test_preparation_course
ORDER BY gender, race_or_ethnicity,
    test_preparation_course;

-- 22. Dari hasil pengelompokan berdasarkan gender, kelompok etnis, 
-- dan status test preparation course, kelompok mana saja yang memiliki 
-- rata-rata nilai math lebih besar dari 70?
SELECT gender, race_or_ethnicity, test_preparation_course,
    AVG(math_score) AS avg_math_score,
    AVG(reading_score) AS avg_reading_score,
    AVG(writing_score) AS avg_writing_score
FROM students_performance
GROUP BY gender, race_or_ethnicity,
    test_preparation_course
HAVING avg_math_score > 70
ORDER BY gender, race_or_ethnicity,
    test_preparation_course;

/* Stored Procedure
Stored Procedure merupakan perintah SQL yang telah didefinisikan,
dinamai, dan disimpan di dalam database. Dengan stored procedure kita
dapat menjalankan sekelompok perintah secara berulang-ulang dari
berbagai skrip.

Stored Procedure dapat menerima parameter sebagai input dan melakukan
operasi database yang kompleks. Selain itu,stored procedure juga dapat mengembalikan hasil yang dapat digunakan dalam pemrograman.
*/

-- 23. Bagaimana query untuk membuat stored procedure yang menampilkan seluruh data pada 
-- tabel students_performance
DELIMITER $$
CREATE PROCEDURE get_all_data () 
BEGIN
    SELECT * FROM students_performance;
END $$
DELIMITER ;

CALL get_all_data();

-- 24. Dengan menggunakan query get_all_data(),
-- modifikasilah query agar dapat menampilkan data pada
-- tabel studensts_performance untuk grup ras tertentu saja!
-- selanjutnya, membuat stored procedure dengan memasukan parameter IN
-- akan dibuat stored procedure untuk memunculkan seluruh data dengan memasukkan race_or_ethnicity
DELIMITER $$
CREATE PROCEDURE get_all_data_by_race (IN race_group VARCHAR(100))
BEGIN
    SELECT * FROM students_performance WHERE race_or_ethnicity = race_group;
END $$ 
DELIMITER ;

SET @race = 'group A' ;
CALL get_all_data_by_race(@race);

-- 25. Buatlah stored procedure untuk memberikan nilai math
-- rata-rata seluruh data!
-- membuat stored procedure dengan menggunakan parameter OUT
DELIMITER $$
CREATE PROCEDURE get_math_score_avg (OUT math_score_avg FLOAT)
BEGIN
    SELECT AVG(students_performance.math_score) INTO math_score_avg
    FROM students_performance;
END $$
DELIMITER ;

CALL get_math_score_avg(@rerata_nilai_math);
SELECT @rerata_nilai_math;

-- 26. menampilkan seluruh data yang memiliki nilai math lebih dari rata-rata menggunakan output nomor 25
SELECT * FROM students_performance WHERE reading_score > @rerata_nilai_math;

-- 27. query yang menghasilkan rata-rata nilai matematika berdasarkan gender (misal male)
DELIMITER $$
CREATE PROCEDURE get_gend_math_score_avg (IN gender_var VARCHAR(255), OUT math_score_avg FLOAT)
BEGIN
    SELECT AVG(students_performance.math_score) INTO math_score_avg
    FROM students_performance WHERE gender = gender_var;
END $$ DELIMITER ;

SET @jenis_gender = 'male';
CALL get_gend_math_score_avg(@jenis_gender, @rerata_nilai_math);
SELECT @jenis_gender, @rerata_nilai_math;

