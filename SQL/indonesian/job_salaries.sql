/*
Sebuah perusahaan konsultan data sedang berkembang pesat 
dan mempekerjakan berbagai profesional di bidang data science, 
seperti Data Scientist, Machine Learning Engineer, dan Data Analyst. 
Karyawan bekerja dalam berbagai jenis kontrak, level pengalaman, 
serta tersebar di banyak negara.

Untuk mendukung pengelolaan SDM dan analisis kompensasi, 
dibangunlah database `job_salaries` dengan struktur utama:
Tabel `salaries` menyimpan informasi gaji setiap karyawan, 
termasuk tahun kerja (work_year), jabatan (job_title), 
level pengalaman, jenis kerja (full-time, part-time, kontrak), 
kategori perusahaan (swasta, publik), lokasi perusahaan, 
lokasi karyawan, gaji tahunan dalam mata uang lokal, 
serta gaji yang sudah dikonversi ke USD.

Dengan sistem ini, perusahaan dapat:
- Menganalisis tren gaji dari tahun ke tahun.
- Membandingkan rata-rata gaji berdasarkan job title dan level pengalaman.
- Mengetahui perbedaan gaji antara perusahaan kecil, menengah, dan besar.
- Mengevaluasi perbedaan gaji karyawan berdasarkan lokasi (remote, onsite, hybrid).
- Mendukung pengambilan keputusan HR terkait rekrutmen, promosi, dan penawaran gaji.
*/


-- Membuat database dan untuk tabel diimport dari data eksternal
CREATE DATABASE job_salaries;
USE job_salaries;

-- Memeriksa data dan mengubah tipe data
SELECT * FROM salaries;
ALTER TABLE salaries 
MODIFY COLUMN work_year YEAR;

/* Pertanyaan dan Jawaban */
-- 1. Menampilkan job_title yang terdapat dalam tabel
SELECT DISTINCT job_title
FROM salaries
ORDER BY job_title;

-- 2. Melihat job apa saja yang berkaitan dengan data analyst.
SELECT DISTINCT job_title
FROM salaries
WHERE job_title LIKE "%data analyst%"
ORDER BY job_title;

-- 3. Rata-rata gaji data anlyst
SELECT AVG(salary_in_usd)
FROM salaries;
-- gaji rata-rata per bulan dalam rupiah dengan asumsi 1 USD = Rp15.000
SELECT (AVG(salary_in_usd)*15000)/12
AS avg_sal_rp_monthly
FROM salaries;

-- 4. Rata-rata gaji berdasarkan experience level
SELECT experience_level,
	(AVG(salary_in_usd)*15000)/12 AS avg_sal_rp_monthly
FROM salaries
GROUP BY experience_level, employment_type
ORDER BY experience_level, employment_type;

-- 5. Negara dengan gaji paling menarik untuk posisi full time entry-level/midlevel data analyst
SELECT company_location,
	AVG(salary_in_usd) avg_sal_in_usd
FROM salaries
WHERE job_title LIKE "%data analyst%"
	AND employment_type = "FT"
	AND experience_level IN ("EN", "MI")
GROUP BY company_location
-- memiliki gaji >=2000
HAVING avg_sal_in_usd >=2000;

-- 6. Tahun kenaikan gaji dari level mid ke senior yang paling tinggi (untuk
-- pekerjaan yang berkaitan dengan data analyst penuh waktu).
WITH s_1 AS (
	SELECT
		work_year,
		AVG(salary_in_usd) sal_in_usd_ex
	FROM
		salaries
	WHERE
		employment_type = 'FT'
		AND experience_level = 'EX'
		AND job_title LIKE '%data analyst%'
	GROUP BY
		work_year
),
s_2 AS (
	SELECT
		work_year,
		AVG(salary_in_usd) sal_in_usd_mi
	FROM
		salaries
	WHERE
		employment_type = 'FT'
		AND experience_level = 'MI'
		AND job_title LIKE '%data analyst%'
	GROUP BY
		work_year
),
t_year AS (
	SELECT
		DISTINCT work_year
	FROM
		salaries
)
SELECT
	t_year.work_year,
	s_1.sal_in_usd_ex,
	s_2.sal_in_usd_mi,
	s_1.sal_in_usd_ex - s_2.sal_in_usd_mi differences
FROM
	t_year
	LEFT JOIN s_1 ON s_1.work_year = t_year.work_year
	LEFT JOIN s_2 ON s_2.work_year = t_year.work_year;
    
