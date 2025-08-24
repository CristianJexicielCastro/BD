
-- ================================
DROP TABLE IF EXISTS student_courses;

-- ================================
CREATE TABLE student_courses (
    student_id      SERIAL PRIMARY KEY,
    student_name    VARCHAR(100) NOT NULL,
    course_name     VARCHAR(100) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    grade           NUMERIC(4,2)
);

-- ================================
INSERT INTO student_courses (student_name, course_name, start_date, end_date, grade)
VALUES
('Karla Amador', 'Contabilidad', '2024-01-10', '2024-06-15', 88.50),
('Josué Banegas', 'Historia de Honduras', '2024-02-01', '2024-07-01', 91.20),
('Yessenia Perdomo', 'Desarrollo de Software', '2024-03-12', NULL, NULL),
('Gerson Fúnez', 'Física Aplicada', '2024-01-20', '2024-05-30', 85.00),
('Dilcia Oseguera', 'Química Industrial', '2024-02-15', NULL, NULL);

SELECT TO_CHAR(CURRENT_TIMESTAMP, 'DD-Mon-YYYY HH24:MI:SS');

SELECT TO_CHAR(start_date, 'Month DD, YYYY') AS formatted_date
FROM student_courses;

SELECT TO_CHAR(start_date, 'FMMonth DD, YYYY') AS formatted_date
FROM student_courses;

SELECT TO_CHAR(start_date, 'FMMonth DDth, YYYY') AS formatted_date
FROM student_courses;

SELECT TO_CHAR(start_date, 'FMDay DDth Mon, YYYY') AS formatted_date
FROM student_courses;

SELECT TO_CHAR(start_date, 'FMDay DDth Mon, YYYY') AS formatted_date
FROM student_courses;

SELECT TO_CHAR(start_date, 'FMDay, DDth "of" Month, YYYY') AS formatted_date
FROM student_courses;

SELECT TO_CHAR(CURRENT_TIMESTAMP, 'HH12:MI') AS current_time;

SELECT TO_CHAR(CURRENT_TIMESTAMP, 'HH12:MI PM') AS current_time;

SELECT TO_CHAR(CURRENT_TIMESTAMP, 'HH12:MI:SS am') AS current_time;

SELECT TO_CHAR(12345.678, '99,999.99') AS formatted_number;

SELECT TO_CHAR(grade, '$99,999') AS "Salary"
FROM student_courses
WHERE grade IS NOT NULL;

SELECT TO_CHAR(3000, '$99999.99') AS formatted_value;

SELECT TO_CHAR(4500, '99,999') AS formatted_value;

SELECT TO_CHAR(9000, '99,999.99') AS formatted_value;

SELECT TO_CHAR(4422, '0,009,999') AS formatted_value;

SELECT TO_NUMBER('12345', '99999') AS num;

SELECT TO_NUMBER('5,320', '9,999') AS "Number";

DROP TABLE IF EXISTS staff_info;

CREATE TABLE staff_info (
    staff_name     VARCHAR(50),
    bonus_text     VARCHAR(10),
    department_id  INT
);

INSERT INTO staff_info (staff_name, bonus_text, department_id) VALUES
('Amador', '100', 80),
('Oseguera', '250', 80),
('Banegas',  '150', 50),
('Fúnez',  '075', 80);

SELECT staff_name,
       TO_NUMBER(bonus_text, '999') AS bonus_number
FROM staff_info
WHERE department_id = 80;

DROP TABLE IF EXISTS hr_staff;

CREATE TABLE hr_staff (
    last_name      VARCHAR(50),
    bonus          VARCHAR(10),
    department_id  INT
);

-- ================================
INSERT INTO hr_staff (last_name, bonus, department_id) VALUES
('Amador', '100', 80),
('Oseguera', '250', 80),
('Banegas',  '075', 80),
('Fúnez',  '150', 50);

SELECT last_name,
       TO_NUMBER(bonus, '9999') AS "Bonus"
FROM hr_staff
WHERE department_id = 80;

-- ================================
SELECT TO_DATE('15-08-2025', 'DD-MM-YYYY');

-- ================================
SELECT TO_DATE('08/15/2025', 'MM/DD/YYYY');

-- ================================
SELECT TO_DATE('15-Aug-2025', 'DD-Mon-YYYY');

SELECT TO_DATE('May10,1989', 'MonDD,YYYY') AS "Convert";

SELECT TO_DATE('27-Oct-95', 'DD-Mon-YY') AS "Date";

