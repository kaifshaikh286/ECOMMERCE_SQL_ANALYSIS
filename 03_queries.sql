-- E-Commerce Sales Analysis: Business Insight Queries

-- Level 1: Basic SELECT, WHERE, ORDER BY

-- 1. List all customers from Bangalore
SELECT customer_name, city, signup_date
FROM customers
WHERE city = 'Bangalore';

-- 2. List all products priced above ₹20,000, most expensive first
SELECT product_name, category, price
FROM products
WHERE price > 20000
ORDER BY price DESC;

-- 3. List all cancelled orders
SELECT order_id, customer_id, order_date, shipping_city
FROM orders
WHERE order_status = 'Cancelled'
ORDER BY order_date DESC;

-- 4. Find the 10 most recent orders placed
SELECT order_id, customer_id, order_date, order_status
FROM orders
ORDER BY order_date DESC
LIMIT 10;

-- 5. List customers who signed up in 2026
SELECT customer_name, city, signup_date
FROM customers
WHERE signup_date >= '2026-01-01'
ORDER BY signup_date;


-- Level 2: Aggregates + GROUP BY + HAVING

-- 6. Total number of orders per status
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 7. Number of products in each category
SELECT category, COUNT(*) AS product_count, ROUND(AVG(price),2) AS avg_price
FROM products
GROUP BY category
ORDER BY product_count DESC;

-- 8. Cities with more than 15 customers
SELECT city, COUNT(*) AS total_customers
FROM customers
GROUP BY city
HAVING COUNT(*) > 15
ORDER BY total_customers DESC;

-- 9. Total revenue collected, broken down by payment_status
SELECT payment_status, SUM(amount) AS total_amount, COUNT(*) AS payment_count
FROM payments
GROUP BY payment_status
ORDER BY total_amount DESC;

-- 10. Average order value per payment method
SELECT payment_method, ROUND(AVG(amount),2) AS avg_order_value, COUNT(*) AS total_payments
FROM payments
GROUP BY payment_method
ORDER BY avg_order_value DESC;


-- Level 3: JOINs — INNER JOIN

-- 11. Show order details with customer names (INNER JOIN)
SELECT o.order_id, c.customer_name, o.order_date, o.order_status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC
LIMIT 20;

-- 12. Revenue by product category (INNER JOIN across 3 tables)
SELECT p.category, SUM(oi.quantity * oi.selling_price * (1 - oi.discount/100)) AS revenue
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- 13. Top 10 customers by total amount paid (only counting successful payments)
SELECT c.customer_name, SUM(p.amount) AS total_paid
FROM payments p
INNER JOIN orders o ON p.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE p.payment_status = 'Success'
GROUP BY c.customer_name
ORDER BY total_paid DESC
LIMIT 10;

-- LEFT JOIN

-- 14. Customers who have never placed an order
SELECT c.customer_id, c.customer_name, c.city
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 15. Products that have never been sold
SELECT p.product_id, p.product_name, p.category
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- 16. Every customer with their order count, including 0 for those with none
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders ASC;

-- 18. Products priced above their own category's average price
SELECT product_name, category, price
FROM products p1
WHERE price > (
    SELECT AVG(price)
    FROM products p2
    WHERE p2.category = p1.category
)
ORDER BY category, price DESC;

-- 19. Customers who have at least one cancelled order
SELECT customer_name, city
FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM orders WHERE order_status = 'Cancelled'
);

-- 20. Products never included in any order (same result as query 15, different technique)
SELECT product_name, category
FROM products
WHERE product_id NOT IN (
    SELECT product_id FROM order_items
);

-- 21. Customers who have placed at least one order (using EXISTS instead of a JOIN)
SELECT c.customer_name, c.city
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);

-- WINDOW FUNCTIONS
-- Query 1: Rank customers by total spend

SELECT c.customer_name,
       SUM(p.amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(p.amount) DESC) AS spend_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_status = 'Success'
GROUP BY c.customer_name
ORDER BY spend_rank
LIMIT 10;

-- Query 2: Running total of monthly revenue

WITH monthly_revenue AS (
    SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month, SUM(amount) AS revenue
    FROM payments
    WHERE payment_status = 'Success'
    GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
)
SELECT month,
       revenue,
       SUM(revenue) OVER (ORDER BY month) AS running_total
FROM monthly_revenue
ORDER BY month;