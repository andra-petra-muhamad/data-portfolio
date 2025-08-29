/*
Pemerintah Provinsi Jawa Barat sedang berfokus pada pengembangan 
Usaha Mikro, Kecil, dan Menengah (UMKM) sebagai salah satu penggerak utama 
perekonomian daerah. Data UMKM dihimpun dari berbagai kabupaten/kota, 
dengan kategori usaha yang beragam seperti batik, bordir, craft, fashion, 
dan lain-lain. Setiap catatan juga memuat jumlah UMKM berdasarkan kategori, 
satuan usaha, serta tahun pencatatan.

Untuk mendukung analisis dan pengambilan kebijakan, 
dibangunlah database `db_umkm_jabar` dengan struktur utama:
Tabel `umkm_jabar` menyimpan informasi identitas wilayah 
(kode provinsi, nama provinsi, kode kabupaten/kota, nama kabupaten/kota), 
kategori usaha, jumlah UMKM, satuan usaha, serta tahun.

Dengan sistem ini, pemerintah dapat:
- Menganalisis perkembangan jumlah UMKM dari tahun ke tahun.
- Membandingkan distribusi UMKM berdasarkan kategori usaha.
- Mengetahui kabupaten/kota dengan jumlah UMKM terbanyak atau terendah.
- Mengevaluasi kontribusi UMKM terhadap perekonomian daerah.
- Mendukung penyusunan program pembinaan, pelatihan, dan bantuan modal UMKM.
*/


-- Membuat database dan untuk tabel diimport dari data eksternal
CREATE DATABASE ds_umkm_jabar;
USE umkm_jabar;

-- Memeriksa data dan mengubah tipe data
SELECT * FROM umkm_jabar;
ALTER TABLE umkm_jabar 
MODIFY COLUMN tahun YEAR;

/* Pertanyaan dan Jawaban */
-- 1. Berapa jumlah baris pada tabel umkm_jabar?
SELECT COUNT(*) AS jumlah_baris
FROM umkm_jabar;

-- 2. Berapa jumlah UMKM di Kabupaten Bekasi pada tahun 2017?
SELECT SUM(jumlah_umkm) AS jumlah_umkm_kab_bekasi_2017
FROM umkm_jabar
WHERE nama_kabupaten_kota = "KABUPATEN BEKASI"
AND tahun = 2017;

-- 3. Bagaimana tren jumlah UMKM di Kabupaten Karawang dari dari tahun 2017 s.d. 2021?
SELECT tahun, SUM(jumlah_umkm) AS jumlah_umkm_bekasi
FROM umkm_jabar
WHERE nama_kabupaten_kota = "KABUPATEN KARAWANG"
AND tahun BETWEEN 2017
AND 2021
GROUP BY tahun
ORDER BY tahun ASC;

-- 4. Berapa jumlah rata-rata UMKM setiap kategori usaha di setiap kabupaten/kota di jawa barat dari tahun ke tahun?
-- 4. Berapa jumlah rata-rata UMKM setiap kategori usaha per kab/kota di jawa barat dari tahun ke tahun?
SELECT tahun, kategori_usaha,
    AVG(jumlah_umkm) AS rerata_jumlah_umkm_per_kab_kota
FROM umkm_jabar
GROUP BY tahun, kategori_usaha
ORDER BY kategori_usaha, tahun ASC;

-- 5. Kategori usaha dengan jumlah_umkm terbanyak dan tersedikit di Kabupaten Sukabumi pada tahun 2021?

-- Jawaban versi 1 untuk paling banyak
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

-- Jawaban versi 1 untuk paling sedikit
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
    
-- Jawaban versi 2
SELECT *
FROM umkm_jabar
WHERE nama_kabupaten_kota = "KABUPATEN SUKABUMI"
AND tahun = 2021
ORDER BY jumlah_umkm DESC;

-- 6. Kabupaten kota dengan jumlah UMKM kurang dari 100.000 pada tahun 2020
SELECT nama_kabupaten_kota,
	SUM(jumlah_umkm) AS jumlah_umkm
FROM umkm_jabar
WHERE tahun = 2020
GROUP BY nama_kabupaten_kota
HAVING jumlah_umkm < 100000;

-- 7. Kabupaten/kota mana yang memiliki jumlah UMKM terbanyak di Jawa Barat pada tahun 2019?
SELECT nama_kabupaten_kota, SUM(jumlah_umkm) AS total_umkm
FROM umkm_jabar
WHERE tahun = 2019
GROUP BY nama_kabupaten_kota
ORDER BY total_umkm DESC
LIMIT 1;

-- 8. Bagaimana distribusi jumlah UMKM berdasarkan kategori usaha di seluruh Jawa Barat pada tahun 2020?
SELECT kategori_usaha, SUM(jumlah_umkm) AS total_umkm
FROM umkm_jabar
WHERE tahun = 2020
GROUP BY kategori_usaha
ORDER BY total_umkm DESC;

-- 9. Kabupaten/kota dengan pertumbuhan UMKM tertinggi dari tahun 2017 ke 2021
SELECT nama_kabupaten_kota,
       (SUM(CASE WHEN tahun = 2021 THEN jumlah_umkm END) -
        SUM(CASE WHEN tahun = 2017 THEN jumlah_umkm END)) AS pertumbuhan_umkm