SELECT TO_DATE('27-Oct-95','DD-Mon-RR') AS "Date";

DROP TABLE IF EXISTS work_staff;

CREATE TABLE work_staff (
    employee_id   INT PRIMARY KEY,
    employee_name VARCHAR(100),
    hire_date     DATE
);

-- ================================
INSERT INTO work_staff (employee_id, employee_name, hire_date) VALUES
(100, 'Karla Amador', '2023-06-15'),
(101, 'Yessenia Perdomo', '2022-03-10'),
(102, 'Dilcia Oseguera', '2024-01-20');

SELECT employee_name,
       TO_CHAR(
         -- ================================
         (hire_date + INTERVAL '6 months')
         +
         -- ================================
         ((5 - EXTRACT(DOW FROM (hire_date + INTERVAL '6 months')) + 7) % 7) * INTERVAL '1 day',
         'FMDay, Month DDth, YYYY'
       ) AS "Next Evaluation"
FROM work_staff
WHERE employee_id = 100;

SELECT TO_CHAR(
         (hire_date + INTERVAL '6 months')
         +
         ((5 - EXTRACT(DOW FROM (hire_date + INTERVAL '6 months')) + 7) % 7) * INTERVAL '1 day',
         'FMDay, Month DDth, YYYY'
       ) AS "Next Evaluation"
FROM work_staff
WHERE employee_id = 100;

SELECT COALESCE(NULL, 'Valor por defecto');
-- ================================

DROP TABLE IF EXISTS company_staff;

CREATE TABLE company_staff (
    staff_id        SERIAL PRIMARY KEY,
    staff_name      VARCHAR(100) NOT NULL,
    position        VARCHAR(50),
    hire_date       DATE NOT NULL,
    salary          NUMERIC(10,2),
    commission_pct  NUMERIC(4,2),
    department_id   INT
);

-- ================================
INSERT INTO company_staff (staff_name, position, hire_date, salary, commission_pct, department_id) VALUES
('Karla Amador',    'Gerente de Operaciones',  '2018-06-10', 5500.00, NULL, 80),
('Josué Banegas',  'Ejecutivo de Ventas', '2020-02-18', 3000.00, 0.15, 80),
('Yamileth Pineda',   'Analista de Sistemas',  '2019-09-12', 4200.00, NULL, 90),
('JDarwin Banegas',   'Auxiliar Administrativo',    '2021-01-25', 2800.00, NULL, 50),
('Laura Díaz',    'Asesora Comercial', '2022-04-30', 3100.00, 0.10, 80);

SELECT staff_name,
       COALESCE(commission_pct, 0) * 250 AS "Commission"
FROM company_staff
WHERE department_id IN (80, 90);

SELECT staff_name,
       salary,
       CASE 
           WHEN commission_pct IS NOT NULL 
                THEN salary + (salary * commission_pct)
           ELSE salary
       END AS income
FROM company_staff
WHERE department_id IN (80, 90);

SELECT 
    split_part(staff_name, ' ', 1) AS first_name,
    LENGTH(split_part(staff_name, ' ', 1)) AS "Length FN",
    split_part(staff_name, ' ', 2) AS last_name,
    LENGTH(split_part(staff_name, ' ', 2)) AS "Length LN",
    NULLIF(
        LENGTH(split_part(staff_name, ' ', 1)), 
        LENGTH(split_part(staff_name, ' ', 2))
    ) AS "Compare Them"
FROM company_staff;

SELECT staff_name,
       COALESCE(commission_pct, salary, 10) AS "Comm"
FROM company_staff
ORDER BY commission_pct;


SELECT staff_name,
       CASE department_id
            WHEN 80 THEN 'Sales'
            WHEN 90 THEN 'Management'
            ELSE 'Other'
       END AS department_type
FROM company_staff;

SELECT staff_name,
       CASE department_id
            WHEN 90 THEN 'Management'
            WHEN 80 THEN 'Sales'
            WHEN 60 THEN 'IT'
            ELSE 'Other dept.'
       END AS "Department"
FROM company_staff;

SELECT staff_name,
       CASE department_id
            WHEN 90 THEN 'Management'
            WHEN 80 THEN 'Sales'
            WHEN 60 THEN 'IT'
            ELSE 'Other dept.'
       END AS department_type
FROM company_staff;

SELECT staff_name,
       CASE department_id
            WHEN 90 THEN 'Management'
            WHEN 80 THEN 'Sales'
            WHEN 60 THEN 'IT'
            ELSE 'Other dept.'
       END AS "Department"
FROM company_staff;