-- 7. Trend rata-rata gaji tahunan setiap job_title utama
-- (misalnya hanya 5 besar job_title paling banyak muncul)
WITH top_jobs AS (
    SELECT job_title
    FROM salaries
    GROUP BY job_title
    ORDER BY COUNT(*) DESC
    LIMIT 5
)
SELECT work_year, job_title,
       ROUND(AVG(salary_in_usd),2) AS avg_salary_usd
FROM salaries
WHERE job_title IN (SELECT job_title FROM top_jobs)
GROUP BY work_year, job_title
ORDER BY work_year, avg_salary_usd DESC;

-- 8. Gap gaji antara remote vs onsite/hybrid untuk setiap job_title
SELECT
  job_title,
  ROUND(AVG(CASE WHEN remote_ratio = 100 THEN salary_in_usd END), 2) AS avg_remote,
  ROUND(AVG(CASE WHEN remote_ratio = 50  THEN salary_in_usd END), 2) AS avg_hybrid,
  ROUND(AVG(CASE WHEN remote_ratio = 0   THEN salary_in_usd END), 2) AS avg_onsite,
  ROUND(
    AVG(CASE WHEN remote_ratio = 100 THEN salary_in_usd END)
    - AVG(CASE WHEN remote_ratio IN (0,50) THEN salary_in_usd END)
  , 2) AS gap_remote_vs_nonremote
FROM salaries
GROUP BY job_title
ORDER BY gap_remote_vs_nonremote DESC;

-- 9. Negara dengan pertumbuhan gaji tercepat untuk Data Scientist
WITH yearly_salary AS (
    SELECT company_location, work_year,
           AVG(salary_in_usd) AS avg_salary
    FROM salaries
    WHERE job_title LIKE "%data scientist%"
    GROUP BY company_location, work_year
),
growth AS (
    SELECT company_location,
           MAX(avg_salary) - MIN(avg_salary) AS growth_salary
    FROM yearly_salary
    GROUP BY company_location
)
SELECT company_location, growth_salary
FROM growth
ORDER BY growth_salary DESC
LIMIT 10;

-- 10. Ranking job_title dengan gaji median tertinggi
SELECT 
    job_title,
    COUNT(*) AS n_rows,
    ROUND(
        CASE 
            -- jika jumlah baris ganjil → ambil nilai tengah
            WHEN COUNT(*) % 2 = 1 THEN 
                SUBSTRING_INDEX(
                    SUBSTRING_INDEX( GROUP_CONCAT(salary_in_usd ORDER BY salary_in_usd), ',', (COUNT(*) DIV 2) + 1 ),
                ',', -1)
            -- jika jumlah baris genap → rata-rata dua nilai tengah
            ELSE 
                ( CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(salary_in_usd ORDER BY salary_in_usd), ',', COUNT(*) DIV 2), ',', -1) AS DECIMAL(10,2))
                + CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(salary_in_usd ORDER BY salary_in_usd), ',', (COUNT(*) DIV 2) + 1), ',', -1) AS DECIMAL(10,2))
                ) / 2
        END, 2
    ) AS median_salary
FROM salaries
GROUP BY job_title
HAVING n_rows >= 5   -- filter agar hanya job_title dengan minimal 5 data
ORDER BY median_salary DESC
LIMIT 10;

-- 11. Perbandingan gaji berdasarkan ukuran perusahaan
SELECT company_size,
       ROUND(AVG(salary_in_usd),2) AS avg_salary_usd,
       ROUND(MIN(salary_in_usd),2) AS min_salary_usd,
       ROUND(MAX(salary_in_usd),2) AS max_salary_usd
FROM salaries
GROUP BY company_size
ORDER BY avg_salary_usd DESC;

-- 12. Negara dengan distribusi gaji paling tinggi (gap terbesar antara max dan min salary)
SELECT company_location,
       MAX(salary_in_usd) - MIN(salary_in_usd) AS salary_gap
FROM salaries
GROUP BY company_location
ORDER BY salary_gap DESC
LIMIT 10;

-- 13. Perbandingan gaji rata-rata per negara dan per tahun
SELECT 
    work_year,
    company_location,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary_usd
FROM salaries
GROUP BY work_year, company_location
ORDER BY work_year ASC, avg_salary_usd DESC;

-- 14. Jabatan dengan gaji tertinggi di tiap tahun
SELECT s.work_year, s.job_title, s.avg_salary
FROM (
    SELECT work_year, job_title, 
           AVG(salary_in_usd) AS avg_salary,
           ROW_NUMBER() OVER(PARTITION BY work_year ORDER BY AVG(salary_in_usd) DESC) AS rank_salary
    FROM salaries
    GROUP BY work_year, job_title
) s
WHERE s.rank_salary = 1;

