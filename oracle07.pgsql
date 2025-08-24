-- ================================
DROP TABLE IF EXISTS wave_rewards;
DROP TABLE IF EXISTS zombie_wave_stats;

-- ================================
CREATE TABLE zombie_wave_stats (
    wave_id SERIAL PRIMARY KEY,
    wave_number INT NOT NULL,
    zombies_spawned INT NOT NULL,
    boss_present BOOLEAN NOT NULL,
    time_limit INT NOT NULL,
    difficulty_level VARCHAR(20) NOT NULL
);

-- ================================

INSERT INTO zombie_wave_stats (wave_number, zombies_spawned, boss_present, time_limit, difficulty_level) VALUES
(1, 15, false, 60, 'facil'),
(2, 20, false, 75, 'facil'),
(3, 25, false, 80, 'normal'),
(4, 30, true, 90, 'normal'),
(5, 40, false, 100, 'difícil'),
(6, 50, true, 110, 'difHardícil'),
(7, 60, false, 120, 'duro'),
(8, 70, true, 130, 'muy difícil'),
(9, 80, false, 140, 'muy difícil'),
(10, 100, true, 180, 'extremo');

-- ================================

CREATE TABLE wave_rewards (
    reward_id SERIAL PRIMARY KEY,
    wave_number INT NOT NULL,
    reward_name VARCHAR(50) NOT NULL
);

-- ================================

INSERT INTO wave_rewards (wave_number, reward_name) VALUES
(1, 'Paquete de Munición'),
(2, 'Botiquín de Salud'),
(3, 'Mejora de Armadura'),
(4, 'Desbloqueo de Escopeta'),
(5, 'Munición de Francotirador'),
(6, 'Botiquín Profesional'),
(7, 'Lanzallamas'),
(8, 'Lanzacohetes'),
(9, 'Paquete de Granadas'),
(10, 'Rifle Láser');

-- ================================

SELECT zombie_wave_stats.wave_id, wave_rewards.reward_id
FROM zombie_wave_stats, wave_rewards
WHERE zombie_wave_stats.wave_number = wave_rewards.wave_number;


SELECT zombie_wave_stats.wave_id, wave_rewards.reward_id
FROM zombie_wave_stats, wave_rewards
WHERE zombie_wave_stats.wave_number = wave_rewards.wave_number;

SELECT zombie_wave_stats.wave_number, zombie_wave_stats.difficulty_level, wave_rewards.reward_name
FROM zombie_wave_stats, wave_rewards
WHERE zombie_wave_stats.wave_number = wave_rewards.wave_number;


SELECT zombie_wave_stats.difficulty_level, wave_rewards.reward_name
FROM zombie_wave_stats, wave_rewards
WHERE zombie_wave_stats.wave_number = wave_rewards.wave_number;

SELECT zombie_wave_stats.difficulty_level, wave_rewards.reward_name
FROM zombie_wave_stats, wave_rewards;

SELECT z.difficulty_level, z.wave_id, w.reward_name
FROM zombie_wave_stats z, wave_rewards w
WHERE z.wave_number = w.wave_number
AND z.wave_number = 8;

-- ================================

DROP TABLE IF EXISTS wave_locations;
CREATE TABLE wave_locations (
    location_id SERIAL PRIMARY KEY,
    city VARCHAR(50) NOT NULL
);

-- ================================

INSERT INTO wave_locations (city) VALUES
('Cementerio'),
('Ciudad Abandonada'),
('Laboratorio de Investigación'),
('Base Militar'),
('Puesto Avanzado en el Desierto');

-- ================================

ALTER TABLE wave_rewards ADD COLUMN location_id INT;
UPDATE wave_rewards
SET location_id = ((reward_id - 1) % 5) + 1; 

-- ================================

SELECT z.difficulty_level, l.city
FROM zombie_wave_stats z, wave_rewards w,
     wave_locations l
WHERE z.wave_number = w.wave_number
AND w.location_id = l.location_id;


