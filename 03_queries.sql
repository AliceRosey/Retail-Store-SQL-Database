USE Retail_Store;

--  Level 1: Basics

-- L1 Q1: Retrieve customer names and emails
SELECT name, email
FROM customers;

-- L1 Q2: View complete product catalog
SELECT *
FROM products;

-- L1 Q3: List all unique product categories
SELECT DISTINCT category
FROM products;

-- L1 Q4: Products priced above 1000
SELECT * FROM products
WHERE price > 1000;

-- L1 Q5: Products priced between 2000 and 5000
SELECT * FROM products
WHERE price BETWEEN 2000 AND 5000;

-- L1 Q6: Fetch data for specific customer IDs (example ids: 1,2,3)
SELECT * FROM customers
WHERE customer_id IN (1,2,3);

-- L1 Q7: Customers whose names start with 'A'
SELECT * FROM customers
WHERE name LIKE 'A%';

-- L1 Q8: Electronics products priced under 3000
SELECT * FROM products
WHERE category = 'Electronics' AND price < 3000;

-- L1 Q9: Product names and prices descending by price
SELECT name, price FROM products
ORDER BY price DESC;

-- L1 Q10: Product names and prices sorted by price then name
SELECT name, price FROM products
ORDER BY price DESC, name ASC;


--   Level 2: Filtering/Formatting

-- L2 Q1: Orders where customer information is missing (customerid NULL)
SELECT * FROM orders
WHERE customer_id IS NULL;

-- L2 Q2: Display customer names and emails using aliases
SELECT name  AS customer_name,
  email AS customer_email FROM customers;

-- L2 Q3: Total value per item ordered (quantity * itemprice)
SELECT
  order_item_id,
  order_id,
  product_id,
  quantity,
  item_price,
  (quantity * item_price) AS line_total
FROM order_items;

-- L2 Q4: Combine customer name and phone number in a single column
SELECT
  customer_id,
  CONCAT(name, ' - ', IFNULL(phone, 'N/A')) AS customer_contact
FROM customers;

-- L2 Q5: Extract only date part from order timestamps
SELECT
  order_id,
  DATE(order_date) AS order_date
FROM orders;

-- L2 Q6: Products that do not have any stock left
SELECT * FROM products
WHERE stock_quantity = 0;


--  Level 3: Aggregations

-- L3 Q1: Count total number of orders placed
SELECT COUNT(*) AS total_orders
FROM orders;

-- L3 Q2: Total revenue collected from all orders (using orders.totalamount)
SELECT SUM(total_amount) AS total_revenue
FROM orders;

-- L3 Q3: Average order value
SELECT AVG(total_amount) AS avg_order_value
FROM orders;

-- L3 Q4: Count customers who have placed at least one order
SELECT COUNT(DISTINCT customer_id) AS active_customers FROM orders
WHERE customer_id IS NOT NULL;

-- L3 Q5: Number of orders placed by each customer
SELECT
  customer_id,
  COUNT(*) AS orders_count FROM orders
WHERE customer_id IS NOT NULL GROUP BY customer_id;

-- L3 Q6: Total sales amount made by each customer
SELECT
  customer_id,
  SUM(total_amount) AS total_spent
FROM orders WHERE customer_id IS NOT NULL GROUP BY customer_id;

-- L3 Q7: Number of products sold per category
SELECT
  p.category,
  SUM(oi.quantity) AS units_sold
FROM order_items oi JOIN products p ON p.product_id = oi.product_id
GROUP BY p.category;

-- L3 Q8: Average item price per category (using products.price)
SELECT
  category,
  AVG(price) AS avg_price FROM products
GROUP BY category;

-- L3 Q9: Number of orders placed per day
SELECT
  DATE(order_date) AS order_day,
  COUNT(*) AS orders_count
FROM orders GROUP BY DATE(order_date)
ORDER BY order_day;

-- L3 Q10: Total payments received per payment method
SELECT
  method,
  SUM(amount_paid) AS total_received FROM payments
GROUP BY method;


--   Level 4: Joins

-- L4 Q1: Order details with customer name (INNER JOIN)
SELECT
  o.order_id,
  o.order_date,
  o.status,
  o.total_amount,
  c.customer_id,
  c.name AS customer_name
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id;

-- L4 Q2: Products that have been sold (appear in orderitems)
SELECT DISTINCT
  p.product_id,
  p.name,
  p.category FROM products p
JOIN order_items oi ON oi.product_id = p.product_id;

-- L4 Q3: All orders with their payment method
SELECT
  o.order_id,
  o.order_date,
  o.total_amount,
  p.method,
  p.amount_paid,
  p.payment_date FROM orders o
JOIN payments p ON p.order_id = o.order_id;

-- L4 Q4: Customers and their orders (LEFT JOIN)
SELECT
  c.customer_id,
  c.name,
  o.order_id,
  o.order_date,
  o.total_amount FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id, o.order_date;

-- L4 Q5: All products along with order item quantity (LEFT JOIN)
SELECT
  p.product_id,
  p.name,
  COALESCE(SUM(oi.quantity), 0) AS total_quantity_sold FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name;

-- L4 Q6: Payments including those with no matching orders
SELECT
  p.payment_id,
  p.order_id,
  o.customer_id,
  p.amount_paid,
  p.method FROM orders o
RIGHT JOIN payments p ON p.order_id = o.order_id;

-- L4 Q7: Combine customer, order, and payment (3-table report)
SELECT
  c.customer_id, c.name AS customer_name,
  o.order_id, o.order_date, o.total_amount,
  p.payment_id, p.amount_paid, p.method,p.payment_date
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
LEFT JOIN payments p ON p.order_id = o.order_id;


--   Level 5: Subqueries

-- L5 Q1: Products priced above average product price
SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- L5 Q2: Customers who have placed at least one order
SELECT * FROM customers c
WHERE EXISTS (
  SELECT 1 FROM orders o
  WHERE o.customer_id = c.customer_id
);

-- L5 Q3: Orders whose totalamount is above the average for that customer
SELECT * FROM orders o
WHERE o.customer_id IS NOT NULL
  AND o.total_amount >
    (SELECT AVG(o2.total_amount)
     FROM orders o2
     WHERE o2.customer_id = o.customer_id);

-- L5 Q4: Customers who haven't placed any orders
SELECT * FROM customers c
WHERE NOT EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);

-- L5 Q5: Products that were never ordered
SELECT *
FROM products p
WHERE NOT EXISTS (
  SELECT 1 FROM order_items oi
  WHERE oi.product_id = p.product_id
);

-- L5 Q6: Highest value order per customer (customerid + max totalamount)
SELECT
  customer_id,
  MAX(total_amount) AS highest_order_value
FROM orders
GROUP BY customer_id;

-- L5 Q7: Highest Order Per Customer Including Names
SELECT
  c.customer_id, c.name,
  t.highest_order_value
FROM customers c
JOIN (
  SELECT
    customer_id,
    MAX(total_amount) AS highest_order_value
  FROM orders
  WHERE customer_id IS NOT NULL
  GROUP BY customer_id
) t ON t.customer_id = c.customer_id;


--   Level 6: Set operations (MySQL)

-- L6 Q1: Customers who either placed an order OR wrote a review
SELECT customer_id FROM orders
WHERE customer_id IS NOT NULL
UNION SELECT customer_id
FROM product_reviews
WHERE customer_id IS NOT NULL;

-- L6 Q2: Customers who placed an order AND also reviewed a product
SELECT c.customer_id, c.name, c.email
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id)
  AND EXISTS (SELECT 1 FROM product_reviews r WHERE r.customer_id = c.customer_id);
