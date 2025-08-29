/*
Sebuah perusahaan e-commerce sedang berkembang pesat dan melayani berbagai pelanggan 
dengan produk teknologi seperti laptop, smartphone, dan aksesoris. 
Selain penjualan, perusahaan ini juga memiliki layanan pelanggan 
yang ditangani oleh tim support dan sales.

Untuk mendukung operasional dan analisis bisnis, 
dibangunlah database `online_shop` dengan struktur utama:
1. Tabel `products` menyimpan informasi produk, termasuk kategori, harga, stok, dan diskon.
2. Tabel `customers` menyimpan data pelanggan seperti nama, kontak, dan alamat.
3. Tabel `orders` mencatat setiap transaksi pembelian yang dilakukan pelanggan.
4. Tabel `orderdetails` menyimpan detail produk dalam setiap pesanan, termasuk jumlah dan harga satuan.
5. Tabel `employees` berisi data karyawan dari berbagai departemen, seperti sales, support, dan development.
6. Tabel `supporttickets` mencatat keluhan atau pertanyaan pelanggan yang ditangani oleh karyawan support.

Dengan sistem ini, perusahaan dapat:
- Menganalisis penjualan produk berdasarkan kategori, harga, dan diskon.
- Memantau jumlah dan tren transaksi pelanggan secara harian atau bulanan.
- Mengevaluasi performa karyawan dalam menangani keluhan pelanggan.
- Menentukan produk terlaris serta mengoptimalkan manajemen stok.
- Mengidentifikasi pola keluhan pelanggan untuk meningkatkan kualitas layanan.
*/

-- Membuat database
CREATE DATABASE online_shop;
USE online_shop;

-- Membuat tabel products
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT,
    discount DECIMAL(5,2) DEFAULT 0
);

-- 3. Membuat tabel customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255)
);

-- 4. Membuat tabel orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 5. Membuat tabel order_details
CREATE TABLE order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 6. Membuat tabel employees
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    hire_date DATE,
    department VARCHAR(50)
);

-- 7. Membuat tabel support_tickets
CREATE TABLE support_tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    issue VARCHAR(255),
    status ENUM('open','resolved') DEFAULT 'open',
    created_at DATETIME,
    resolved_at DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Insert Data Products
INSERT INTO products (product_name, category, price, stock_quantity, discount)
VALUES
('Laptop Pro 15', 'Laptop', 1500.00, 100, 0),
('Smartphone X', 'Smartphone', 800.00, 200, 0),
('Wireless Mouse', 'Accessories', 25.00, 500, 0),
('USB-C Charger', 'Accessories', 20.00, 300, 0),
('Gaming Laptop', 'Laptop', 2000.00, 50, 10),
('Budget Smartphone', 'Smartphone', 300.00, 150, 5),
('Noise Cancelling Headphones', 'Accessories', 150.00, 120, 15),
('Wireless Earphones', 'Accessories', 100.00, 100, 10);

-- Insert Data Customers
INSERT INTO customers (first_name, last_name, email, phone, address)
VALUES
('John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Elm Street'),
('Jane', 'Smith', 'jane.smith@example.com', '123-456-7891', '456 Oak Street'),
('Emily', 'Johnson', 'emily.johnson@example.com', '123-456-7892', '789 Pine Street'),
('Michael', 'Brown', 'michael.brown@example.com', '123-456-7893', '101 Maple Street'),
('Sarah', 'Davis', 'sarah.davis@example.com', '123-456-7894', '202 Birch Street');

-- Insert Data Orders
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES
(1, '2023-07-01', 1525.00),
(2, '2023-07-02', 820.00),
(3, '2023-07-03', 25.00),
(1, '2023-07-04', 2010.00),
(4, '2023-07-05', 300.00),
(2, '2023-07-06', 315.00),
(5, '2023-07-07', 165.00);

-- Insert Data order_details
INSERT INTO order_details (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 1500.00),
(1, 3, 1, 25.00),
(2, 2, 1, 800.00),
(2, 4, 1, 20.00),
(3, 3, 1, 25.00),
(4, 5, 1, 2000.00),
(4, 6, 1, 10.00),
(5, 6, 1, 300.00),
(6, 6, 1, 300.00),
(7, 7, 1, 150.00),
(7, 4, 1, 15.00);

-- Insert Data Employees
INSERT INTO employees (first_name, last_name, email, phone, hire_date, department)
VALUES
('Alice', 'Williams', 'alice.williams@example.com', '123-456-7895', '2022-01-15', 'Support'),
('Bob', 'Miller', 'bob.miller@example.com', '123-456-7896', '2022-02-20', 'Sales'),
('Charlie', 'Wilson', 'charlie.wilson@example.com', '123-456-7897', '2022-03-25', 'Development'),
('David', 'Moore', 'david.moore@example.com', '123-456-7898', '2022-04-30', 'Support'),
('Eve', 'Taylor', 'eve.taylor@example.com', '123-456-7899', '2022-05-10', 'Sales');

