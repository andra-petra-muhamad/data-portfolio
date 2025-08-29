/*
An online transportation company is rapidly growing in a major city. 
This company provides transportation services with multiple service types, 
such as regular and luxury, operating across different areas.

To support operations and facilitate business analysis, 
a `taxi` database is built with the following main structure:
1. Table `orders` to record each customer order, including date, order ID, user, service type, area, base fare (flag fall), and distance.
2. Table `fare` to store additional drop fees according to area and service type.
3. Table `driver_commission` to record the commission rate received by drivers based on area and service type.

With this system, the company can:
- Calculate total trip fare based on flag fall, distance, and drop fee.
- Determine drivers' net income after company commission.
- Analyze the performance of regular and luxury services in different areas.
- Monitor daily booking trends to support better business decision-making.
*/

-- Create database
CREATE DATABASE taxi;
USE taxi;

-- Create table orders
CREATE TABLE orders (
    order_date DATE,
    order_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(20),
    service_type VARCHAR(20),
    area VARCHAR(50),
    flag_fall INT,
    distance INT
);

-- Create table fare
CREATE TABLE fare (
    area VARCHAR(50),
    service_type VARCHAR(20),
    drop_fee INT,
    PRIMARY KEY (area, service_type)
);

-- Create table driver_commission
CREATE TABLE driver_commission (
    area VARCHAR(50),
    service_type VARCHAR(20),
    commission DECIMAL(3,2),
    PRIMARY KEY (area, service_type)
);

-- Insert into orders table
INSERT INTO orders (order_date, order_id, user_id, service_type, area, flag_fall, distance) VALUES
('2024-03-01', '1010101', 'A0001', 'regular', 'Jakarta', 9000, 10),
('2024-03-01', '1010102', 'A0002', 'regular', 'Jakarta', 9000, 15),
('2024-03-01', '1010103', 'A0003', 'regular', 'Jakarta', 9000, 20),
('2024-03-02', '1010104', 'A0004', 'luxury',  'Jakarta', 250000, 25),
('2024-03-02', '1010105', 'A0005', 'luxury',  'Jakarta', 250000, 21),
('2024-03-05', '1010106', 'A0006', 'luxury',  'Jakarta', 250000, 32),
('2024-03-05', '1010107', 'A0007', 'regular', 'Jakarta', 9000, 17);

-- Insert into fare table
INSERT INTO fare (area, service_type, drop_fee) VALUES
('Jakarta', 'regular', 8000),
('Jakarta', 'luxury', 15000);

-- Insert into driver_commission table
INSERT INTO driver_commission (area, service_type, commission) VALUES
('Jakarta', 'regular', 0.3),
('Jakarta', 'luxury', 0.4);

-- Check database
SELECT * FROM orders;
SELECT * FROM fare;
SELECT * FROM driver_commission;

/* Questions and Answers */
-- 1. Total trip fare for each order
SELECT 
    o.order_id,
    o.user_id,
    o.service_type,
    o.area,
    o.flag_fall,
    o.distance,
    (o.flag_fall + (o.distance * 5000) + f.drop_fee) AS total_fare
FROM orders o
JOIN fare f 
    ON o.service_type = f.service_type 
   AND o.area = f.area
ORDER BY total_fare DESC;

-- 2. Driver net income after commission
SELECT 
    o.order_id,
    o.user_id,
    o.service_type,
    o.area,
    (o.flag_fall + (o.distance * 5000) + f.drop_fee) AS gross_fare,
    dc.commission,
    ( (o.flag_fall + (o.distance * 5000) + f.drop_fee) 
        * (1 - dc.commission/100.0) ) AS driver_income
FROM orders o
JOIN fare f 
    ON o.service_type = f.service_type 
   AND o.area = f.area
JOIN driver_commission dc 
    ON o.service_type = dc.service_type 
   AND o.area = dc.area
ORDER BY driver_income DESC;

-- 3. Average fare for Regular vs Luxury services
SELECT 
    o.service_type,
    AVG(o.flag_fall + (o.distance * 5000) + f.drop_fee) AS avg_total_fare
FROM orders o
JOIN fare f 
    ON o.service_type = f.service_type 
   AND o.area = f.area
GROUP BY o.service_type;

-- 4. Total number of orders per area
SELECT 
    o.area,
    COUNT(o.order_id) AS total_orders
FROM orders o
GROUP BY o.area
ORDER BY total_orders DESC;

-- 5. Calculate revenue
SELECT order_date, SUM(flag_fall + (distance*drop_fee)) AS revenue
FROM orders o
LEFT JOIN fare f
ON o.area = f.area AND o.service_type=f.service_type
GROUP BY order_date;

-- 6. Calculate cost
SELECT order_date, SUM((flag_fall + (distance*drop_fee))*commission) AS cost
FROM orders o
LEFT JOIN fare f
ON o.area = f.area AND o.service_type=f.service_type
LEFT JOIN driver_commission d
ON o.area=d.area AND o.service_type=d.service_type
GROUP BY order_date;

-- 7. Calculate profit
WITH revenue AS (
    SELECT order_date, SUM(flag_fall + (distance*drop_fee)) AS revenue
	FROM orders o
	LEFT JOIN fare f
	ON o.area = f.area AND o.service_type=f.service_type
	GROUP BY order_date
),
cost AS (
    SELECT order_date, SUM((flag_fall + (distance*drop_fee))*commission) AS cost
	FROM orders o
	LEFT JOIN fare f
	ON o.area = f.area AND o.service_type=f.service_type
	LEFT JOIN driver_commission d
	ON o.area=d.area AND o.service_type=d.service_type
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

-- 8. Calculate Average Revenue Per User (ARPU)
WITH kpis AS (
SELECT order_date,
	SUM(flag_fall + (distance*drop_fee)) AS revenue,
	COUNT(DISTINCT user_id) AS users
FROM orders o
LEFT JOIN fare f
ON o.area=f.area AND o.service_type=f.service_type
GROUP BY order_date)
SELECT ROUND(revenue/users,2) AS ARPU
FROM kpis;

-- 9. Number of registered users
WITH reg_dates AS (
	SELECT user_id,
	MIN(order_date) AS reg_date
	FROM orders
	GROUP BY user_id)
SELECT DATE_FORMAT(reg_date, '%Y-%m')  AS reg_month,
	COUNT(DISTINCT user_id) AS regs
FROM reg_dates
GROUP BY 1;
