-- ================================
DROP TABLE IF EXISTS team_members;

CREATE TABLE team_members (
    member_id  SERIAL PRIMARY KEY,
    full_name  VARCHAR(100),
    role_code  VARCHAR(20)
);

-- ================================
DROP TABLE IF EXISTS roles_catalog;

CREATE TABLE roles_catalog (
    role_code   VARCHAR(20) PRIMARY KEY,
    role_title  VARCHAR(100)
);

-- ================================
INSERT INTO roles_catalog (role_code, role_title) VALUES
('DIR_GEN',  'Director General'),
('DIR_ADM',  'Director Administrativo'),
('ANL_MKT',  'Analista de Mercadeo'),
('MNG_LOG',  'Gerente de Logística'),
('CNT_GEN',  'Contador General'),
('SLS_JR',   'Ejecutivo de Ventas Junior');

-- ================================
INSERT INTO team_members (full_name, role_code) VALUES
('Carlos Banegas',   'DIR_GEN'),
('Marlen Oseguera',  'DIR_ADM'),
('Edwin Perdomo',    'ANL_MKT'),
('Yessenia Fúnez',   'MNG_LOG'),
('Darwin Amador',    'CNT_GEN'),
('Karla Zepeda',     'SLS_JR');

SELECT full_name, 
       team_members.role_code, 
       role_title
FROM team_members
NATURAL JOIN roles_catalog
WHERE member_id > 3;


SELECT full_name,
       team_members.role_code,
       role_title
FROM team_members
NATURAL JOIN roles_catalog
WHERE member_id > 3;

SELECT role_title AS department_name,
       full_name   AS city
FROM team_members
NATURAL JOIN roles_catalog;

SELECT full_name,
       role_title AS department_name
FROM team_members
CROSS JOIN roles_catalog;

SELECT full_name,
       team_members.role_code AS department_id,
       role_title             AS department_name
FROM team_members
JOIN roles_catalog USING (role_code);

SELECT full_name,
       team_members.role_code AS department_id,
       role_title             AS department_name
FROM team_members
JOIN roles_catalog USING (role_code)
WHERE full_name LIKE '%Higgins';

SELECT full_name AS last_name,
       role_title AS job_title
FROM team_members e
JOIN roles_catalog j
ON (e.role_code = j.role_code);

SELECT full_name AS last_name,
       role_title AS job_title
FROM team_members e
JOIN roles_catalog j
  ON (e.role_code = j.role_code)
WHERE full_name LIKE 'H%';

DROP TABLE IF EXISTS salary_grades;

CREATE TABLE salary_grades (
    grade_level  VARCHAR(10),
    lowest_sal   NUMERIC(10,2),
    highest_sal  NUMERIC(10,2)
);

-- ================================
INSERT INTO salary_grades (grade_level, lowest_sal, highest_sal) VALUES
('A', 0,    2999),
('B', 3000, 4999),
('C', 5000, 7999),
('D', 8000, 9999);


SELECT staff_name AS last_name,
       salary,
       CASE
            WHEN salary BETWEEN 0    AND 2999 THEN 'Grade A'
            WHEN salary BETWEEN 3000 AND 4999 THEN 'Grade B'
            WHEN salary BETWEEN 5000 AND 9999 THEN 'Grade C'
            ELSE 'Grade D'
       END AS grade_level,
       0    AS lowest_sal,
       9999 AS highest_sal
FROM company_staff;

-- ================================
DROP TABLE IF EXISTS locations;
CREATE TABLE locations (
    location_id  SERIAL PRIMARY KEY,
    city         VARCHAR(50)
);

INSERT INTO locations (city) VALUES
('New York'), ('Chicago'), ('San Francisco');

-- ================================
DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
    department_id   SERIAL PRIMARY KEY,
    department_name VARCHAR(50),
    location_id     INT REFERENCES locations(location_id)
);

INSERT INTO departments (department_name, location_id) VALUES
('Sales', 1), ('IT', 2), ('Finance', 3);

-- ================================
UPDATE company_staff SET department_id = 1 WHERE staff_id IN (1, 2);
UPDATE company_staff SET department_id = 2 WHERE staff_id = 3;
UPDATE company_staff SET department_id = 3 WHERE staff_id IN (4, 5);

SELECT staff_name AS last_name,
       department_name AS "Department",
       city
FROM company_staff
JOIN departments USING (department_id)
JOIN locations USING (location_id);

SELECT e.staff_name AS last_name,
       d.department_id,
       d.department_name
FROM company_staff e
LEFT JOIN departments d
  ON e.department_id = d.department_id;

  SELECT e.staff_name AS last_name, d.department_id,
       d.department_name
FROM company_staff e LEFT OUTER JOIN
     departments d
ON (e.department_id = d.department_id);

SELECT e.staff_name AS last_name, d.department_id,
       d.department_name
FROM company_staff e RIGHT OUTER JOIN
     departments d
ON (e.department_id = d.department_id);

SELECT e.staff_name AS last_name, d.department_id, d.department_name
FROM company_staff e FULL OUTER JOIN departments d
ON (e.department_id = d.department_id);


DROP TABLE IF EXISTS business_units;

CREATE TABLE business_units (
    unit_id   SERIAL PRIMARY KEY,
    unit_name VARCHAR(100) NOT NULL,
    site_id   INT
);

-- ================================
INSERT INTO business_units (unit_name, site_id) VALUES
('Innovation', 1),
('Customer Care', 2),
('Distribution', 3);

-- ================================
CREATE TABLE IF NOT EXISTS productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    fecha_ingreso DATE DEFAULT CURRENT_DATE
);

-- ================================
INSERT INTO productos (nombre, categoria, precio, stock)
VALUES 
('Laptop Empresarial Dell Latitude', 'Electrónica', 1180.75, 10),
('Teléfono Huawei P50 Pro', 'Electrónica', 920.00, 15),
('Audífonos Inalámbricos Xiaomi Redmi Buds 4', 'Accesorios', 48.99, 40),
('Silla Ergonómica Reclinable Pro', 'Muebles', 275.50, 5),
('Teclado Gamer Logitech G213', 'Accesorios', 52.00, 25),
('Monitor Samsung Odyssey G5 27"', 'Electrónica', 310.00, 8),
('Impresora Epson EcoTank L3250', 'Oficina', 195.00, 12),
('Escritorio Metálico con Vidrio 120cm', 'Muebles', 160.25, 7),
('Cámara Nikon D7500', 'Fotografía', 1290.00, 4),
('Mochila Antirrobo Tigernu', 'Accesorios', 68.00, 20);

-- ================================
SELECT * FROM productos;







