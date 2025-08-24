-- ==========================================
DROP SCHEMA IF EXISTS demo CASCADE;
CREATE SCHEMA demo;
SET search_path TO demo;
-- ==========================================
CREATE TABLE locaciones (
    location_id SERIAL PRIMARY KEY,
    city VARCHAR(50),
    state_province VARCHAR(50)
);
-- ==========================================
CREATE TABLE departamentos (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    manager_id INT,
    location_id INT REFERENCES locaciones(location_id)
);
-- ==========================================
CREATE TABLE trabajos (
    job_id SERIAL PRIMARY KEY,
    job_title VARCHAR(50) NOT NULL,
    min_salary NUMERIC(10,2),
    max_salary NUMERIC(10,2)
);
-- ==========================================
CREATE TABLE grados_trabajo (
    grade_level CHAR(1) PRIMARY KEY,
    lowest_sal NUMERIC(10,2),
    highest_sal NUMERIC(10,2)
);
-- ==========================================
CREATE TABLE empleados (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    salary NUMERIC(10,2),
    commission_pct NUMERIC(3,2),
    manager_id INT,
    hire_date DATE,
    job_id INT REFERENCES trabajos(job_id),
    department_id INT REFERENCES departamentos(department_id)
);
-- ==========================================
SELECT CONCAT(LEFT(first_name,1),' ',last_name) AS "Employee Names" FROM empleados;
-- ==========================================
SELECT CONCAT(first_name,' ',last_name) AS "Employee Name", email AS "Email" FROM empleados WHERE email LIKE '%IN%';
-- ==========================================
SELECT MIN(last_name) AS "First Last Name", MAX(last_name) AS "Last Last Name" FROM empleados;
-- ==========================================
SELECT TO_CHAR(salary/4,'$9999.99') AS "Weekly Salary" FROM empleados WHERE salary/4 BETWEEN 700 AND 3000;
-- ==========================================
SELECT CONCAT(LEFT(e.first_name,1),' ',e.last_name) AS "Employee Name", t.job_title AS "Job" FROM empleados e JOIN trabajos t ON e.job_id=t.job_id ORDER BY t.job_title;
-- ==========================================
SELECT CONCAT(LEFT(e.first_name,1),' ',e.last_name) AS "Employee Name", t.job_title AS "Job", CONCAT(t.min_salary,'-',t.max_salary) AS "Salary Range", e.salary AS "Employee's Salary" FROM empleados e JOIN trabajos t ON e.job_id=t.job_id;
-- ==========================================
SELECT CONCAT(LEFT(e.first_name,1),' ',e.last_name) AS "Employee Name", d.department_name AS "Department Name" FROM empleados e JOIN departamentos d ON e.department_id=d.department_id;
-- ==========================================
SELECT CONCAT(LEFT(e.first_name,1),' ',e.last_name) AS "Employee Name", d.department_name AS "Department Name" FROM empleados e NATURAL JOIN departamentos d;
-- ==========================================
SELECT CASE WHEN manager_id IS NULL THEN 'Nobody' ELSE 'Somebody' END AS "Works for", last_name AS "Last Name" FROM empleados;
-- ==========================================
SELECT CONCAT(LEFT(first_name,1),' ',last_name) AS "Employee Name", salary AS "Salary", CASE WHEN commission_pct IS NULL THEN 'No' ELSE 'Yes' END AS "Commission" FROM empleados;
-- ==========================================
SELECT e.last_name, d.department_name, l.city, l.state_province FROM empleados e LEFT JOIN departamentos d ON e.department_id=d.department_id LEFT JOIN locaciones l ON d.location_id=l.location_id;
-- ==========================================
SELECT first_name AS "First Name", last_name AS "Last Name", COALESCE(commission_pct::TEXT, manager_id::TEXT, '-1') AS "Which function???" FROM empleados;
-- ==========================================
SELECT e.last_name, e.salary, g.grade_level FROM empleados e JOIN grados_trabajo g ON e.salary BETWEEN g.lowest_sal AND g.highest_sal WHERE department_id>50;
-- ==========================================
SELECT e.last_name, d.department_name FROM empleados e FULL JOIN departamentos d ON e.department_id=d.department_id;
-- ==========================================
WITH RECURSIVE emp_hierarchy AS (
  SELECT employee_id, last_name, manager_id, 1 AS position FROM empleados WHERE employee_id=100
  UNION ALL
  SELECT e.employee_id, e.last_name, e.manager_id, eh.position+1 FROM empleados e JOIN emp_hierarchy eh ON e.manager_id=eh.employee_id)
SELECT position, last_name, COALESCE((SELECT last_name FROM empleados m WHERE m.employee_id=emp_hierarchy.manager_id),'-') AS manager_name FROM emp_hierarchy;
-- ==========================================
SELECT MIN(hire_date) AS "Lowest", MAX(hire_date) AS "Highest", COUNT(*) AS "No of Employees" FROM empleados;
-- ==========================================
SELECT d.department_name, SUM(e.salary) AS "Salaries" FROM empleados e JOIN departamentos d ON e.department_id=d.department_id GROUP BY d.department_name HAVING SUM(e.salary) BETWEEN 15000 AND 31000 ORDER BY SUM(e.salary);
-- ==========================================
SELECT ROUND(MAX(avg_sal)) AS "Highest Avg Sal for Depts" FROM (SELECT AVG(salary) AS avg_sal FROM empleados GROUP BY department_id) t;
-- ==========================================
SELECT d.department_name AS "Department Name", SUM(e.salary) AS "Monthly Cost" FROM empleados e JOIN departamentos d ON e.department_id=d.department_id GROUP BY d.department_name;
-- ==========================================
SELECT d.department_name AS "Department Name", t.job_title AS "Job Title", SUM(e.salary) AS "Monthly Cost" FROM empleados e JOIN trabajos t ON e.job_id=t.job_id JOIN departamentos d ON e.department_id=d.department_id GROUP BY d.department_name,t.job_title;

-- Consulta 21: Agrupación cubo con flags de uso
SELECT d.department_name, t.job_title, SUM(e.salary) AS "Monthly Cost", CASE WHEN GROUPING(d.department_name)=0 THEN 'Yes' ELSE 'No' END AS "Department ID Used", CASE WHEN GROUPING(t.job_title)=0 THEN 'Yes' ELSE 'No' END AS "Job ID Used" FROM empleados e JOIN trabajos t ON e.job_id=t.job_id JOIN departamentos d ON e.department_id=d.department_id GROUP BY CUBE(d.department_name,t.job_title);
-- ==========================================
SELECT d.department_name, t.job_title, l.city, SUM(e.salary) FROM empleados e JOIN trabajos t ON e.job_id=t.job_id JOIN departamentos d ON e.department_id=d.department_id JOIN locaciones l ON d.location_id=l.location_id GROUP BY GROUPING SETS ((d.department_name,t.job_title),(l.city));
-- ==========================================
SELECT CONCAT(LEFT(first_name,1),' ',last_name) AS "Employee Name", department_id AS "Department Id", NULL AS "Department Name", NULL AS "City" FROM empleados
UNION ALL
SELECT NULL, department_id, department_name, NULL FROM departamentos
UNION ALL
SELECT NULL, NULL, NULL, city FROM locaciones;
-- ==========================================
SELECT CONCAT(LEFT(e.first_name,1),' ',e.last_name) AS "Employee", e.salary AS "Salary", d.department_name AS "Department Name" FROM empleados e JOIN departamentos d ON e.department_id=d.department_id WHERE e.salary > (SELECT AVG(salary) FROM empleados WHERE department_id=e.department_id);
