/*
An electronics company sells various products such as laptops, smartphones, tablets, cameras, 
and other accessories. To support business operations, the company requires a database system 
to record sales transactions, customer data, and available product information.

For this purpose, the `sales` database is created with the following structure:
1. `customers` table to store customer data (name, email, country).
2. `products` table to store product list along with category and price.
3. `sales` table to record sales transactions (date, customer, product, quantity, and total sales).

With this system, the company can:
- Monitor daily sales transactions.
- Identify customers based on their country of origin.
- Determine the most frequently purchased products.
- Calculate total revenue from each customer as well as overall sales.
- Support business analysis for better decision-making.
*/

-- Create database (tables are imported from external data)
CREATE DATABASE sales;
USE sales;

-- Create customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

-- Create products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2)
);

-- Create sales table
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

-- Insert data into customers table
INSERT INTO customers (customer_id, customer_name, email, country) VALUES
(201, 'John Doe', 'john.doe@example.com', 'USA'),
(202, 'Jane Smith', 'jane.smith@example.com', 'Canada'),
(203, 'Bob Johnson', 'bob.johnson@example.com', 'UK'),
(204, 'Alice Brown', 'alice.brown@example.com', 'Australia');

-- Insert data into products table
INSERT INTO products (product_id, product_name, category_id, price) VALUES
(101, 'Laptop', 1, 600),
(102, 'Smartphone', 2, 50),
(103, 'Headphones', 3, 60),
(104, 'Tablet', 1, 30),
(105, 'Camera', 4, 50);

-- Insert data into sales table
INSERT INTO sales (sale_id, product_id, customer_id, sale_date, quantity, total_amount) VALUES
(1, 101, 201, STR_TO_DATE('2/25/24 08:00','%m/%d/%y %H:%i'), 2, 120),
(2, 102, 202, STR_TO_DATE('2/25/24 09:30','%m/%d/%y %H:%i'), 1, 50),
(3, 103, 201, STR_TO_DATE('2/26/24 10:15','%m/%d/%y %H:%i'), 3, 180),
(4, 104, 203, STR_TO_DATE('2/26/24 12:45','%m/%d/%y %H:%i'), 1, 30),
(5, 105, 202, STR_TO_DATE('2/27/24 14:20','%m/%d/%y %H:%i'), 2, 100);

-- Check tables
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM sales;

-- 1. Calculate total company revenue
SELECT SUM(total_amount) AS total_revenue
FROM sales;

-- 2. Show the customer with the most purchases
SELECT 
    c.customer_name,
    COUNT(s.sale_id) AS transaction_count
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY transaction_count DESC
LIMIT 1;

-- 3. Show the best-selling product
SELECT 
    p.product_name,
    SUM(s.quantity) AS total_sold
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 1;

-- 4. Show total sales per product category
SELECT 
    category_id,
    SUM(total_amount) AS total_sales
FROM sales
JOIN products ON sales.product_id = products.product_id
GROUP BY category_id;

-- 5. Show transactions on a specific date (e.g., 2024-02-25)
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

-- 6. Show all customers with email and country
SELECT customer_name, email, country
FROM customers;

-- 7. Show list of products with prices
SELECT product_name, price
FROM products;

-- 8. Show all sales transactions with customer and product details
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

-- 9. Find the most purchased product (highest quantity sold)
SELECT 
    p.product_name,
    SUM(s.quantity) AS total_sold
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 1;

-- 10. Calculate average quantity purchased per transaction
SELECT AVG(quantity) AS avg_quantity
FROM sales;

-- 11. Show all transactions made by customers from "Canada"
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

-- 12. Show total sales per product category
SELECT 
    p.category_id,
    SUM(s.total_amount) AS total_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category_id;

-- 13. Find the customer with the highest total spending
SELECT 
    c.customer_name,
    SUM(s.total_amount) AS total_spending
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spending DESC
LIMIT 1;

-- 14. Products with total sales greater than the average
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

-- 15. Customer with the highest spending in each country (using RANK())
SELECT 
    c.country,
    c.customer_name,
    SUM(s.total_amount) AS total_amount,
    RANK() OVER (PARTITION BY c.country ORDER BY SUM(s.total_amount) DESC) AS ranking
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.country, c.customer_name;

-- 16. Customer category (Low, Medium, High) based on total quantity & amount
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

-- 17. Contribution of each product to overall sales
SELECT 
    p.product_name,
    SUM(s.quantity) AS total_quantity,
    SUM(s.total_amount) AS total_amount,
    ROUND(SUM(s.quantity) * 100.0 / SUM(SUM(s.quantity)) OVER (), 2) AS contribution_quantity_pct,
    ROUND(SUM(s.total_amount) * 100.0 / SUM(SUM(s.total_amount)) OVER (), 2) AS contribution_amount_pct
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name;
