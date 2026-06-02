## Retail Store SQL Mini Project (MySQL 8+)
This Retail Store SQL mini project is built using MySQL 8+ and executed in MySQL Workbench. It covers SQL from basics to advanced concepts such as filtering, formatting, aggregations, joins, subqueries, and set operations.
The database includes customers, products, orders, order items, payments, and product reviews. The project also contains SQL queries that answer a variety of business-oriented questions.

## Overview
This project demonstrates the design and implementation of a retail store database using MySQL 8.0. It covers database creation, sample data management, and SQL query analysis ranging from basic filtering to advanced joins, subqueries, aggregations, and set operations.

# Dataset: 
Sample data is inserted using the provided DML script as part of this project.

## SQL Concepts Covered
Level 1: Basics 
Covers ‘SELECT’, ‘DISTINCT’, ‘WHERE’, ‘BETWEEN’, ‘IN’, logical operators(AND/OR/NOT) and ‘ORDER BY’, ‘LIMIT’.
Level 2: Filtering and formatting 
Covers IS NULL, alias, arithmetic expression, CONCAT for combining columns and extracting dates from timestamps.
Level 3: Aggregations
Covers COUNT, SUM, AVG, MIN, MAX, plus GROUP BY and related reporting queries
Level 4: Joins
Covers INNER JOIN, LEFT JOIN, RIGHT JOIN and multi-table reporting.
Level 5: Subqueries
Covers scalar subqueries, subqueries in WHERE and FROM and EXISTS / NOT EXISTS use cases
Level 6: Set Operations 
Covers UNION / UNION ALL and handling INTERSECT-style questions using joins because INTERSECT may not be supported in MySQL.

# Database schema (tables)
-	Customers (customer_id, name, email, phone, created_at)
-	Products (product_id, name, category, price, stock_quantity, added_on)
-	Orders (order_id, customer_id, order_date, status, total_amount)
-	Order Items (order_item_id, order_id, product_id, quantity, item_price)
-	Payments (payment_id, order_id, payment_date, amount_paid, method)
-	Product Review (review_id, product_id, customer_id, rating, review_text, review_date)

# Project Files: 
All SQL scripts are provided in SQL format and can be executed directly in MySQL Workbench.
-	01_schema.sql – DDL statements to create all tables and constraints.
-	02_sample_data.sql – DML to insert sample data
-	03_queries.sql – SQL queries answering all business questions (level 1 to level 6)
 
# How to run (MySQL Workbench) 
Step 1: Setup database
•	Open MySQL Workbench and connect to your server. 
•	 Create and select database: 
                      CREATE DATABASE Retail_Store; 
                       USE Retail_Store;
Step 2: Run in order
Execute the files in this sequence:
1.	01_schema.sql — Creates all tables and constraints
2.	02_sample_data.sql — Inserts sample data into tables
3.	03_queries.sql — Contains queries for all business questions

# Business Questions Solved
The queries in 03_queries.sql answer questions such as:.
•	       Customer contact extraction for marketing
•	Product catalog and category exploration
•	Price/stock filters (premium items, mid-range items, out-of-stock).
•	Order revenue metrics (total orders, revenue, average order value).
•	Customer performance (orders per customer, total spent, highest order per customer).
•	Multi-table reports (order + customer + payment)
•	Engagement sets (customers who ordered and/or reviewed).

# Prerequisites
•	MySQL version: 8.0 or higher
•	MySQL Workbench: Any recent version
•	Privileges: Ensure you have CREATE, INSERT, and SELECT privileges

# Common issues / troubleshooting
1) "1062 Duplicate entry …" error
This happens when you re-run INSERT statements that try to insert values already existing in PRIMARY KEY or UNIQUE columns
Fix options:
•	Option A (Easiest): Drop and recreate the database
DROP DATABASE Retail_Store;
CREATE DATABASE Retail_Store;
USE Retail_Store;
Then re-run 01_schema.sql and 02_sample_data.sql

•	Option B: Clear data before re-inserting
SET FOREIGN_KEY_CHECKS = 0; TRUNCATE TABLE product_reviews; TRUNCATE TABLE payments; TRUNCATE TABLE order_items; TRUNCATE TABLE orders; TRUNCATE TABLE products; TRUNCATE TABLE customers; SET FOREIGN_KEY_CHECKS = 1;

2) Query returns "0 rows"
This usually means your current sample data has no records matching that condition. Try:
•	Verifying data was inserted: SELECT COUNT(*) FROM customers;
•	Adjusting filter conditions in the query
•	Re-running 02_sample_data.sql if data insertion failed

# Technologies Used

- MySQL 8+
- MySQL Workbench
- SQL
- Relational Database Management System (RDBMS)

# Screenshots

Screenshots of query execution outputs are available in the `screenshots/` folder.