FROM umkm_jabar
GROUP BY nama_kabupaten_kota
ORDER BY pertumbuhan_umkm DESC
LIMIT 1;

-- 10. Rata-rata jumlah UMKM di setiap kabupaten/kota selama periode 2017-2021
SELECT nama_kabupaten_kota,
       AVG(jumlah_umkm) AS rata_rata_umkm
FROM umkm_jabar
WHERE tahun BETWEEN 2017 AND 2021
GROUP BY nama_kabupaten_kota
ORDER BY rata_rata_umkm DESC;

-- 11. Kategori usaha yang konsisten tumbuh setiap tahun di Kabupaten Bandung
SELECT kategori_usaha, tahun, SUM(jumlah_umkm) AS total_umkm
FROM umkm_jabar
WHERE nama_kabupaten_kota = "KABUPATEN BANDUNG"
GROUP BY kategori_usaha, tahun
ORDER BY kategori_usaha, tahun ASC;

-- 12. Kabupaten/kota dengan jumlah UMKM kategori "BATIK" terbanyak di tahun 2021
SELECT nama_kabupaten_kota, SUM(jumlah_umkm) AS total_umkm_batik
FROM umkm_jabar
WHERE kategori_usaha = "BATIK"
  AND tahun = 2021
GROUP BY nama_kabupaten_kota
ORDER BY total_umkm_batik DESC
LIMIT 1;

-- 13. Tahun berapa jumlah UMKM Jawa Barat mencapai titik tertinggi?
SELECT tahun, SUM(jumlah_umkm) AS total_umkm
FROM umkm_jabar
GROUP BY tahun
ORDER BY total_umkm DESC
LIMIT 1;

-- 14. Top 3 kategori usaha dengan pertumbuhan terbesar di Kabupaten Bogor antara 2017-2021
SELECT kategori_usaha,
       (SUM(CASE WHEN tahun = 2021 THEN jumlah_umkm END) -
        SUM(CASE WHEN tahun = 2017 THEN jumlah_umkm END)) AS pertumbuhan_umkm
FROM umkm_jabar
WHERE nama_kabupaten_kota = "KABUPATEN BOGOR"
GROUP BY kategori_usaha
ORDER BY pertumbuhan_umkm DESC
LIMIT 3;

-- 15. Total UMKM seluruh Jawa Barat per tahun (2017-2021)
SELECT tahun, SUM(jumlah_umkm) AS total_umkm
FROM umkm_jabar
GROUP BY tahun
ORDER BY tahun ASC;

-- 16. Total UMKM Jawa Barat pada tahun tertentu
DROP PROCEDURE IF EXISTS sp_total_umkm_by_year;
DELIMITER $$
CREATE PROCEDURE sp_total_umkm_by_year(IN p_tahun INT)
BEGIN
    SELECT p_tahun AS tahun, SUM(jumlah_umkm) AS total_umkm
    FROM umkm_jabar
    WHERE tahun = p_tahun;
END $$
DELIMITER ;

-- CALL
CALL sp_total_umkm_by_year(2020);

-- 17. Total UMKM per kabupaten/kota pada tahun tertentu
DROP PROCEDURE IF EXISTS sp_umkm_by_region_year;
DELIMITER $$
CREATE PROCEDURE sp_umkm_by_region_year(IN p_tahun INT)
BEGIN
    SELECT nama_kabupaten_kota,
           SUM(jumlah_umkm) AS total_umkm
    FROM umkm_jabar
    WHERE tahun = p_tahun
    GROUP BY nama_kabupaten_kota
    ORDER BY total_umkm DESC;
END $$
DELIMITER ;

-- CALL
CALL sp_umkm_by_region_year(2017);

-- 18. Total UMKM per kategori usaha pada tahun tertentu
DROP PROCEDURE IF EXISTS sp_umkm_by_category_year;
DELIMITER $$
CREATE PROCEDURE sp_umkm_by_category_year(IN p_tahun INT)
BEGIN
    SELECT kategori_usaha,
           SUM(jumlah_umkm) AS total_umkm
    FROM umkm_jabar
    WHERE tahun = p_tahun
    GROUP BY kategori_usaha
    ORDER BY total_umkm DESC;
END $$
DELIMITER ;

-- CALL
CALL sp_umkm_by_category_year(2017);

-- 19. Top kabupaten/kota dengan UMKM terbanyak pada tahun tertentu
DROP PROCEDURE IF EXISTS sp_top_region_by_year;
DELIMITER $$
CREATE PROCEDURE sp_top_region_by_year(IN p_tahun INT, IN p_limit INT)
BEGIN
    SELECT nama_kabupaten_kota,
           SUM(jumlah_umkm) AS total_umkm
    FROM umkm_jabar
    WHERE tahun = p_tahun
    GROUP BY nama_kabupaten_kota
    ORDER BY total_umkm DESC
    LIMIT p_limit;
END $$
DELIMITER ;

-- CALL
CALL sp_top_region_by_year(2017, 5);