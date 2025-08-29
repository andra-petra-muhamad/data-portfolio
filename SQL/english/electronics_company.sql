/*
An electronics company is rapidly growing in selling various products 
such as laptops, smartphones, tablets, cameras, and other accessories. 
The company needs a database system to record sales transactions, customer data, 
and order details so that business operations become more efficient.

Therefore, the `electronics_company` database is built with the main structure:
1. `customers` table to store customer data (name, email).
2. `orders` table to store order data (date, customer who placed the order).
3. `order_items` table to store item details ordered in each order.
4. `product` table to store product list along with price and category.

With this system, the company can:
- Monitor daily transactions.
- See which customers make the most purchases.
- Identify the best-selling products.
- Calculate the total revenue from sales.
*/

-- Create database and for the tables, data will be imported from external sources
CREATE DATABASE electronics_company;
USE electronics_company;

-- 1. Which customers have ever placed an order?
SELECT DISTINCT c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

-- 2. What products were ordered in a specific order (e.g., order_id = 101)?
SELECT p.product_name, i.quantity
FROM items i
JOIN product p ON i.product_id = p.product_id
WHERE i.order_id = 101;

-- 3. What is the total spending of each customer?
SELECT c.customer_name, SUM(p.price * i.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN items i ON o.order_id = i.order_id
JOIN product p ON i.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- 4. What is the most frequently purchased product?
SELECT p.product_name, SUM(i.quantity) AS total_sold
FROM items i
JOIN product p ON i.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 1;

-- 5. What is the total company revenue?
SELECT SUM(p.price * i.quantity) AS total_revenue
FROM items i
JOIN product p ON i.product_id = p.product_id;

-- 6. Use a subquery to find customers who
-- made their first purchase between February 25–27, 2024
SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE order_date
          BETWEEN '2024-02-25' AND '2024-02-27'
);

-- 7. Use a subquery to display order_id that has more than 1 type of product.
SELECT order_id
FROM items
GROUP BY order_id
HAVING COUNT(DISTINCT product_id) > 1;

-- Option 2
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

-- 8. Use a subquery to display the customer with the highest total spending
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

-- Option 2
SELECT c.customer_name, t.total_spent
FROM customers c
JOIN (
    SELECT o.customer_id, SUM(p.price * i.quantity) AS total_spent
    FROM orders o
    JOIN items i ON o.order_id = i.order_id
    JOIN product p ON i.product_id = p.product_id
    GROUP BY o.customer_id
    ORDER BY total_spent DESC
    LIMIT 1
) t ON c.customer_id = t.customer_id;

-- 9. Use a subquery to display the type of product that has a price 
-- twice as high as the price of a Smartphone.
SELECT product_name
FROM product
WHERE price = (
    SELECT price * 2
    FROM product
    WHERE product_name = 'Smartphone'
);

-- Option 2
SELECT product_name, price
FROM product
WHERE price = (
    SELECT price * 2
    FROM product
    WHERE product_name = 'Smartphone'
);