-- 15. Rasio gaji remote vs on-site
SELECT remote_ratio,
       ROUND(AVG(salary_in_usd),2) AS avg_salary_usd,
       COUNT(*) AS total_jobs
FROM salaries
GROUP BY remote_ratio
ORDER BY avg_salary_usd DESC;

-- 16. Negara dengan distribusi pekerjaan remote terbanyak
SELECT company_location,
       COUNT(*) AS total_remote_jobs
FROM salaries
WHERE remote_ratio = 100
GROUP BY company_location
ORDER BY total_remote_jobs DESC
LIMIT 10;

-- 17. Gap gaji antara kontrak (CT) dan full-time (FT) per job_title
SELECT
  job_title,
  COUNT(CASE WHEN employment_type = 'CT' THEN 1 END) AS n_ct,
  COUNT(CASE WHEN employment_type = 'FT' THEN 1 END) AS n_ft,
  ROUND(AVG(CASE WHEN employment_type = 'CT' THEN salary_in_usd END),2) AS avg_ct,
  ROUND(AVG(CASE WHEN employment_type = 'FT' THEN salary_in_usd END),2) AS avg_ft,
  CASE 
    WHEN COUNT(CASE WHEN employment_type = 'CT' THEN 1 END) > 0
     AND COUNT(CASE WHEN employment_type = 'FT' THEN 1 END) > 0
    THEN ROUND(
      AVG(CASE WHEN employment_type = 'CT' THEN salary_in_usd END)
      - AVG(CASE WHEN employment_type = 'FT' THEN salary_in_usd END)
    ,2)
    ELSE NULL
  END AS gap_ct_minus_ft
FROM salaries
GROUP BY job_title
ORDER BY gap_ct_minus_ft DESC;

-- 18. Negara dengan pertumbuhan gaji tercepat
WITH yearly_avg AS (
    SELECT work_year, company_location,
           AVG(salary_in_usd) AS avg_salary
    FROM salaries
    GROUP BY work_year, company_location
),
growth AS (
    SELECT company_location,
           MAX(avg_salary) - MIN(avg_salary) AS salary_growth
    FROM yearly_avg
    GROUP BY company_location
)
SELECT company_location, salary_growth
FROM growth
ORDER BY salary_growth DESC
LIMIT 10;

-- 19. Posisi dengan jumlah karyawan terbanyak di seluruh dataset
SELECT job_title,
       COUNT(*) AS total_employees
FROM salaries
GROUP BY job_title
ORDER BY total_employees DESC
LIMIT 10;

-- 20. Top 5 negara dengan rata-rata gaji tertinggi untuk Data Scientist
SELECT company_location,
       ROUND(AVG(salary_in_usd),2) AS avg_salary
FROM salaries
WHERE job_title = 'Data Scientist'
GROUP BY company_location
ORDER BY avg_salary DESC
LIMIT 5;

-- 21. Gaji maksimum, minimum, dan rata-rata per level pengalaman
SELECT experience_level,
       MIN(salary_in_usd) AS min_salary,
       MAX(salary_in_usd) AS max_salary,
       ROUND(AVG(salary_in_usd),2) AS avg_salary
FROM salaries
GROUP BY experience_level;

-- 22. Tren kenaikan gaji Data Engineer per tahun
SELECT work_year,
       ROUND(AVG(salary_in_usd),2) AS avg_salary
FROM salaries
WHERE job_title = 'Data Engineer'
GROUP BY work_year
ORDER BY work_year;

-- 23. Negara dengan dominasi kontrak kerja (Contract)
SELECT company_location,
       COUNT(*) AS contract_jobs
FROM salaries
WHERE employment_type = 'CT'
GROUP BY company_location
ORDER BY contract_jobs DESC
LIMIT 5;

-- 24. Perbandingan gaji antara perusahaan di US vs Non-US
SELECT 
    CASE WHEN company_location = 'US' THEN 'United States' ELSE 'Non-US' END AS region,
    ROUND(AVG(salary_in_usd),2) AS avg_salary,
    COUNT(*) AS total_jobs
FROM salaries
GROUP BY region;

-- 25. Negara asal karyawan dengan representasi global tertinggi
SELECT employee_residence,
       COUNT(*) AS total_workers
FROM salaries
GROUP BY employee_residence
ORDER BY total_workers DESC
LIMIT 10;

-- 26. Perusahaan remote dengan gaji tertinggi
SELECT company_location,
       job_title,
       ROUND(AVG(salary_in_usd),2) AS avg_salary
FROM salaries
WHERE remote_ratio = 100
GROUP BY company_location, job_title
ORDER BY avg_salary DESC
LIMIT 10;







