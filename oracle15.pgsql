-- ==============================
DROP VIEW IF EXISTS view_employees;
DROP VIEW IF EXISTS view_euro_countries;
DROP VIEW IF EXISTS view_high_pop;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS wf_countries CASCADE;
DROP TABLE IF EXISTS wf_world_regions CASCADE;
-- ==============================
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    email       VARCHAR(100)
);

CREATE TABLE wf_countries (
    country_id   INT PRIMARY KEY,
    region_id    INT,
    country_name VARCHAR(100),
    capitol      VARCHAR(100),
    location     VARCHAR(100),
    population   BIGINT
);

CREATE TABLE wf_world_regions (
    region_id   INT PRIMARY KEY,
    region_name VARCHAR(100)
);
-- ==============================
INSERT INTO employees (employee_id, first_name, last_name, email) VALUES
(100, 'Elvin',     'Amador',    'EAMADOR'),
(101, 'Yessenia',  'Rosales',   'YROSALES'),
(102, 'Edgar',     'Amador',    'EAMADOR2'),
(103, 'Darlin',    'Zepeda',    'DZEPEDA'),
(104, 'Karla',     'Oseguera',  'KOSEGUERA'),
(107, 'Gerson',    'Orellana',  'GORELLANA');

INSERT INTO wf_countries (country_id, region_id, country_name, capitol, location, population) VALUES
(22,  155, 'Bailía de Guernsey',     'Saint Peter Port', 'Europa Occidental',     188078227),
(203, 155, 'Bailía de Jersey',       'Saint Helier',     'Europa Occidental',      20264082),
(387, 39,  'Bosnia y Herzegovina',   'Sarajevo',         'Europa Oriental',       131859731),
(420, 151, 'Chequia',                'Praga',            'Europa Central',        107449525),
(298, 154, 'Islas Feroe',            'Tórshavn',         'Europa Septentrional',   74777981),
(33,  155, 'República Francesa',     'París',            'Europa Occidental',     298444215);

INSERT INTO wf_world_regions (region_id, region_name) VALUES
(151, 'Europa Central'),
(154, 'Europa Oriental'),
(155, 'Europa Occidental');
-- ==============================
CREATE OR REPLACE VIEW view_employees AS
SELECT employee_id, first_name, last_name, email
FROM employees
WHERE employee_id BETWEEN 100 AND 124;

CREATE OR REPLACE VIEW view_euro_countries AS
SELECT 
    c.country_id   AS "ID",
    c.country_name AS "País",
    c.capitol      AS "Capital",
    r.region_name  AS "Región"
FROM wf_countries c
JOIN wf_world_regions r USING (region_id)
WHERE c.location ILIKE '%Europa%';

CREATE OR REPLACE VIEW view_high_pop AS
SELECT 
    region_id AS "ID de Región",
    MAX(population) AS "Población más alta"
FROM wf_countries
GROUP BY region_id;
-- ==============================
SELECT * FROM view_employees;
SELECT * FROM view_euro_countries;
SELECT * FROM view_high_pop;
-- ==============================
DROP VIEW IF EXISTS view_dept50 CASCADE;
DROP VIEW IF EXISTS view_dept50_check CASCADE;
DROP VIEW IF EXISTS view_dept50_readonly CASCADE;
DROP TABLE IF EXISTS copy_employees CASCADE;
-- ==============================
CREATE TABLE copy_employees (
    department_id INT,
    employee_id   INT PRIMARY KEY,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    salary        NUMERIC(10,2),
    hire_date     DATE
);
-- ==============================
INSERT INTO copy_employees (department_id, employee_id, first_name, last_name, salary, hire_date) VALUES
(50, 124, 'Edgar',    'Amador',    5800, '2000-06-17'),
(50, 141, 'Yamileth', 'Pineda',    3500, '2002-09-17'),
(50, 142, 'Darwin',   'Banegas',   3100, '2001-09-21'),
(50, 143, 'Leticia',  'Orellana',  2600, '2001-01-03'),
(50, 144, 'Elvin',    'Amador',    2500, '2001-05-21'),
(60, 150, 'Kenia',    'Fúnez',     4000, '1998-01-10'),
(60, 151, 'Luis',     'Cabrera',   4500, '1997-07-15');
-- ==============================
CREATE OR REPLACE VIEW view_dept50 AS
SELECT department_id, employee_id, first_name, last_name, salary
FROM copy_employees
WHERE department_id = 50;
-- ==============================
CREATE OR REPLACE VIEW view_dept50_check AS
SELECT department_id, employee_id, first_name, last_name, salary
FROM copy_employees
WHERE department_id = 50;
-- ==============================
CREATE OR REPLACE RULE view_dept50_check_update AS
ON UPDATE TO view_dept50_check
WHERE NEW.department_id <> 50
DO INSTEAD NOTHING;
-- ==============================
CREATE OR REPLACE VIEW view_dept50_readonly AS
SELECT department_id, employee_id, first_name, last_name, salary
FROM copy_employees
WHERE department_id = 50;

CREATE OR REPLACE RULE view_dept50_readonly_insert AS
ON INSERT TO view_dept50_readonly DO INSTEAD NOTHING;
CREATE OR REPLACE RULE view_dept50_readonly_update AS
ON UPDATE TO view_dept50_readonly DO INSTEAD NOTHING;
CREATE OR REPLACE RULE view_dept50_readonly_delete AS
ON DELETE TO view_dept50_readonly DO INSTEAD NOTHING;
-- ==============================
CREATE OR REPLACE VIEW view_max_salary AS
SELECT e.last_name, e.salary, e.department_id, d.maxsal
FROM copy_employees e
JOIN (
    SELECT department_id, MAX(salary) AS maxsal
    FROM copy_employees
    GROUP BY department_id
) d ON e.department_id = d.department_id
AND e.salary = d.maxsal;
-- ==============================
CREATE OR REPLACE VIEW view_top5_longest_employed AS
SELECT last_name, hire_date
FROM copy_employees
ORDER BY hire_date ASC
LIMIT 5;
-- ==============================
SELECT * FROM view_dept50;
SELECT * FROM view_dept50_check;
SELECT * FROM view_dept50_readonly;
SELECT * FROM view_max_salary;
SELECT * FROM view_top5_longest_employed;
-- ==============================