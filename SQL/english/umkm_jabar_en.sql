/*
The Provincial Government of West Java is focusing on the development of 
Micro, Small, and Medium Enterprises (MSMEs) as one of the main drivers 
of the regional economy. MSME data is collected from various districts/cities, 
with diverse business categories such as batik, embroidery, crafts, fashion, 
and others. Each record also contains the number of MSMEs by category, 
business unit, and year of recording.

To support analysis and policymaking, 
a database `db_umkm_jabar` is built with the main structure:
Table `umkm_jabar` stores information on region identity 
(province code, province name, district/city code, district/city name), 
business category, number of MSMEs, business unit, and year.

With this system, the government can:
- Analyze MSME growth from year to year.
- Compare MSME distribution by business category.
- Identify districts/cities with the highest or lowest number of MSMEs.
- Evaluate the contribution of MSMEs to the regional economy.
- Support the design of training, mentoring, and funding programs for MSMEs.
*/

-- Create database (data for table is imported from external sources)
CREATE DATABASE db_umkm_jabar;
USE db_umkm_jabar;

-- Check data and modify data type
SELECT * FROM umkm_jabar;
ALTER TABLE umkm_jabar 
MODIFY COLUMN tahun YEAR;

/* Questions and Answers */
-- 1. How many rows are there in the umkm_jabar table?
SELECT COUNT(*) AS total_rows
FROM umkm_jabar;

-- 2. How many MSMEs were in Bekasi District in 2017?
SELECT SUM(jumlah_umkm) AS total_umkm_bekasi_2017
FROM umkm_jabar
WHERE nama_kabupaten_kota = "KABUPATEN BEKASI"
AND tahun = 2017;

-- 3. What is the trend of MSMEs in Karawang District from 2017 to 2021?
SELECT tahun, SUM(jumlah_umkm) AS total_umkm_karawang
FROM umkm_jabar
WHERE nama_kabupaten_kota = "KABUPATEN KARAWANG"
AND tahun BETWEEN 2017 AND 2021
GROUP BY tahun
ORDER BY tahun ASC;

-- 4. What is the average number of MSMEs for each business category per district/city in West Java year by year?
SELECT tahun, kategori_usaha,
    AVG(jumlah_umkm) AS avg_umkm_per_region
FROM umkm_jabar
GROUP BY tahun, kategori_usaha
ORDER BY kategori_usaha, tahun ASC;

-- 5. Business category with the highest and lowest number of MSMEs in Sukabumi District in 2021?

-- Version 1: Highest
SELECT kategori_usaha, jumlah_umkm
FROM umkm_jabar
WHERE nama_kabupaten_kota = "KABUPATEN SUKABUMI"
AND tahun = 2021
AND jumlah_umkm = (
        SELECT MAX(jumlah_umkm)
        FROM umkm_jabar
        WHERE nama_kabupaten_kota = "KABUPATEN SUKABUMI"
		AND tahun = 2021
    );

-- Version 1: Lowest
SELECT kategori_usaha, jumlah_umkm
FROM umkm_jabar
WHERE nama_kabupaten_kota = "KABUPATEN SUKABUMI"
AND tahun = 2021
AND jumlah_umkm = (
        SELECT MIN(jumlah_umkm)
        FROM umkm_jabar
        WHERE nama_kabupaten_kota = "KABUPATEN SUKABUMI"
		AND tahun = 2021
    );

-- Version 2
SELECT *
FROM umkm_jabar
WHERE nama_kabupaten_kota = "KABUPATEN SUKABUMI"
AND tahun = 2021
ORDER BY jumlah_umkm DESC;

-- 6. Districts/cities with less than 100,000 MSMEs in 2020
SELECT nama_kabupaten_kota,
	SUM(jumlah_umkm) AS total_umkm
FROM umkm_jabar
WHERE tahun = 2020
GROUP BY nama_kabupaten_kota
HAVING total_umkm < 100000;

-- 7. Which district/city had the most MSMEs in West Java in 2019?
SELECT nama_kabupaten_kota, SUM(jumlah_umkm) AS total_umkm
FROM umkm_jabar
WHERE tahun = 2019
GROUP BY nama_kabupaten_kota
ORDER BY total_umkm DESC
LIMIT 1;

-- 8. How is the distribution of MSMEs by business category across West Java in 2020?
SELECT kategori_usaha, SUM(jumlah_umkm) AS total_umkm
FROM umkm_jabar
WHERE tahun = 2020
GROUP BY kategori_usaha
ORDER BY total_umkm DESC;

-- 9. District/city with the highest MSME growth from 2017 to 2021
SELECT nama_kabupaten_kota,
       (SUM(CASE WHEN tahun = 2021 THEN jumlah_umkm END) -
        SUM(CASE WHEN tahun = 2017 THEN jumlah_umkm END)) AS umkm_growth
