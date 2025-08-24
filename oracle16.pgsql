-- ================================
CREATE TABLE sequence_audit_log (
    id SERIAL PRIMARY KEY,
    sequence_name TEXT NOT NULL,
    min_value BIGINT,
    max_value BIGINT,
    increment_by INT,
    last_value BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- ================================
SELECT 
    schemaname   AS sequence_schema,
    sequencename AS sequence_name,
    start_value,
    increment_by,
    min_value,
    max_value,
    cycle,
    cache_size,
    last_value
FROM pg_sequences
WHERE sequencename = 'runner_id_seq';
-- ================================
INSERT INTO sequence_audit_log (sequence_name, min_value, max_value, increment_by, last_value)
SELECT 
    sequencename,
    min_value,
    max_value,
    increment_by,
    last_value
FROM pg_sequences
WHERE sequencename = 'runner_id_seq';
-- ================================
CREATE TABLE race_runners (
    runner_id  INTEGER PRIMARY KEY,
    first_name VARCHAR(30),
    last_name  VARCHAR(30)
);
-- ================================
CREATE SEQUENCE runner_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 50000
    NO CYCLE
    CACHE 1;
-- ================================
INSERT INTO race_runners (runner_id, first_name, last_name)
VALUES (NEXTVAL('runner_id_seq'), 'Elvin',   'Amador');

INSERT INTO race_runners (runner_id, first_name, last_name)
VALUES (NEXTVAL('runner_id_seq'), 'Karla',   'Zepeda');
-- ================================
SELECT runner_id, first_name, last_name
FROM race_runners;
-- ================================
SELECT 
    sequencename AS sequence_name,
    min_value,
    max_value,
    last_value AS "Próximo número"
FROM pg_sequences
WHERE sequencename = 'runner_id_seq';
-- ================================
ALTER SEQUENCE runner_id_seq
    INCREMENT BY 1
    MAXVALUE 999999
    CACHE 1
    NO CYCLE;
-- ================================
CREATE TABLE employee_log (
    employee_id   INTEGER,
    department_id INTEGER,
    description   TEXT
);
-- ================================
CREATE SEQUENCE employees_seq START 1000;
CREATE SEQUENCE dept_deptid_seq START 500;
-- ================================
SELECT NEXTVAL('dept_deptid_seq'); 
-- ================================
INSERT INTO employee_log (employee_id, department_id, description)
VALUES (
    NEXTVAL('employees_seq'),
    CURRVAL('dept_deptid_seq'),
    'Nuevo empleado insertado desde ejemplo'
);
-- ================================
SELECT * FROM employee_log;
-- ================================
DROP TABLE IF EXISTS country_demo;
DROP INDEX IF EXISTS idx_country_region;
DROP INDEX IF EXISTS idx_country_name_capitol;
DROP INDEX IF EXISTS idx_upper_country_name;
DROP INDEX IF EXISTS idx_hire_year;
-- ================================
CREATE TABLE country_demo (
    country_id   INTEGER PRIMARY KEY,
    country_name VARCHAR(100),
    capitol      VARCHAR(100),
    region_id    INTEGER
);
-- ================================
INSERT INTO country_demo (country_id, country_name, capitol, region_id) VALUES
(1,  'Estados Unidos de América',        'Washington D. C.', 21),
(2,  'Canadá',                           'Ottawa',           21),
(3,  'República de Kazajistán',          'Astaná',          143),
(7,  'Federación de Rusia',              'Moscú',           151),
(12, 'Territorio de las Islas del Mar del Coral', NULL,      9),
(13, 'Islas Cook',                       'Avarua',           9),
(15, 'Isla Europa',                      NULL,              18),
(20, 'República Árabe de Egipto',        'El Cairo',        15);

DROP INDEX IF EXISTS idx_country_region;
DROP INDEX IF EXISTS idx_country_name_capitol;

CREATE INDEX idx_country_region
ON country_demo(region_id);

CREATE INDEX idx_country_name_capitol
ON country_demo(country_name, capitol);
-- ================================
SELECT
    tablename AS table_name,
    indexname AS index_name,
    indexdef  AS definition
FROM pg_indexes
WHERE tablename = 'country_demo';
-- ================================
CREATE INDEX idx_upper_country_name
ON country_demo (UPPER(country_name));
-- ================================
SELECT *
FROM country_demo
WHERE UPPER(country_name) = 'CANADÁ';
-- ================================
DROP TABLE IF EXISTS employee_demo;
CREATE TABLE employee_demo (
    employee_id SERIAL PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    hire_date   DATE
);
-- ================================
INSERT INTO employee_demo (first_name, last_name, hire_date) VALUES
('Elvin',   'Amador',   '1987-06-17'),
('Jennifer','Whalen',   '1987-09-17'),
('Yessenia','Rosales',  '1990-05-10');
-- ================================
CREATE INDEX idx_hire_year
ON employee_demo (EXTRACT(YEAR FROM hire_date));
-- ================================
SELECT first_name, last_name, hire_date
FROM employee_demo
WHERE EXTRACT(YEAR FROM hire_date) = 1987;
