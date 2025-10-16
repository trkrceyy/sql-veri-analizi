-- ==========================================================
-- E-COMMERCE SALES ANALYSIS PROJECT (MySQL)
-- Created by: [CEYDA TÜRKER]
-- ==========================================================

-- 1️⃣ VERİTABANI OLUŞTURMA
CREATE DATABASE ecommerce_analysis;
USE ecommerce_analysis;

-- 2️⃣ TABLOLARIN OLUŞTURULMASI
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    gender ENUM('Male', 'Female'),
    age INT,
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50),
    brand VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 3️⃣ ÖRNEK VERİLER
INSERT INTO customers (name, gender, age, city) VALUES
('Ahmet Yılmaz', 'Male', 28, 'İstanbul'),
('Ayşe Demir', 'Female', 32, 'Ankara'),
('Mehmet Kaya', 'Male', 24, 'İzmir'),
('Elif Aydın', 'Female', 45, 'Bursa'),
('Can Korkmaz', 'Male', 38, 'Antalya');

INSERT INTO products (category, brand, price) VALUES
('Elektronik', 'Samsung', 8500),
('Elektronik', 'Apple', 21000),
('Giyim', 'Nike', 1200),
('Giyim', 'Adidas', 950),
('Ev', 'Arçelik', 6400),
('Ev', 'Philips', 4000);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-09-01', 8500),
(2, '2025-09-03', 23000),
(3, '2025-09-10', 2150),
(1, '2025-09-15', 950),
(4, '2025-09-20', 10400),
(5, '2025-09-25', 6400);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 8500),
(2, 2, 1, 21000),
(2, 3, 1, 1200),
(3, 4, 2, 950),
(4, 4, 1, 950),
(5, 5, 1, 6400),
(6, 5, 1, 6400);

-- 4️⃣ ANALİZ SORGULARI

-- En çok satan ürünler
SELECT p.brand, p.category, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.brand, p.category
ORDER BY total_sold DESC;

-- Şehirlere göre toplam gelir
SELECT c.city, SUM(o.total_amount) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;

-- Aylara göre satış trendi
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS total_sales
FROM orders
GROUP BY month
ORDER BY month;

-- Müşteri başına ortalama harcama
SELECT c.name, ROUND(AVG(o.total_amount), 2) AS avg_spending
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY avg_spending DESC;

-- Tekrar alışveriş yapan müşteriler
SELECT c.name, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING order_count > 1
ORDER BY order_count DESC;

-- Kategori bazında toplam satış geliri
SELECT p.category, SUM(oi.quantity * oi.unit_price) AS category_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;

-- En yüksek gelirli müşteri
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;
