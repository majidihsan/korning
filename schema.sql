-- DEFINE YOUR DATABASE SCHEMA HERE
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS invoice_frequency;



CREATE TABLE employees(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE
);

CREATE TABLE customers(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE
);

CREATE TABLE products(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE
);

CREATE TABLE invoice_frequency(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE
);

CREATE TABLE sales(
  id SERIAL PRIMARY KEY,
  employee_id INT REFERENCES employees(id),
  customer_id INT REFERENCES customers(id),
  product_id INT REFERENCES products(id),
  sale_date VARCHAR(100),
  sale_amount VARCHAR(100),
  units_sold INT,
  invoice_no INT,
  frequency_id INT REFERENCES invoice_frequency(id)
);
