/*
Sebuah perusahaan transportasi online sedang berkembang pesat di kota besar. 
Perusahaan ini menyediakan layanan transportasi dengan berbagai jenis layanan, 
seperti reguler dan luxury, yang beroperasi di berbagai area.

Untuk mendukung operasional dan mempermudah analisis bisnis, 
dibangunlah database `taxi` dengan struktur utama:
1. Tabel `orders` untuk mencatat setiap pesanan pelanggan, termasuk tanggal, ID pesanan, pengguna, jenis layanan, area, tarif awal (flag fall), dan jarak tempuh.
2. Tabel `fare` untuk menyimpan informasi biaya tambahan (drop) sesuai area dan jenis layanan.
3. Tabel `driver_commission` untuk mencatat besaran komisi yang diterima driver berdasarkan area dan jenis layanan.

Dengan sistem ini, perusahaan dapat:
- Menghitung total biaya perjalanan berdasarkan flag fall, jarak tempuh, dan biaya drop.
- Menentukan pendapatan bersih driver setelah dikurangi komisi perusahaan.
- Menganalisis performa layanan reguler dan luxury di berbagai area.
- Memantau tren pemesanan harian untuk mendukung pengambilan keputusan bisnis.
*/

-- Membuat database
CREATE DATABASE taxi;
USE taxi;

-- Membuat tabel orders
CREATE TABLE orders (
    order_date DATE,
    order_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(20),
    services VARCHAR(20),
    area VARCHAR(50),
    flag_fall INT,
    distance INT
);

-- Membuat tabel fare
CREATE TABLE fare (
    area VARCHAR(50),
    services VARCHAR(20),
    drop_fee INT,
    PRIMARY KEY (area, services)
);

-- Membuat tabel driver_commission
CREATE TABLE driver_commission (
    area VARCHAR(50),
    services VARCHAR(20),
    commission DECIMAL(3,2),
    PRIMARY KEY (area, services)
);

-- Insert ke tabel orders
INSERT INTO orders (order_date, order_id, user_id, services, area, flag_fall, distance) VALUES
('2024-03-01', '1010101', 'A0001', 'reguler', 'Jakarta', 9000, 10),
('2024-03-01', '1010102', 'A0002', 'reguler', 'Jakarta', 9000, 15),
('2024-03-01', '1010103', 'A0003', 'reguler', 'Jakarta', 9000, 20),
('2024-03-02', '1010104', 'A0004', 'luxury',  'Jakarta', 250000, 25),
('2024-03-02', '1010105', 'A0005', 'luxury',  'Jakarta', 250000, 21),
('2024-03-05', '1010106', 'A0006', 'luxury',  'Jakarta', 250000, 32),
('2024-03-05', '1010107', 'A0007', 'reguler', 'Jakarta', 9000, 17);

-- Insert ke tabel fare
INSERT INTO fare (area, services, drop_fee) VALUES
('Jakarta', 'reguler', 8000),
('Jakarta', 'luxury', 15000);

-- Insert ke tabel driver_commission
INSERT INTO driver_commission (area, services, commission) VALUES
('Jakarta', 'reguler', 0.3),
('Jakarta', 'luxury', 0.4);

-- Memeriksa database
SELECT * FROM orders;
SELECT * FROM fare;
SELECT * FROM driver_commission;

/* Pertanyaan dan Jawaban */
-- 1. Total biaya perjalanan setiap pesanan
SELECT 
    o.order_id,
    o.user_id,
    o.services,
    o.area,
    o.flag_fall,
    o.distance,
    (o.flag_fall + (o.distance * 5000) + f.drop_fee) AS total_fare
FROM orders o
JOIN fare f 
    ON o.services = f.services 
   AND o.area = f.area
ORDER BY total_fare DESC;

-- 2. Pendapatan bersih driver setelah komisi
SELECT 
    o.order_id,
    o.user_id,
    o.services,
    o.area,
    (o.flag_fall + (o.distance * 5000) + f.drop_fee) AS gross_fare,
    dc.commission,
    ( (o.flag_fall + (o.distance * 5000) + f.drop_fee) 
        * (1 - dc.commission/100.0) ) AS driver_income
FROM orders o
JOIN fare f 
    ON o.services = f.services 
   AND o.area = f.area
JOIN driver_commission dc 
    ON o.services = dc.services 
   AND o.area = dc.area
ORDER BY driver_income DESC;

-- 3. Rata-rata biaya layanan Reguler vs Luxury
SELECT 
    o.services,
    AVG(o.flag_fall + (o.distance * 5000) + f.drop_fee) AS avg_total_fare
FROM orders o
JOIN fare f 
    ON o.services = f.services 
   AND o.area = f.area
GROUP BY o.services;

-- 4. Total jumlah order per area
SELECT 
    o.area,
    COUNT(o.order_id) AS total_orders
FROM orders o
GROUP BY o.area
ORDER BY total_orders DESC;

-- 5. Menghitung Revenue
SELECT order_date, SUM(flag_fall + (distance*drop_fee)) revenue
FROM orders o
LEFT JOIN fare f
ON o.area = f.area AND o.services=f.services
GROUP BY order_date;

-- 6. Menghitung Cost
SELECT order_date, SUM((flag_fall + (distance*drop_fee))*commission) cost
FROM orders o
LEFT JOIN fare f
ON o.area = f.area AND o.services=f.services
LEFT JOIN driver_commission d
ON o.area=d.area AND o.services=d.services
GROUP BY order_date;

-- 7. Menghitung profit
WITH revenue AS (
    SELECT order_date, SUM(flag_fall + (distance*drop_fee)) revenue
	FROM orders o
	LEFT JOIN fare f
	ON o.area = f.area AND o.services=f.services
	GROUP BY order_date
),
cost AS (
    SELECT order_date, SUM((flag_fall + (distance*drop_fee))*commission) cost
	FROM orders o
	LEFT JOIN fare f
	ON o.area = f.area AND o.services=f.services
	LEFT JOIN driver_commission d
	ON o.area=d.area AND o.services=d.services
	GROUP BY order_date
)
SELECT 
    r.order_date,
    r.revenue,
    c.cost,
    r.revenue - c.cost AS profit
FROM revenue r
JOIN cost c ON r.order_date = c.order_date
ORDER BY r.order_date;

-- 8. Menghitung Average Revenue Per User (ARPU)
WITH kpis AS (
SELECT order_date,
	SUM(flag_fall + (distance*drop_fee)) revenue,
	COUNT(DISTINCT user_id) users
FROM orders o
LEFT JOIN fare f
ON o.area=f.area AND o.services=f.services
GROUP BY order_date)
SELECT ROUND(revenue/users,2) AS ARPU
FROM kpis;

-- 9. Banyak user yang registrasi
WITH reg_dates AS (
	SELECT user_id,
	MIN(order_date) reg_date
	FROM orders
	GROUP BY user_id)
SELECT DATE_FORMAT(reg_date, '%Y-%m')  AS reg_month,
	COUNT(DISTINCT user_id) AS regs
FROM reg_dates
GROUP BY 1;

