CREATE DATABASE IF NOT EXISTS Retail_Store;
USE Retail_Store;

CREATE TABLE customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone VARCHAR(15),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  stock_quantity INT NOT NULL DEFAULT 0,
  added_on DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chk_products_price CHECK (price > 0)
);

CREATE TABLE orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'Pending',
  total_amount DECIMAL(10,2),
  CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
 drop  table order_items;
 
CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  item_price DECIMAL(10,2) NOT NULL,
  CONSTRAINT chk_orderitems_qty CHECK (quantity > 0),
  CONSTRAINT fk_orderitems_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_orderitems_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
  payment_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  amount_paid DECIMAL(10,2) NOT NULL,
  method VARCHAR(20) NOT NULL,
  CONSTRAINT chk_payments_amount CHECK (amount_paid > 0),
  CONSTRAINT fk_payments_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE product_reviews (
  review_id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,
  customer_id INT NOT NULL,
  rating INT NOT NULL,
  review_text TEXT,
  review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chk_productreviews_rating CHECK (rating BETWEEN 1 AND 5),
  CONSTRAINT fk_reviews_product
    FOREIGN KEY (product_id) REFERENCES products(product_id),
  CONSTRAINT fk_reviews_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
