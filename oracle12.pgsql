-- ====================================================
DROP TABLE IF EXISTS advisory_personnel_archive;
DROP TABLE IF EXISTS advisory_commission_records;
DROP TABLE IF EXISTS advisory_personnel;
DROP TABLE IF EXISTS advisory_branches;
-- ====================================================
CREATE TABLE advisory_branches (
  branch_id    INT           PRIMARY KEY,
  branch_name  VARCHAR(100)  NOT NULL,
  manager_id   INT,
  location_id  INT
);
-- ====================================================
CREATE TABLE advisory_personnel (
  person_id       INT            PRIMARY KEY,
  first_name      VARCHAR(50)    NOT NULL,
  last_name       VARCHAR(50)    NOT NULL,
  email           VARCHAR(100)   NOT NULL,
  phone_number    VARCHAR(20),
  hire_date       TIMESTAMP      NOT NULL,
  job_id          VARCHAR(20)    NOT NULL,
  salary          NUMERIC(12,2)  NOT NULL,
  commission_pct  NUMERIC(5,2),
  manager_id      INT,
  branch_id       INT
);
-- ====================================================
INSERT INTO advisory_branches (branch_id, branch_name, manager_id, location_id) VALUES
  (200, 'Recursos Humanos',   205, 1500),
  (210, 'Gestión de Propiedades', 102, 1700);
-- ====================================================
INSERT INTO advisory_personnel (
   person_id, first_name, last_name, email, phone_number,
   hire_date, job_id, salary, commission_pct, manager_id, branch_id
) VALUES
  (301, 'Elvin',   'Amador',  'eamador', '8586667641',
   TO_DATE('2017-07-08', 'YYYY-MM-DD')::TIMESTAMP,
   'MK_REP', 4200, NULL, NULL, NULL),

  (302, 'Yessenia','Rosales', 'yrosales','',
   TO_TIMESTAMP('2017-06-15 00:00', 'YYYY-MM-DD HH24:MI'),
   'IT_DEV', 4200, 12.5, NULL, NULL),

  (303, 'Darlin',  'Zepeda',  'dzepeda', '4159982010',
   TO_TIMESTAMP('2017-07-10 17:20', 'YYYY-MM-DD HH24:MI'),
   'MK_ASST', 3600, NULL, NULL, NULL),

  (304, 'Neptaly', CURRENT_USER, 'nuser', '4159982010',
   NOW(),
   'ST_SUP', 2500, 5.0, NULL, NULL);
-- ====================================================
SELECT * FROM advisory_branches    LIMIT 5;
SELECT * FROM advisory_personnel   LIMIT 5;
-- ====================================================
SELECT
  first_name,
  TO_CHAR(hire_date, 'FMMonth FMDD, YYYY') AS formatted_hire
FROM advisory_personnel
WHERE person_id = 301;
-- ====================================================
SELECT
  first_name,
  last_name,
  TO_CHAR(hire_date, 'DD-Mon-YYYY HH24:MI') AS formatted_datetime
FROM advisory_personnel
WHERE person_id = 303;
-- ====================================================
CREATE TABLE advisory_commission_records AS
SELECT
  person_id      AS rep_id,
  last_name      AS rep_name,
  salary,
  commission_pct
FROM advisory_personnel
WHERE job_id LIKE '%REP%';

SELECT * FROM advisory_commission_records LIMIT 5;
-- ====================================================
CREATE TABLE advisory_personnel_archive AS
SELECT * FROM advisory_personnel;

SELECT COUNT(*) AS total_archived
  FROM advisory_personnel_archive;
