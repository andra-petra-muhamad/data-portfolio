/* 
Teman Anda, Rangga, sedang mengelola sebuah perusahaan bimbingan
belajar untuk SMA / SMK di Sumedang. Awalnya, Rangga menuliskan setiap
data di buku catatannya. Namun, Rangga merasa kesulitan ketika harus
mencari data yang ia inginkan dan mengolah data-data tersebut.
Rangga bercerita masalah tersebut kepada Anda dan Anda menawarkan
solusi untuk membuat database menggunakan MySQL untuk menyelesaikan
masalah yang Rangga hadapi.
*/

/* Pembuatan Database & Tabel */
-- Membuat database
CREATE DATABASE bimbel;

-- Membuat tabel siswa
CREATE TABLE bimbel.siswa (
    id_siswa VARCHAR(255) NOT NULL,
    nama_siswa VARCHAR(255) NOT NULL,
    alamat_siswa VARCHAR(255) NULL,
    tanggal_lahir_siswa DATE NULL,
    kelas_siswa VARCHAR(255) NOT NULL,
    sekolah_siswa VARCHAR(255) NULL
);

/* Insert Data Siswa */
INSERT INTO bimbel.siswa (
    id_siswa,
    nama_siswa,
    alamat_siswa,
    tanggal_lahir_siswa,
    kelas_siswa,
    sekolah_siswa
)
VALUES 
    ('A000000001', 'Rizka', 'Jalan Pegangsaan No. 800 Jakarta', '2004-10-10', '12', 'SMA Nurul Hidayah'),
    ('A000000002', 'Nandang', 'Jalan Nasional No. 900 Penajam Paser Utara, Kalimantan Timur', NULL, '11', 'SMA Nasional Indonesia Raya'),
    ('A000000003', 'Ayu', 'Jl. Raya Bandung No. 45', '2005-01-15', '11', 'SMK Negeri 1 Bandung'),
    ('A000000004', 'Doni', 'Jl. Merdeka No. 12 Sumedang', '2003-07-21', '12', 'SMA Negeri 2 Sumedang'),
    ('A000000005', 'Sinta', 'Jl. Cihampelas No. 22 Bandung', '2004-03-11', '10', 'SMA Bina Bangsa Bandung')
    ;
    
/* Pertanyaan & Jawaban */
-- 1. Tampilkan semua data siswa yang sudah terdaftar.
SELECT * FROM bimbel.siswa;

-- 2. Hitung berapa jumlah siswa yang sudah terdaftar di bimbel.
SELECT COUNT(*) AS jumlah_siswa
FROM bimbel.siswa;

-- 3. Tampilkan siswa yang berasal dari Sumedang.
SELECT nama_siswa, alamat_siswa
FROM bimbel.siswa
WHERE alamat_siswa LIKE '%Sumedang%';

-- 4. Tampilkan semua siswa yang duduk di kelas 12.
SELECT nama_siswa, sekolah_siswa
FROM bimbel.siswa
WHERE kelas_siswa = '12';

-- 5. Urutkan siswa berdasarkan tanggal lahir (dari yang paling tua ke muda).
SELECT nama_siswa, tanggal_lahir_siswa
FROM bimbel.siswa
ORDER BY tanggal_lahir_siswa ASC;

-- karena ada nilai null, maka query bisa diganti
SELECT nama_siswa, tanggal_lahir_siswa
FROM bimbel.siswa
WHERE tanggal_lahir_siswa IS NOT NULL
ORDER BY tanggal_lahir_siswa ASC;

-- 6. Cari 2 siswa pertama yang didaftarkan ke dalam database (berdasarkan id_siswa).
SELECT id_siswa, nama_siswa
FROM bimbel.siswa
ORDER BY id_siswa ASC
LIMIT 2;


