-- ====================================================
DROP FOREIGN TABLE IF EXISTS advisory_emp_load;
DROP TABLE IF EXISTS advisory_contacts;
DROP TABLE IF EXISTS advisory_media_collection;
-- ====================================================
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
-- ====================================================
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'advisory_media_collection'
ORDER BY ordinal_position;
-- ====================================================
CREATE TABLE advisory_media_collection (
  cd_id         SERIAL       PRIMARY KEY,            
  title         VARCHAR(50)  NOT NULL,              
  artist        VARCHAR(50)  NOT NULL,               
  purchase_date DATE         DEFAULT CURRENT_DATE    
);
-- ====================================================
INSERT INTO advisory_media_collection (title, artist) VALUES
  ('Clásicos de los 80', 'Varios Artistas'),
  ('Éxitos Latinos',     'DJ Fiesta HN'),
  ('Ritmos Rodantes',    'Los Rodantes');
-- ====================================================
CREATE TABLE advisory_contacts (
  contact_id  SERIAL      PRIMARY KEY,
  first_name  VARCHAR(30) NOT NULL,
  last_name   VARCHAR(30) NOT NULL,
  email       VARCHAR(50),
  phone_num   VARCHAR(15),
  birth_date  DATE
);
-- ====================================================
INSERT INTO advisory_contacts (first_name, last_name, email, phone_num, birth_date) VALUES
  ('Karla',  'Zepeda',   'karla.zepeda@example.com',  '555-1234', '1990-04-12'),
  ('Elvin',  'Amador',   'elvin.amador@example.com',  '555-5678', '1985-11-30');
-- ====================================================
CREATE EXTENSION IF NOT EXISTS file_fdw;
CREATE SERVER IF NOT EXISTS emp_load_srv FOREIGN DATA WRAPPER file_fdw;
-- ====================================================
CREATE FOREIGN TABLE advisory_emp_load (
  employee_number     CHAR(5),
  employee_dob        CHAR(10),
  employee_last_name  CHAR(20),
  employee_first_name CHAR(15),
  employee_middle_name CHAR(15),
  employee_hire_date  DATE
)
SERVER emp_load_srv
OPTIONS ( 
  filename '/var/lib/postgresql/data/info.csv',
  format 'csv',
  HEADER 'false'
);
-- ====================================================
SELECT indexname, tablename
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename LIKE 'advisory_%';
-- ====================================================
SELECT sequence_name
FROM information_schema.sequences
WHERE sequence_schema = 'public';
-- ====================================================
SELECT column_name, data_type, character_maximum_length, is_nullable
FROM information_schema.columns
WHERE table_name = 'advisory_contacts'
ORDER BY ordinal_position;
-- ====================================================
DROP TABLE IF EXISTS advisory_temporal_demo;
CREATE TABLE advisory_temporal_demo (
  demo_id         SERIAL       PRIMARY KEY,
  exact_ts        TIMESTAMP,       
  ts_with_tz      TIMESTAMPTZ,     
  local_ts        TIMESTAMP        
);

INSERT INTO advisory_temporal_demo (exact_ts, ts_with_tz, local_ts) VALUES
  -- ====================================================
  ( '2017-06-10 10:52:29.123456'::TIMESTAMP,
    CURRENT_TIMESTAMP,                       
    CURRENT_TIMESTAMP AT TIME ZONE 'UTC'     
  ),
  -- ====================================================
  ( NOW()::TIMESTAMP,
    NOW(), 
    NOW() AT TIME ZONE 'Europe/Istanbul'     
  );

-- ====================================================
SELECT * FROM advisory_temporal_demo;
-- ====================================================
DROP TABLE IF EXISTS advisory_interval_demo;
CREATE TABLE advisory_interval_demo (
  id                   SERIAL       PRIMARY KEY,
  months_interval      INTERVAL,    
  years_months_term    INTERVAL,    
  precise_interval     INTERVAL     
);

INSERT INTO advisory_interval_demo (months_interval, years_months_term, precise_interval) VALUES
  ( INTERVAL '120 months',            
    INTERVAL '3 years 6 months',      
    INTERVAL '25 days 4 hours 30 minutes 15 seconds' 
  );

-- ====================================================
SELECT
  now() + months_interval     AS "Dentro de 120 meses",
  now() + years_months_term   AS "Dentro de 3 años 6 meses",
  now() + precise_interval    AS "Dentro de 25 días 4h30m15s"
FROM advisory_interval_demo;
-- ====================================================
DROP TABLE IF EXISTS advisory_mod_demo;
-- ====================================================
CREATE TABLE advisory_mod_demo (
  last_entry     VARCHAR(20),
  salary_amount  NUMERIC(8,2)
);
-- ====================================================
INSERT INTO advisory_mod_demo (last_entry, salary_amount) VALUES
  ('Amador', 5000),
  ('Rosales', 7000);
-- ====================================================
ALTER TABLE advisory_mod_demo
  ADD COLUMN release_date DATE DEFAULT CURRENT_DATE;
-- ====================================================
SELECT * FROM advisory_mod_demo;
-- ====================================================
ALTER TABLE advisory_mod_demo
  ALTER COLUMN last_entry TYPE VARCHAR(30);
-- ====================================================
ALTER TABLE advisory_mod_demo
  ALTER COLUMN last_entry TYPE VARCHAR(10);
-- ====================================================
ALTER TABLE advisory_mod_demo
  ALTER COLUMN salary_amount TYPE NUMERIC(10,2);
