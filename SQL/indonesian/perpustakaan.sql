/*
Sebuah perpustakaan membutuhkan sistem sederhana untuk mencatat data buku dan data peminjaman. 
Sistem ini harus mampu:
1. Menyimpan daftar buku yang dimiliki.
2. Mencatat siapa saja yang meminjam buku, berapa jumlahnya, serta tanggal pinjam dan kembali.
3. Menjaga konsistensi data, misalnya hanya buku yang tersedia dalam katalog yang bisa dipinjam.
Untuk itu, dibuatlah dua tabel utama yaitu buku dan peminjaman. Hubungan antar tabel diatur dengan 
foreign key agar data tetap terjaga konsistensinya
*/

/* Membuat Database dan Tabel Buku */
-- Membuat database
CREATE DATABASE perpustakaan;

-- Membuat tabel buku
CREATE TABLE perpustakaan.buku (
    id_buku VARCHAR (255) NOT NULL PRIMARY KEY,
    judul_buku VARCHAR (255) NOT NULL,
    nama_penulis VARCHAR (255) NULL,
    jumlah INTEGER NULL
);

-- Memeriksa apakah tabel sudah terbentuk
SELECT * FROM perpustakaan.buku;

/* Menambahkan Kolom Lokasi pada Tabel Buku */
ALTER TABLE perpustakaan.buku
ADD lokasi VARCHAR (255);

-- Mengecek hasil perubahan
SELECT * FROM perpustakaan.buku;

/* Membuat Tabel Peminjaman */
CREATE TABLE perpustakaan.peminjaman (
    no_peminjaman VARCHAR (255) NOT NULL PRIMARY KEY,
    nama_peminjam VARCHAR (255) NOT NULL,
    id_buku VARCHAR (255) NOT NULL,
    jumlah_buku INTEGER NOT NULL,
    tgl_pinjam DATE NOT NULL,
    tgl_ekspektasi_kembali DATE NULL,
    tgl_aktual_kembali DATE NULL,
    FOREIGN KEY (id_buku) REFERENCES perpustakaan.buku(id_buku)
);

-- Memeriksa apakah tabel sudah terbentuk
SELECT * FROM perpustakaan.peminjaman;

-- Memeriksa Struktur Tabel
EXPLAIN perpustakaan.peminjaman;

-- Insert Data ke Tabel Buku
INSERT INTO perpustakaan.buku (id_buku, judul_buku, nama_penulis, jumlah, lokasi)
VALUES
    ('B001', 'Laskar Pelangi', 'Andrea Hirata', 5, 'Rak A1'),
    ('B002', 'Bumi Manusia', 'Pramoedya Ananta Toer', 3, 'Rak A2'),
    ('B003', 'Filosofi Kopi', 'Dewi Lestari', 4, 'Rak A3'),
    ('B004', 'Negeri 5 Menara', 'Ahmad Fuadi', 2, 'Rak A1'),
    ('B005', 'Sang Pemimpi', 'Andrea Hirata', 6, 'Rak A2')
    ;

-- Insert Data ke Tabel Peminjaman
INSERT INTO perpustakaan.peminjaman 
(no_peminjaman, nama_peminjam, id_buku, jumlah_buku, tgl_pinjam, tgl_ekspektasi_kembali, tgl_aktual_kembali)
VALUES
    ('P001', 'Rizka', 'B001', 1, '2023-01-10', '2023-01-17', '2023-01-16'),
    ('P002', 'Nandang', 'B002', 1, '2023-02-01', '2023-02-08', NULL),
    ('P003', 'Siti', 'B003', 2, '2023-02-15', '2023-02-22', '2023-02-20'),
    ('P004', 'Budi', 'B001', 1, '2023-03-05', '2023-03-12', NULL),
    ('P005', 'Adi', 'B005', 1, '2023-04-01', '2023-04-08', '2023-04-07')
    ;

/* Pertanyaan & Jawaban */
-- 1. Tampilkan semua data buku yang tersedia di perpustakaan
SELECT * FROM perpustakaan.buku;

-- 2. Tampilkan daftar peminjaman yang belum mengembalikan buku
SELECT no_peminjaman, nama_peminjam, id_buku, tgl_pinjam, tgl_ekspektasi_kembali
FROM perpustakaan.peminjaman
WHERE tgl_aktual_kembali IS NULL;

-- 3. Siapa saja yang pernah meminjam buku Laskar Pelangi?
SELECT p.nama_peminjam, b.judul_buku
FROM perpustakaan.peminjaman p
JOIN perpustakaan.buku b ON p.id_buku = b.id_buku
WHERE b.judul_buku = 'Laskar Pelangi';

-- 4. Tampilkan jumlah stok buku setiap penulis
SELECT nama_penulis, SUM(jumlah) AS total_stok
FROM perpustakaan.buku
GROUP BY nama_penulis;

-- 5. Tampilkan peminjam yang telat mengembalikan buku (tgl_aktual_kembali > tgl_ekspektasi_kembali)
SELECT nama_peminjam, id_buku, tgl_ekspektasi_kembali, tgl_aktual_kembali
FROM perpustakaan.peminjaman
WHERE tgl_aktual_kembali > tgl_ekspektasi_kembali;

-- 6. Buku apa yang paling sering dipinjam?
SELECT b.judul_buku, COUNT(*) AS jumlah_dipinjam
FROM perpustakaan.peminjaman p
JOIN perpustakaan.buku b ON p.id_buku = b.id_buku
GROUP BY b.judul_buku
ORDER BY jumlah_dipinjam DESC
LIMIT 1;

-- Memeriksa semua data peminjaman
SELECT * FROM perpustakaan.peminjaman;












