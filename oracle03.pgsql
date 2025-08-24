
-- ===========================
DROP TABLE IF EXISTS projects;

CREATE TABLE projects (
    project_id      SERIAL PRIMARY KEY,
    project_name    VARCHAR(100) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    budget          NUMERIC(12,2),
    status          VARCHAR(20)  
);

-- ===========================
INSERT INTO projects (project_name, start_date, end_date, budget, status)
VALUES
('Sistema de Facturación Municipal', '2024-01-15', '2024-07-30', 50000.00, 'Completed'),
('Plataforma de Turismo Santa Bárbara', '2024-03-01', NULL, 15000.00, 'Active'),
('App de Delivery Catracho', '2024-05-10', '2024-05-10', 30000.00, 'Active'),
('Implementación de Inventario Agroindustrial', '2023-11-01', '2024-04-15', 80000.00, 'Completed'),
('Asistente Virtual para Trámites Municipales', '2024-06-20', NULL, 20000.00, 'On Hold');


-- ===========================


SELECT project_name, status
FROM projects
WHERE status = 'Active';

-- ===========================
SELECT project_name, budget
FROM projects
WHERE budget > 20000;

-- ===========================
SELECT project_name, end_date
FROM projects
WHERE end_date IS NOT NULL;

-- ===========================
SELECT project_name
FROM projects
WHERE project_name LIKE '%App%';

SELECT project_name, start_date, status
FROM projects
WHERE start_date > DATE '2024-01-01'
  AND status LIKE 'A%';

SELECT project_name, status, budget
FROM projects
WHERE budget = 25000 OR status = 'On Hold';

SELECT project_name, budget
FROM projects
WHERE budget NOT IN (25000, 45000);

SELECT project_name || ' ' || budget * 1.05 AS "Project Raise"
FROM projects
WHERE status IN ('Active','On Hold')
  AND project_name LIKE 'C%'
   OR project_name LIKE '%s%';

SELECT project_name || ' ' || budget * 1.05 AS "Project Raise",
       status,
       start_date
FROM projects
WHERE status IN ('Active','On Hold')
  AND project_name LIKE 'C%'
   OR project_name LIKE '%s%';

SELECT project_name || ' ' || budget * 1.05 AS "Project Raise",
       status,
       start_date
FROM projects
WHERE status IN ('Active','On Hold')
   OR project_name LIKE 'C%'
  AND project_name LIKE '%s%';

  SELECT project_name || ' ' || budget * 1.05 AS "Project Raise",
       status,
       start_date
FROM projects
WHERE (status IN ('Active','On Hold') OR project_name LIKE 'C%')
  AND project_name LIKE '%s%';



-- ====================================
DROP TABLE IF EXISTS products_inventory;

CREATE TABLE products_inventory (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(100) NOT NULL,
    category        VARCHAR(50),
    price           NUMERIC(10,2),
    stock_quantity  INT,
    supplier        VARCHAR(100),
    arrival_date    DATE
);

-- ===========================
INSERT INTO products_inventory (product_name, category, price, stock_quantity, supplier, arrival_date)
VALUES
('Laptop Empresarial 15"', 'Electrónica', 1200.00, 30, 'TechSource', '2024-03-15'),
('Silla Ejecutiva Premium', 'Muebles', 150.00, 100, 'ComfortCo', '2024-02-10'),
('Mouse Gamer Catracho', 'Electrónica', 45.99, 200, 'GadgetWorld', '2024-04-01'),
('Escritorio Ergonómico Altura Ajustable', 'Muebles', 320.00, 50, 'ErgoSupply', '2024-01-20'),
('Monitor LED 27" Full HD', 'Electrónica', 280.00, 75, 'VisionTech', '2024-02-25');

-- ===========================

-- ===========================
SELECT product_name, price
FROM products_inventory
WHERE category = 'Electrónica' AND price > 100;

-- ===========================
SELECT product_name, stock_quantity
FROM products_inventory
WHERE stock_quantity < 80;

-- ===========================
SELECT product_name, arrival_date
FROM products_inventory
WHERE arrival_date > DATE '2024-03-01';

-- ===========================
SELECT product_name, category
FROM products_inventory
WHERE product_name LIKE '%Desk%';

-- ===========================
SELECT product_name || ' - New Price: ' || price * 1.05 AS "Price Update"
FROM products_inventory;

SELECT product_name, arrival_date
FROM products_inventory
ORDER BY arrival_date;

SELECT product_name, arrival_date
FROM products_inventory
ORDER BY arrival_date DESC;

SELECT product_name, arrival_date AS "Date Arrived"
FROM products_inventory
ORDER BY "Date Arrived";

SELECT product_id,
       product_name
FROM products_inventory
WHERE product_id < 5
ORDER BY category;

SELECT category, product_name
FROM products_inventory
WHERE category <= 'Muebles'
ORDER BY category, product_name;

SELECT category, product_name
FROM products_inventory
WHERE category <= 'Muebles'
ORDER BY category DESC, product_name;