-- ====================================================
ALTER TABLE advisory_mod_demo
  ALTER COLUMN salary_amount SET DEFAULT 1000;
-- ====================================================
SELECT column_name, data_type, character_maximum_length, column_default
FROM information_schema.columns
WHERE table_name = 'advisory_mod_demo'
ORDER BY ordinal_position;
-- ====================================================
ALTER TABLE advisory_mod_demo
  DROP COLUMN release_date;
-- ====================================================
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'advisory_mod_demo';
-- ====================================================
ALTER TABLE advisory_mod_demo
  ADD COLUMN email_address VARCHAR(50);

ALTER TABLE advisory_mod_demo
  DROP COLUMN email_address;
-- ====================================================
DROP TABLE advisory_mod_demo;
-- ====================================================
CREATE TABLE IF NOT EXISTS advisory_recycle_log (
  original_name TEXT       NOT NULL,
  operation     TEXT       NOT NULL,
  drop_time     TIMESTAMPTZ DEFAULT now()
);
-- ====================================================
CREATE OR REPLACE FUNCTION log_drop() RETURNS event_trigger AS $$
BEGIN
  INSERT INTO advisory_recycle_log(original_name, operation)
  SELECT objid::regclass::text, TG_TAG
    FROM pg_event_trigger_dropped_objects();
END;
$$ LANGUAGE plpgsql;
-- ====================================================
DROP EVENT TRIGGER IF EXISTS trg_log_drop;
CREATE EVENT TRIGGER trg_log_drop
  ON sql_drop
  WHEN TAG IN ('DROP TABLE')
  EXECUTE PROCEDURE log_drop();
-- ====================================================
DROP TABLE IF EXISTS advisory_temp_table;
CREATE TABLE advisory_temp_table(id INT);
DROP TABLE advisory_temp_table;
SELECT * FROM advisory_recycle_log ORDER BY drop_time DESC LIMIT 1;
-- ====================================================
ALTER TABLE advisory_media_collection
  RENAME TO advisory_music_collection;
-- ====================================================
TRUNCATE TABLE advisory_contacts;
-- ====================================================
COMMENT ON TABLE advisory_music_collection
  IS 'Catálogo de música generado a partir de las diapositivas de Oracle';
COMMENT ON COLUMN advisory_music_collection.artist
  IS 'Artista o compilación de cada CD';
-- ====================================================
SELECT
  c.relname   AS table_name,
  obj_description(c.oid) AS table_comment
FROM pg_class c
WHERE c.relkind = 'r'
  AND c.relname = 'advisory_music_collection';

SELECT
  cols.column_name,
  pg_catalog.col_description(c.oid, cols.ordinal_position::int) AS column_comment
FROM pg_class c
JOIN information_schema.columns cols
  ON cols.table_name = c.relname
WHERE c.relname = 'advisory_music_collection'
  AND cols.column_name = 'artist';
-- ====================================================
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- ====================================================
SELECT * FROM advisory_personnel WHERE person_id = 401;
-- ====================================================
UPDATE advisory_personnel SET salary = salary + 1 WHERE person_id = 401;
SELECT * FROM advisory_personnel WHERE person_id = 401;  
-- ====================================================
ROLLBACK;
-- ====================================================
DROP TABLE IF EXISTS advisory_personnel_audit;
CREATE TABLE advisory_personnel_audit (
  audit_id        SERIAL        PRIMARY KEY,
  person_id       INT           NOT NULL,
  first_name      TEXT          NOT NULL,
  last_name       TEXT          NOT NULL,
  salary          NUMERIC(12,2) NOT NULL,
  operation       CHAR(1)       NOT NULL,       
  operation_time  TIMESTAMPTZ   NOT NULL DEFAULT now()
);
-- ====================================================
CREATE OR REPLACE FUNCTION fn_advisory_personnel_audit() RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO advisory_personnel_audit(person_id, first_name, last_name, salary, operation)
      VALUES(NEW.person_id, NEW.first_name, NEW.last_name, NEW.salary, 'I');
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO advisory_personnel_audit(person_id, first_name, last_name, salary, operation)
      VALUES(OLD.person_id, OLD.first_name, OLD.last_name, OLD.salary, 'U');
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO advisory_personnel_audit(person_id, first_name, last_name, salary, operation)
      VALUES(OLD.person_id, OLD.first_name, OLD.last_name, OLD.salary, 'D');
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;
-- ====================================================
DROP TRIGGER IF EXISTS trg_audit_personnel ON advisory_personnel;
CREATE TRIGGER trg_audit_personnel
  AFTER INSERT OR UPDATE OR DELETE ON advisory_personnel
  FOR EACH ROW EXECUTE PROCEDURE fn_advisory_personnel_audit();
-- ====================================================
INSERT INTO advisory_personnel (
  person_id, first_name, last_name, email, phone_number,
  hire_date, job_id, salary
) VALUES (
  501, 'Prueba', 'Reversión', 'prueba@demo.com', '0000000000',
  NOW(), 'PRUEBA',  1000
);
-- ====================================================
UPDATE advisory_personnel
SET salary = 1
WHERE person_id = 501;
-- ====================================================
DELETE FROM advisory_personnel
WHERE person_id = 501;
-- ====================================================
SELECT
  person_id,
  first_name || ' ' || last_name AS nombre,
  operation AS operacion,
  to_char(operation_time, 'YYYY-MM-DD HH24:MI:SS.US TZ') AS momento
FROM advisory_personnel_audit
WHERE person_id = 501
ORDER BY operation_time DESC;
