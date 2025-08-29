/*
Sebuah perusahaan elektronik menjual berbagai produk seperti laptop, smartphone, tablet, kamera, 
dan aksesoris lainnya. Untuk mendukung operasional bisnis, perusahaan membutuhkan sistem database 
yang dapat mencatat transaksi penjualan, data pelanggan, serta informasi produk yang tersedia.

Untuk itu, dibangunlah database `penjualan` dengan struktur utama:
1. Tabel `customers` untuk menyimpan data pelanggan (nama, email, negara).
2. Tabel `products` untuk menyimpan daftar produk beserta kategori dan harga.
3. Tabel `sales` untuk mencatat transaksi penjualan (tanggal, pelanggan, produk, jumlah, dan total penjualan).

Dengan sistem ini, perusahaan dapat:
- Memantau transaksi penjualan dari hari ke hari.
- Mengidentifikasi pelanggan berdasarkan negara asalnya.
- Mengetahui produk yang paling sering dibeli.
- Menghitung total pendapatan dari setiap pelanggan maupun keseluruhan penjualan.
- Mendukung analisis bisnis untuk pengambilan keputusan yang lebih baik.
*/

-- Membuat database dan untuk tabel diimport dari data eksternal
CREATE DATABASE penjualan;
USE penjualan;

-- Membuat tabel customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

-- Membuat tabel products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2)
);

-- Membuat tabel sales
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    sale_date DATETIME,
    quantity INT,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Insert data ke tabel customers
INSERT INTO customers (customer_id, customer_name, email, country) VALUES
(201, 'John Doe', 'john.doe@example.com', 'USA'),
(202, 'Jane Smith', 'jane.smith@example.com', 'Canada'),
(203, 'Bob Johnson', 'bob.johnson@example.com', 'UK'),
(204, 'Alice Brown', 'alice.brown@example.com', 'Australia');

-- Insert data ke tabel products
INSERT INTO products (product_id, product_name, category_id, price) VALUES
(101, 'Laptop', 1, 600),
(102, 'Smartphone', 2, 50),
(103, 'Headphones', 3, 60),
(104, 'Tablet', 1, 30),
(105, 'Camera', 4, 50);

-- Insert data ke tabel sales
INSERT INTO sales (sale_id, product_id, customer_id, sale_date, quantity, total_amount) VALUES
(1, 101, 201, STR_TO_DATE('2/25/24 08:00','%m/%d/%y %H:%i'), 2, 120),
(2, 102, 202, STR_TO_DATE('2/25/24 09:30','%m/%d/%y %H:%i'), 1, 50),
(3, 103, 201, STR_TO_DATE('2/26/24 10:15','%m/%d/%y %H:%i'), 3, 180),
(4, 104, 203, STR_TO_DATE('2/26/24 12:45','%m/%d/%y %H:%i'), 1, 30),
(5, 105, 202, STR_TO_DATE('2/27/24 14:20','%m/%d/%y %H:%i'), 2, 100);

-- Memeriksa tabel
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM sales;

-- 1. Menghitung total pendapatan perusahaan
SELECT SUM(total_amount) AS total_pendapatan
FROM sales;

-- 2. Menampilkan pelanggan yang paling sering melakukan pembelian
SELECT 
    c.customer_name,
    COUNT(s.sale_id) AS jumlah_transaksi
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY jumlah_transaksi DESC
LIMIT 1;

-- 3. Menampilkan produk yang paling laku
SELECT 
    p.product_name,
    SUM(s.quantity) AS total_terjual
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_terjual DESC
LIMIT 1;

-- 4. Menampilkan total penjualan per kategori produk
SELECT 
    category_id,
    SUM(total_amount) AS total_penjualan
FROM sales
JOIN products ON sales.product_id = products.product_id
GROUP BY category_id;

-- 5. Menampilkan transaksi pada tanggal tertentu (misalnya 2024-02-25)
SELECT 
    s.sale_id,
    c.customer_name,
    p.product_name,
    s.quantity,
    s.total_amount
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id
WHERE DATE(s.sale_date) = '2024-02-25';

-- 6. Tampilkan semua pelanggan beserta email dan negara asalnya
SELECT customer_name, email, country
FROM customers;

-- 7. Tampilkan daftar produk yang dijual beserta harganya
SELECT product_name, price
FROM products;

-- 8. Tampilkan semua transaksi penjualan dengan detail nama pelanggan dan produk yang dibeli
SELECT 
    s.sale_id,
    c.customer_name,
    p.product_name,
    s.sale_date,
    s.quantity,
    s.total_amount
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id;

-- 9. Cari produk yang paling laris (paling banyak dibeli dari segi jumlah)
SELECT 
    p.product_name,
    SUM(s.quantity) AS total_terjual
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_terjual DESC
LIMIT 1;

-- 10. Hitung rata-rata jumlah unit yang dibeli per transaksi
SELECT AVG(quantity) AS rata_rata_jumlah
FROM sales;

-- 11. Tampilkan semua transaksi yang dilakukan oleh pelanggan asal "Canada"
SELECT 
    s.sale_id,
    c.customer_name,
    p.product_name,
    s.quantity,
    s.total_amount
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id
WHERE c.country = 'Canada';

-- 12. Tampilkan total penjualan per kategori produk
SELECT 
    p.category_id,
    SUM(s.total_amount) AS total_penjualan
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category_id;

-- 13. Cari pelanggan yang menghasilkan total belanja terbesar
SELECT 
    c.customer_name,
    SUM(s.total_amount) AS total_belanja
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_belanja DESC
LIMIT 1;

-- 14. Produk dengan kuantitas penjualan lebih besar dari rata-rata
SELECT 
    p.product_name,
    SUM(s.quantity) AS total_quantity
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(s.quantity) > (
    SELECT AVG(total_quantity) 
    FROM (
        SELECT SUM(quantity) AS total_quantity
        FROM sales
        GROUP BY product_id
    ) AS sub
);

-- 15. Customer dengan total amount terbanyak di setiap kota (menggunakan RANK())
SELECT 
    c.country,
    c.customer_name,
    SUM(s.total_amount) AS total_amount,
    RANK() OVER (PARTITION BY c.country ORDER BY SUM(s.total_amount) DESC) AS ranking
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.country, c.customer_name;

-- 16. Kategori customer (Low, Medium, High) berdasarkan total quantity & amount
SELECT 
    c.customer_name,
    SUM(s.quantity) AS total_quantity,
    SUM(s.total_amount) AS total_amount,
    CASE 
        WHEN SUM(s.quantity) BETWEEN 1 AND 2 AND SUM(s.total_amount) <= 100 
            THEN 'Low'
        WHEN SUM(s.quantity) BETWEEN 3 AND 5 AND SUM(s.total_amount) BETWEEN 101 AND 300 
            THEN 'Medium'
        WHEN SUM(s.quantity) > 5 AND SUM(s.total_amount) > 300 
            THEN 'High'
        ELSE 'Uncategorized'
    END AS customer_category
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name;

-- 17. Kontribusi penjualan tiap produk terhadap keseluruhan penjualan
SELECT 
    p.product_name,
    SUM(s.quantity) AS total_quantity,
    SUM(s.total_amount) AS total_amount,
    ROUND(SUM(s.quantity) * 100.0 / SUM(SUM(s.quantity)) OVER (), 2) AS kontribusi_quantity_pct,
    ROUND(SUM(s.total_amount) * 100.0 / SUM(SUM(s.total_amount)) OVER (), 2) AS kontribusi_amount_pct
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name;
 






