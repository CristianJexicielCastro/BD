-- ===========================
DROP TABLE IF EXISTS table_data;
-- ===========================
CREATE TABLE table_data (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    hire_date DATE,
    department_id INT,
    height NUMERIC(5,2) 
);
-- ===========================
INSERT INTO table_data (first_name, last_name, hire_date, department_id, height) VALUES
('Elvin',    'Amador',   '2000-01-01', 1, 1.75),
('Yessenia', 'Rosales',  '2000-01-29', 1, 1.68),
('Darlin',   'Zepeda',   '1999-05-24', NULL, 1.70),
('Neptaly',  'Oseguera', '1999-11-16', 2, 1.80),
('Gerson',   'Banegas',  '1999-02-07', 2, 1.60),
('Karla',    'Zepeda',   '2001-03-12', 1, 1.74),
('Edgar',    'Amador',   '2001-07-19', 3, 1.65);
-- ===========================
SELECT first_name, last_name, hire_date
FROM table_data
WHERE hire_date > ALL (
  SELECT hire_date
  FROM table_data
  WHERE last_name = 'Amador'
);
-- ===========================
SELECT first_name, last_name, hire_date
FROM table_data
WHERE hire_date > ALL (
  SELECT hire_date
  FROM table_data
  WHERE last_name = 'Zepeda'
);
-- ===========================
SELECT first_name, last_name, hire_date
FROM table_data
WHERE hire_date > ALL (
  SELECT hire_date
  FROM table_data
  WHERE last_name = 'Zepeda'
);
-- ===========================
DROP TABLE IF EXISTS staff_data;
DROP TABLE IF EXISTS division_data;
-- ===========================
CREATE TABLE division_data (
    division_id SERIAL PRIMARY KEY,
    division_name VARCHAR(50),
    region_id INT
);
-- ===========================
CREATE TABLE staff_data (
    staff_id SERIAL PRIMARY KEY,
    surname VARCHAR(50),
    role_code VARCHAR(20),
    income NUMERIC(10,2),
    division_id INT,
    hire_date DATE,
    FOREIGN KEY (division_id) REFERENCES division_data(division_id)
);
-- ===========================
INSERT INTO division_data (division_name, region_id) VALUES
('Marketing', 1000),
('IT', 1500),
('Finance', 1500);
-- ===========================
INSERT INTO staff_data (surname, role_code, income, division_id, hire_date) VALUES
('Amador', 'MK_MAN', 13000, 1, '2000-01-01'),
('Rosales', 'MK_REP', 6000, 1, '2001-02-15'),
('Zepeda', 'ST_CLERK', 3500, 2, '2002-03-10'),
('Oseguera', 'ST_CLERK', 3100, 2, '2002-04-12'),
('Banegas', 'ST_CLERK', 2600, 2, '2002-05-18'),
('Zelaya', 'ST_CLERK', 2500, 2, '2002-06-25'),
('Fúnez', 'AD_ASST', 4400, 3, '1999-11-10'),
('Perdomo', 'AC_ACCOUNT', 8300, 3, '1998-10-10'),
('Orellana', 'AC_MGR', 8600, 3, '1997-09-05'),
('Pineda', 'SA_REP', 7000, 3, '2003-08-20'),
('Aguilar', 'IT_PROG', 5800, 3, '2001-12-01'),
('Mejía', 'HR_REP', 6000, 3, '2001-06-30'),
('Castro', 'PU_CLERK', 4200, 3, '1999-07-19'),
('Zepeda', 'HR_REP', 6000, 3, '2001-01-01');