FROM umkm_jabar
GROUP BY nama_kabupaten_kota
ORDER BY umkm_growth DESC
LIMIT 1;

-- 10. Average number of MSMEs in each district/city during 2017-2021
SELECT nama_kabupaten_kota,
       AVG(jumlah_umkm) AS avg_umkm
FROM umkm_jabar
WHERE tahun BETWEEN 2017 AND 2021
GROUP BY nama_kabupaten_kota
ORDER BY avg_umkm DESC;

-- 11. Business categories that consistently grew every year in Bandung District
SELECT kategori_usaha, tahun, SUM(jumlah_umkm) AS total_umkm
FROM umkm_jabar
WHERE nama_kabupaten_kota = "KABUPATEN BANDUNG"
GROUP BY kategori_usaha, tahun
ORDER BY kategori_usaha, tahun ASC;

-- 12. District/city with the most "BATIK" MSMEs in 2021
SELECT nama_kabupaten_kota, SUM(jumlah_umkm) AS total_umkm_batik
FROM umkm_jabar
WHERE kategori_usaha = "BATIK"
  AND tahun = 2021
GROUP BY nama_kabupaten_kota
ORDER BY total_umkm_batik DESC
LIMIT 1;

-- 13. In which year did West Java have the highest number of MSMEs?
SELECT tahun, SUM(jumlah_umkm) AS total_umkm
FROM umkm_jabar
GROUP BY tahun
ORDER BY total_umkm DESC
LIMIT 1;

-- 14. Top 3 business categories with the highest growth in Bogor District between 2017-2021
SELECT kategori_usaha,
       (SUM(CASE WHEN tahun = 2021 THEN jumlah_umkm END) -
        SUM(CASE WHEN tahun = 2017 THEN jumlah_umkm END)) AS umkm_growth
FROM umkm_jabar
WHERE nama_kabupaten_kota = "KABUPATEN BOGOR"
GROUP BY kategori_usaha
ORDER BY umkm_growth DESC
LIMIT 3;

-- 15. Total MSMEs across West Java per year (2017-2021)
SELECT tahun, SUM(jumlah_umkm) AS total_umkm
FROM umkm_jabar
GROUP BY tahun
ORDER BY tahun ASC;

-- 16. Total MSMEs in West Java for a specific year
DROP PROCEDURE IF EXISTS sp_total_umkm_by_year;
DELIMITER $$
CREATE PROCEDURE sp_total_umkm_by_year(IN p_year INT)
BEGIN
    SELECT p_year AS year, SUM(jumlah_umkm) AS total_umkm
    FROM umkm_jabar
    WHERE tahun = p_year;
END $$
DELIMITER ;

-- CALL
CALL sp_total_umkm_by_year(2020);

-- 17. Total MSMEs per district/city in a specific year
DROP PROCEDURE IF EXISTS sp_umkm_by_region_year;
DELIMITER $$
CREATE PROCEDURE sp_umkm_by_region_year(IN p_year INT)
BEGIN
    SELECT nama_kabupaten_kota,
           SUM(jumlah_umkm) AS total_umkm
    FROM umkm_jabar
    WHERE tahun = p_year
    GROUP BY nama_kabupaten_kota
    ORDER BY total_umkm DESC;
END $$
DELIMITER ;

-- CALL
CALL sp_umkm_by_region_year(2017);

-- 18. Total MSMEs per business category in a specific year
DROP PROCEDURE IF EXISTS sp_umkm_by_category_year;
DELIMITER $$
CREATE PROCEDURE sp_umkm_by_category_year(IN p_year INT)
BEGIN
    SELECT kategori_usaha,
           SUM(jumlah_umkm) AS total_umkm
    FROM umkm_jabar
    WHERE tahun = p_year
    GROUP BY kategori_usaha
    ORDER BY total_umkm DESC;
END $$
DELIMITER ;

-- CALL
CALL sp_umkm_by_category_year(2017);

-- 19. Top districts/cities with the most MSMEs in a specific year
DROP PROCEDURE IF EXISTS sp_top_region_by_year;
DELIMITER $$
CREATE PROCEDURE sp_top_region_by_year(IN p_year INT, IN p_limit INT)
BEGIN
    SELECT nama_kabupaten_kota,
           SUM(jumlah_umkm) AS total_umkm
    FROM umkm_jabar
    WHERE tahun = p_year
    GROUP BY nama_kabupaten_kota
    ORDER BY total_umkm DESC
    LIMIT p_limit;
END $$
DELIMITER ;

-- CALL
CALL sp_top_region_by_year(2017, 5);