-- Insert Data support_tickets
INSERT INTO support_tickets (customer_id, employee_id, issue, status, created_at, resolved_at)
VALUES
(1, 1, 'Cannot connect to Wi-Fi', 'resolved', '2023-07-01 10:00:00', '2023-07-01 11:00:00'),
(2, 1, 'Screen flickering', 'resolved', '2023-07-02 12:00:00', '2023-07-02 13:00:00'),
(3, 1, 'Battery drains quickly', 'open', '2023-07-03 14:00:00', NULL),
(4, 2, 'Late delivery', 'resolved', '2023-07-04 15:00:00', '2023-07-04 16:00:00'),
(5, 2, 'Damaged product', 'open', '2023-07-05 17:00:00', NULL),
(1, 3, 'Software issue', 'resolved', '2023-07-06 18:00:00', '2023-07-06 19:00:00'),
(2, 3, 'Bluetooth connectivity issue', 'resolved', '2023-07-07 20:00:00', '2023-07-07 21:00:00'),
(5, 4, 'Account issue', 'open', '2023-07-08 22:00:00', NULL),
(3, 4, 'Payment issue', 'resolved', '2023-07-09 23:00:00', '2023-07-09 23:30:00'),
(4, 5, 'Physical damage', 'open', '2023-07-10 08:00:00', NULL),
(4, 1, 'Laptop blue screen', 'resolved', '2024-01-05 10:00:00', '2024-02-05 12:00:00'),
(5, 1, 'Laptop lagging', 'resolved', '2024-01-06 10:00:00', '2024-01-25 12:00:00'),
(3, 1, 'Some part of laptop broken', 'resolved', '2024-02-05 10:00:00', '2024-03-05 12:00:00');

-- Memeriksa database
SELECT * FROM  customers;
SELECT * FROM employees;
SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM support_tickets;

/* Pertanyaan dan Jawaban */

-- 1. Identifikasi 3 pelanggan teratas berdasarkan total nominal pesanan
SELECT 
  c.customer_id,
  c.first_name,
  c.last_name,
  SUM(o.total_amount) AS total_order_amount
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_order_amount DESC
LIMIT 3;

-- 2. Rata-rata nominal pesanan untuk setiap pelanggan
SELECT 
  c.customer_id,
  c.first_name,
  c.last_name,
  AVG(o.total_amount) AS average_order
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 3. Karyawan yang menyelesaikan > 4 tiket support
SELECT 
  e.employee_id,
  e.first_name,
  e.last_name,
  COUNT(s.ticket_id) AS resolved_count
FROM employees e
JOIN support_tickets s ON s.employee_id = e.employee_id
WHERE s.status = 'resolved'
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING COUNT(s.ticket_id) > 4;

-- 4. Produk yang belum pernah dipesan
SELECT 
  p.product_id,
  p.product_name
FROM products p
LEFT JOIN order_details od ON od.product_id = p.product_id
WHERE od.order_id IS NULL;

-- 5. Total pendapatan dari penjualan produk
SELECT 
  SUM(od.quantity * od.unit_price) AS total_revenue
FROM order_details od;

-- 6. Harga rata-rata produk per kategori; tampilkan yang > $500
WITH cte_avg_price AS (
  SELECT category, AVG(price) AS avg_price
  FROM products
  GROUP BY category
)
SELECT category, avg_price
FROM cte_avg_price
WHERE avg_price > 500;

-- 7. Pelanggan yang punya setidaknya satu pesanan > $1000
SELECT 
  c.customer_id,
  c.first_name,
  c.last_name
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
    AND o.total_amount > 1000
);

-- 8. Produk terlaris berdasarkan jumlah unit terjual
SELECT 
  p.product_id,
  p.product_name,
  SUM(od.quantity) AS total_sold
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 5;

-- 9. Total penjualan per hari (tren harian)
SELECT 
  o.order_date,
  SUM(o.total_amount) AS daily_sales
FROM orders o
GROUP BY o.order_date
ORDER BY o.order_date;

-- 10. Pelanggan dengan jumlah pesanan terbanyak
SELECT 
  c.customer_id,
  c.first_name,
  c.last_name,
  COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC
LIMIT 5;

-- 11. Rata-rata waktu penyelesaian tiket support (hanya resolved)
SELECT 
  e.employee_id,
  e.first_name,
  e.last_name,
  AVG(TIMESTAMPDIFF(HOUR, s.created_at, s.resolved_at)) AS avg_resolution_time_hours
FROM employees e
JOIN support_tickets s ON e.employee_id = s.employee_id
WHERE s.status = 'resolved'
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY avg_resolution_time_hours;

-- 12. Produk dengan diskon tertinggi yang pernah dipesan
SELECT 
  p.product_id,
  p.product_name,
  p.discount,
  COUNT(od.order_id) AS total_orders
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.discount
ORDER BY p.discount DESC, total_orders DESC;

-- 13. Jumlah keluhan pelanggan per status (open vs resolved)
SELECT 
  status,
  COUNT(ticket_id) AS total_tickets
FROM support_tickets
GROUP BY status;

-- 14. 3 kategori produk dengan rata-rata pendapatan terbesar
SELECT 
  p.category,
  AVG(od.quantity * od.unit_price) AS avg_revenue
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY avg_revenue DESC
LIMIT 3;

-- 15. Pelanggan yang paling sering mengajukan tiket support
SELECT 
  c.customer_id,
  c.first_name,
  c.last_name,
  COUNT(s.ticket_id) AS total_tickets
FROM customers c
JOIN support_tickets s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_tickets DESC
LIMIT 5;