SELECT surname, role_code, division_id
FROM staff_data
WHERE division_id = (
    SELECT division_id
    FROM division_data
    WHERE division_name = 'Marketing'
)
ORDER BY role_code;
-- ===========================
SELECT surname, role_code, division_id
FROM staff_data
WHERE division_id IN (
    SELECT division_id
    FROM division_data
    WHERE division_name = 'Marketing'
)
ORDER BY role_code;
-- ===========================
SELECT surname, role_code, income, division_id
FROM staff_data
WHERE role_code = (
    SELECT role_code
    FROM staff_data
    WHERE staff_id = 1
    LIMIT 1       
)
AND division_id IN (
    SELECT division_id
    FROM division_data
    WHERE region_id = 1500
);
-- ===========================
DROP TABLE IF EXISTS staff_data;
DROP TABLE IF EXISTS area_data;
-- ===========================
CREATE TABLE area_data (
    area_id SERIAL PRIMARY KEY,
    area_name VARCHAR(50),
    region_id INT
);
-- ===========================
CREATE TABLE staff_data (
    staff_id SERIAL PRIMARY KEY,
    surname VARCHAR(50),
    role_code VARCHAR(20),
    income INT,
    area_id INT,
    hire_date DATE,
    manager_id INT
);
-- ===========================
INSERT INTO area_data (area_name, region_id) VALUES
('Marketing', 1500),
('IT', 1600),
('HR', 1700);

INSERT INTO staff_data (surname, role_code, income, area_id, hire_date, manager_id) VALUES
('Amador',   'MK_DIR',   13000, 1, '2000-01-01', NULL),
('Rosales',  'MK_ASST',   6000, 1, '2001-02-01', NULL),
('Zepeda',   'ST_SUP',    3500, 2, '2002-03-15', 100),
('Oseguera', 'ST_ASST',   3100, 2, '2003-04-20', 101),
('Banegas',  'ST_OPER',   2600, 2, '2003-05-25', NULL),
('Zelaya',   'ST_AUX',    2500, 2, '2003-06-30', 102),
('Pineda',   'SA_ASST',   7000, 3, '2003-08-20', NULL),
('Aguilar',  'IT_DEV',    5800, 3, '2001-12-01', 101),
('Mejía',    'HR_ASST',   6000, 3, '2001-06-30', 205),
('Castro',   'PU_ASST',   4200, 3, '1999-07-19', 100),
('Zepeda',   'HR_AUX',    6000, 3, '2001-01-01', NULL);    
-- ===========================
SELECT surname, role_code, area_id
FROM staff_data
WHERE area_id = (
    SELECT area_id
    FROM area_data
    WHERE area_name = 'Marketing'
)
ORDER BY role_code;
-- ===========================
SELECT surname, role_code, income, area_id
FROM staff_data
WHERE role_code = (
    SELECT role_code
    FROM staff_data
    WHERE staff_id = 1
)
AND area_id = (
    SELECT area_id
    FROM area_data
    WHERE region_id = 1500
);
-- ===========================
SELECT surname, income
FROM staff_data
WHERE income < (
    SELECT AVG(income)
    FROM staff_data
);
-- ===========================
SELECT area_id, MIN(income)
FROM staff_data
GROUP BY area_id
HAVING MIN(income) > (
    SELECT MIN(income)
    FROM staff_data
    WHERE area_id = 2
);
-- ===========================
DROP TABLE IF EXISTS staff_info;
DROP TABLE IF EXISTS dept_info;
-- ===========================
CREATE TABLE dept_info (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50),
    region_id INT
);

CREATE TABLE staff_info (
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    job_code VARCHAR(20),
    manager_id INT,
    dept_id INT,
    salary NUMERIC(10,2),
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES dept_info(dept_id)
);
-- ===========================
INSERT INTO dept_info (dept_name, region_id) VALUES
('Marketing', 1500),
('IT', 1200),
('HR', 1100);

INSERT INTO staff_info (first_name, last_name, job_code, manager_id, dept_id, salary, hire_date) VALUES
('Elvin',     'Amador',   'IT_DEV',    100, 2, 4400, '1987-06-17'),
('Edgar',     'Rosales',  'IT_DEV',    100, 2, 13000, '1990-01-03'),
('Karla',     'Oseguera', 'IT_DEV',    149, 2, 6000, '1991-09-21'),
('Darlin',    'Pineda',   'SA_ASST',   149, 1, 7000, '1989-09-21'),
('Yessenia',  'Banegas',  'HR_ASST',   100, 3, 6000, '1993-09-13'),
('Neptaly',   'Zelaya',   'SA_ASST',   101, 1, 3500, '1991-05-21'),
('Gerson',    'Orellana', 'ST_SUP',    205, 2, 3100, '1990-09-21');
-- ===========================
SELECT dept_id, MIN(salary)
FROM staff_info
GROUP BY dept_id
HAVING MIN(salary) < ANY (
    SELECT salary
    FROM staff_info
    WHERE dept_id IN (1, 2)
)
ORDER BY dept_id;
-- ===========================
SELECT staff_id, manager_id, dept_id
FROM staff_info
WHERE (manager_id, dept_id) IN (
    SELECT manager_id, dept_id
    FROM staff_info
    WHERE staff_id IN (2, 3)
)
AND staff_id NOT IN (2, 3);
-- ===========================
SELECT staff_id, manager_id, dept_id
FROM staff_info
WHERE manager_id IN (
        SELECT manager_id FROM staff_info WHERE staff_id IN (2, 3)
      )
  AND dept_id IN (
        SELECT dept_id FROM staff_info WHERE staff_id IN (2, 3)
      )
  AND staff_id NOT IN (2, 3);