-- ====================================================
DROP TABLE IF EXISTS review_agents;
DROP TABLE IF EXISTS review_centers;
-- ====================================================
CREATE TABLE review_centers (
  center_id    INT           PRIMARY KEY,
  center_name  VARCHAR(100)  NOT NULL,
  manager_ref  INT,
  location_ref INT
);
-- ====================================================
CREATE TABLE review_agents (
  agent_id       INT           PRIMARY KEY,
  first_name     VARCHAR(50)   NOT NULL,
  last_name      VARCHAR(50)   NOT NULL,
  phone_number   VARCHAR(20),
  hire_date      TIMESTAMP     NOT NULL,
  job_ref        VARCHAR(20)   NOT NULL,
  pay_rate       NUMERIC(12,2) NOT NULL,
  commission_pct NUMERIC(5,2),
  manager_ref    INT,
  center_ref     INT
);
-- ====================================================
INSERT INTO review_centers (center_id, center_name, manager_ref, location_ref) VALUES
  (200, 'Recursos Humanos',       205, 1500),
  (210, 'Gestión de Propiedades', 102, 1700);
-- ====================================================
INSERT INTO review_agents (
  agent_id, first_name, last_name, phone_number,
  hire_date, job_ref, pay_rate, commission_pct,
  manager_ref, center_ref
) VALUES
 -- ====================================================
  (301, 'Elvin',     'Amador',    '8586667641',
   TO_TIMESTAMP('2017-07-08','YYYY-MM-DD'),
   'MK_REP', 4200, NULL, NULL, 200),

  (302, 'Yessenia',  'Rosales',   '',
   TIMESTAMP '2017-06-15 00:00:00',
   'IT_DEV', 4200, 12.5, NULL, 210),

  (303, 'Darlin',    'Zepeda',    '4159982010',
   TO_TIMESTAMP('2017-07-10 17:20','YYYY-MM-DD HH24:MI'),
   'MK_ASST', 3600, NULL, NULL, 200),

  (304, 'Neptaly',   CURRENT_USER,'4159982010',
   NOW(),
   'ST_SUP', 2500, 5.0,   NULL, 210),
 -- ====================================================
  (401, 'Edgar',     'Amador',    '1111111',
   TIMESTAMP '2010-01-01 09:00:00',
   'AC_DIR', 24000, NULL, NULL, 200),

  (402, 'Karla',     'Zepeda',    '2222222',
   TIMESTAMP '2011-02-01 10:00:00',
   'ST_AUX', 12000, NULL, NULL, 210),

  (403, 'Gerson',    'Orellana',  '3333333',
   TIMESTAMP '2012-03-01 11:00:00',
   'AC_DIR', 12000, NULL, NULL, 200),

  (404, 'Leticia',   'Orellana',  '4444444',
   TIMESTAMP '2013-04-01 12:00:00',
   'SA_ASST', 11000, NULL, NULL, 210);

-- ====================================================
UPDATE review_agents
SET phone_number = '123456'
WHERE agent_id = 303;
-- ====================================================
UPDATE review_agents
SET phone_number = '654321',
    last_name    = 'Jones'
WHERE agent_id >= 303;
-- ====================================================
UPDATE review_agents
SET pay_rate = (
  SELECT pay_rate
    FROM review_agents
   WHERE agent_id = 401
)
WHERE agent_id = 402;
-- ====================================================
UPDATE review_agents
SET
  pay_rate = (
    SELECT pay_rate
      FROM review_agents
     WHERE agent_id = 403
  ),
  job_ref  = (
    SELECT job_ref
      FROM review_agents
     WHERE agent_id = 403
  )
WHERE agent_id = 404;
-- ====================================================
ALTER TABLE review_agents
  ADD COLUMN center_name VARCHAR(100);

UPDATE review_agents ra
SET center_name = (
  SELECT rc.center_name
    FROM review_centers rc
   WHERE rc.center_id = ra.center_ref
);
-- ====================================================
DELETE FROM review_agents
WHERE agent_id = 303;
-- ====================================================
DELETE FROM review_agents
WHERE center_ref = (
  SELECT center_id
    FROM review_centers
   WHERE center_name = 'Estate Management'
);
-- ====================================================