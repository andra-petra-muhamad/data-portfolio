/*
Sebuah perusahaan elektronik sedang berkembang pesat dalam menjual berbagai produk 
seperti laptop, smartphone, tablet, kamera, dan aksesoris lainnya. 
Perusahaan ini membutuhkan sistem database untuk mencatat transaksi penjualan, data pelanggan, 
serta rincian pesanan agar operasional bisnis menjadi lebih efisien.

Untuk itu, dibangunlah database `perusahaan_elektronik` dengan struktur utama:
1. Tabel `customers` untuk menyimpan data pelanggan (nama, email).
2. Tabel `orders` untuk menyimpan data pesanan (tanggal, pelanggan yang memesan).
3. Tabel `order_items` untuk menyimpan detail item yang dipesan dalam setiap order.
4. Tabel `product` untuk menyimpan daftar produk beserta harga dan kategori.

Dengan sistem ini, perusahaan dapat:
- Memantau transaksi harian.
- Melihat pelanggan yang paling sering melakukan pembelian.
- Mengetahui produk mana yang paling laku.
- Menghitung total pendapatan dari penjualan.
*/

-- Membuat database dan untuk tabel, diimport dari data eksternal
CREATE DATABASE perusahaan_elektronik;
USE perusahaan_elektronik;

-- 1. Siapa saja pelanggan yang pernah melakukan pesanan?
SELECT DISTINCT c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

-- 2. Produk apa saja yang pernah dipesan dalam order tertentu (misalnya order_id = 101)?
SELECT p.product_name, i.quantity
FROM items i
JOIN product p ON i.product_id = p.product_id
WHERE i.order_id = 101;

-- 3. Berapa total belanja tiap pelanggan?
SELECT c.customer_name, SUM(p.price * i.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN items i ON o.order_id = i.order_id
JOIN product p ON i.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- 4. Produk apa yang paling sering dibeli?
SELECT p.product_name, SUM(i.quantity) AS total_sold
FROM items i
JOIN product p ON i.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 1;

-- 5. Berapa total pendapatan perusahaan?
SELECT SUM(p.price * i.quantity) AS total_revenue
FROM items i
JOIN product p ON i.product_id = p.product_id;

-- 6. Buatlah query dengan menggunakan subquery untuk mencari customer yang
-- melakukan pembelian pertama pada tanggal 25-27 Februari 2024
SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE order_date
          BETWEEN '2024-02-25' AND '2024-02-27'
);

-- 7. Buatlah subquery untuk menampilkan order_id yang memiliki lebih dari 1 jenis produk.
SELECT order_id
FROM items
GROUP BY order_id
HAVING COUNT(DISTINCT product_id) > 1;

-- opsi 2
SELECT i.order_id, p.product_name, i.quantity
FROM items i
JOIN product p ON i.product_id = p.product_id
WHERE i.order_id IN (
    SELECT order_id
    FROM items
    GROUP BY order_id
    HAVING COUNT(DISTINCT product_id) > 1
)
ORDER BY i.order_id, p.product_name;


-- 8. Buatlah subquery untuk menampilkan customer dengan total pembelanjaan (total
-- price) paling banyak
SELECT customer_name
FROM customers
WHERE customer_id = (
    SELECT o.customer_id
    FROM orders o
    JOIN items i ON o.order_id = i.order_id
    JOIN product p ON i.product_id = p.product_id
    GROUP BY o.customer_id
    ORDER BY SUM(p.price * i.quantity) DESC
    LIMIT 1
);

-- opsi 2
SELECT c.customer_name, t.total_belanja
FROM customers c
JOIN (
    SELECT o.customer_id, SUM(p.price * i.quantity) AS total_belanja
    FROM orders o
    JOIN items i ON o.order_id = i.order_id
    JOIN product p ON i.product_id = p.product_id
    GROUP BY o.customer_id
    ORDER BY total_belanja DESC
    LIMIT 1
) t ON c.customer_id = t.customer_id;

-- 9. Buatlah subquery untuk menampilkan jenis produk yang memiliki harga 2x lipat lebih
-- tinggi dari harga Smartphone.
SELECT product_name
FROM product
WHERE price = (
    SELECT price * 2
    FROM product
    WHERE product_name = 'Smartphone'
);

-- opsi 2
SELECT product_name, price
FROM product
WHERE price = (
    SELECT price * 2
    FROM product
    WHERE product_name = 'Smartphone'
);