-- ===========================
SELECT first_name, last_name, job_code
FROM staff_info
WHERE job_code IN (
    SELECT job_code
    FROM staff_info
    WHERE last_name = 'Ernst'
);
-- ===========================
DROP TABLE IF EXISTS staff_data;

CREATE TABLE staff_data (
    id_worker SERIAL PRIMARY KEY,
    surname VARCHAR(50) NOT NULL,
    role_code VARCHAR(10) NOT NULL,
    income NUMERIC(10,2) NOT NULL,
    division_id INT NOT NULL,
    boss_id INT NULL,
    hire_date DATE NOT NULL
);
-- ===========================
INSERT INTO staff_data (surname, role_code, income, division_id, boss_id, hire_date) VALUES
('Amador',   'SA_ASST',   7000, 1, NULL, '2019-05-20'),
('Rosales',  'IT_DEV',    5800, 1, 1,    '2020-01-10'),
('Zepeda',   'HR_ASST',   6000, 2, NULL, '2021-07-12'),
('Oseguera', 'PU_ASST',   4200, 2, 3,    '2022-03-25'),
('Banegas',  'MK_DIR',    9000, 3, NULL, '2021-02-14'),
('Zelaya',   'MK_ASST',   5000, 3, 5,    '2023-11-01'),
('Fúnez',    'FI_ANAL',   8200, 4, NULL, '2020-04-18'),
('Orellana', 'FI_CLERK',  3000, 4, 7,    '2022-10-30');
-- ===========================
SELECT s.surname, s.income, s.division_id
FROM staff_data s
WHERE s.income >
    (SELECT AVG(x.income)
     FROM staff_data x
     WHERE x.division_id = s.division_id);
-- ===========================
SELECT division_id, MIN(income)
FROM staff_data
GROUP BY division_id
HAVING MIN(income) < ANY (
    SELECT income
    FROM staff_data
    WHERE division_id IN (1, 2)
)
ORDER BY division_id;
-- ===========================
SELECT id_worker, boss_id, division_id
FROM staff_data
WHERE (boss_id, division_id) IN (
    SELECT boss_id, division_id
    FROM staff_data
    WHERE id_worker IN (1, 3)
)
AND id_worker NOT IN (1, 3);
-- ===========================
SELECT id_worker, boss_id, division_id
FROM staff_data
WHERE boss_id IN (
    SELECT boss_id FROM staff_data WHERE id_worker IN (1, 3)
)
AND division_id IN (
    SELECT division_id FROM staff_data WHERE id_worker IN (1, 3)
)
AND id_worker NOT IN (1, 3);
-- ===========================
SELECT surname AS "No es Jefe"
FROM staff_data w
WHERE NOT EXISTS (
    SELECT 1
    FROM staff_data b
    WHERE b.boss_id = w.id_worker
);
-- ===========================
SELECT surname AS "No es Jefe"
FROM staff_data w
WHERE w.id_worker NOT IN (
    SELECT boss_id FROM staff_data
);
-- ===========================
WITH only_bosses AS (
    SELECT DISTINCT boss_id
    FROM staff_data
    WHERE boss_id IS NOT NULL
)
SELECT surname AS "No es Jefe"
FROM staff_data
WHERE id_worker NOT IN (SELECT boss_id FROM only_bosses);
-- ===========================