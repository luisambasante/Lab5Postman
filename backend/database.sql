CREATE DATABASE IF NOT EXISTS graphql_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE graphql_db;

CREATE TABLE IF NOT EXISTS users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email) VALUES
  ('Ana Torres', 'ana@example.com'),
  ('Carlos Parra', 'carlos@example.com');

SELECT id, name, email FROM users;

CREATE TABLE IF NOT EXISTS products (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  description VARCHAR(500),
  price DECIMAL(10,2) NOT NULL,
  stock INT UNSIGNED NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products (name, description, price, stock) VALUES
  ('Teclado mecánico', 'Teclado mecánico retroiluminado', 129.99, 25),
  ('Mouse inalámbrico', 'Mouse ergonómico inalámbrico', 49.90, 60);

SELECT id, name, description, price, stock FROM products;
