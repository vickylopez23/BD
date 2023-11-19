DROP DATABASE IF EXISTS `olympics`;

CREATE DATABASE `olympics` DEFAULT CHARACTER SET
utf8mb4;

USE `olympics`;

DROP TABLE IF EXISTS olympics.medal;

CREATE TABLE olympics.medal (
  id INT NOT NULL AUTO_INCREMENT,
  medal_name varchar(50) DEFAULT NULL,
  CONSTRAINT pk_medal PRIMARY KEY (id)
);

DROP TABLE IF EXISTS olympics.noc_region;

CREATE TABLE olympics.noc_region (
  id INT NOT NULL AUTO_INCREMENT,
  noc VARCHAR(5) DEFAULT NULL,
  region_name VARCHAR(200) DEFAULT NULL,
  CONSTRAINT pk_nocregion PRIMARY KEY (id)
);

DROP TABLE IF EXISTS olympics.sport;

CREATE TABLE olympics.sport (
  id INT NOT NULL AUTO_INCREMENT,
  sport_name VARCHAR(200) DEFAULT NULL,
  CONSTRAINT pk_sport PRIMARY KEY (id)
);

DROP TABLE IF EXISTS olympics.city;

CREATE TABLE olympics.city (
  id INT NOT NULL AUTO_INCREMENT,
  city_name varchar(200) DEFAULT NULL,
  CONSTRAINT pk_city PRIMARY KEY (id)
);

DROP TABLE IF EXISTS olympics.event;

CREATE TABLE olympics.event (
  id INT NOT NULL AUTO_INCREMENT,
  sport_id INT DEFAULT NULL,
  event_name VARCHAR(200) DEFAULT NULL,
  CONSTRAINT pk_event PRIMARY KEY (id),
  CONSTRAINT fk_ev_sp FOREIGN KEY (sport_id) REFERENCES olympics.sport (id)
);

DROP TABLE IF EXISTS olympics.games;

CREATE TABLE olympics.games (
  id INT NOT NULL AUTO_INCREMENT,
  games_year INT DEFAULT NULL,
  games_name varchar(100) DEFAULT NULL,
  season varchar(100) DEFAULT NULL,
  CONSTRAINT pk_games PRIMARY KEY (id)
);

DROP TABLE IF EXISTS olympics.games_city;

CREATE TABLE olympics.games_city (
  games_id INT DEFAULT NULL,
  city_id INT DEFAULT NULL,
  CONSTRAINT fk_gci_city FOREIGN KEY (city_id) REFERENCES olympics.city (id),
  CONSTRAINT fk_gci_gam FOREIGN KEY (games_id) REFERENCES olympics.games (id)
);

DROP TABLE IF EXISTS olympics.person;

CREATE TABLE olympics.person (
  id INT NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(500) DEFAULT NULL,
  gender VARCHAR(10) DEFAULT NULL,
  height INT DEFAULT NULL,
  weight INT DEFAULT NULL,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS olympics.person_region;

CREATE TABLE olympics.person_region (
  person_id INT DEFAULT NULL,
  region_id INT DEFAULT NULL,
  CONSTRAINT fk_per_per FOREIGN KEY (person_id) REFERENCES olympics.person (id),
  CONSTRAINT fk_per_reg FOREIGN KEY (region_id) REFERENCES olympics.noc_region (id)
);

DROP TABLE IF EXISTS olympics.person_region;

CREATE TABLE olympics.person_region (
  person_id INT DEFAULT NULL,
  region_id INT DEFAULT NULL,
  CONSTRAINT fk_per_per FOREIGN KEY (person_id) REFERENCES olympics.person (id),
  CONSTRAINT fk_per_reg FOREIGN KEY (region_id) REFERENCES olympics.noc_region (id)
);

DROP TABLE IF EXISTS olympics.games_competitor;

CREATE TABLE olympics.games_competitor (
  id INT NOT NULL AUTO_INCREMENT,
  games_id INT DEFAULT NULL,
  person_id INT DEFAULT NULL,
  age INT DEFAULT NULL,
  CONSTRAINT pk_gamescomp PRIMARY KEY (id),
  CONSTRAINT fk_gc_gam FOREIGN KEY (games_id) REFERENCES olympics.games (id),
  CONSTRAINT fk_gc_per FOREIGN KEY (person_id) REFERENCES olympics.person (id)
);

DROP TABLE IF EXISTS olympics.competitor_event;

CREATE TABLE olympics.competitor_event (
  event_id INT DEFAULT NULL,
  competitor_id INT DEFAULT NULL,
  medal_id INT DEFAULT NULL,
  CONSTRAINT fk_ce_com FOREIGN KEY (competitor_id) REFERENCES games_competitor (id),
  CONSTRAINT fk_ce_ev FOREIGN KEY (event_id) REFERENCES event (id),
  CONSTRAINT fk_ce_med FOREIGN KEY (medal_id) REFERENCES medal (id)
);

COMMIT;
-- 1. Crear un campo nuevo `total_medals` en la tabla `person` que almacena la
-- cantidad de medallas ganadas por cada persona. Por defecto, con valor 0.

ALTER TABLE person 
ADD COLUMN total_medals INT DEFAULT 0;
-- 2. Actualizar la columna
-- `total_medals` de cada persona con el recuento real de
-- medallas que ganó. Por ejemplo, para Michael Fred Phelps II, luego de la
-- actualización debería tener como valor de `total_medals` igual a 28.


UPDATE
	person AS p
SET
	p.total_medals =(
	SELECT
		COUNT(*)
	FROM
		games_competitor gc
	JOIN competitor_event ce ON
		gc.id = ce.competitor_id
	WHERE
		gc.person_id = p.id
		AND ce.medal_id IS NOT NULL 
);

SELECT
	*
FROM
	person;

/*3. Devolver todos los medallistas olímpicos de Argentina, es decir, los que hayan
logrado alguna medalla de oro, plata, o bronce, enumerando la cantidad por tipo de
medalla. Por ejemplo, la query debería retornar casos como el siguiente:
(Juan Martín del Potro, Bronze, 1), (Juan Martín del Potro, Silver,1)*/
-- 4. Listar el total de medallas ganadas por los 
-- deportistas argentinos en cada deporte.
SELECT
	s.sport_name AS Deporte,
	COUNT(*) AS Total_Medallas
FROM
	olympics.competitor_event ce
JOIN
  olympics.event e ON
	ce.event_id = e.id
JOIN
  olympics.sport s ON
	e.sport_id = s.id
JOIN
  olympics.games_competitor gc ON
	ce.competitor_id = gc.id
JOIN
  olympics.medal m ON
	ce.medal_id = m.id
WHERE
	ce.medal_id IS NOT NULL
	AND gc.id IN (
	SELECT
		id
	FROM
		olympics.games_competitor
	WHERE
		games_id IN (
		SELECT
			id
		FROM
			olympics.games
		WHERE
			games_id IS NOT NULL
			AND games_id IN (
			SELECT
				id
			FROM
				olympics.games_city
			WHERE
				city_id IN (
				SELECT
					id
				FROM
					olympics.city
				WHERE
					city_name IS NOT NULL
					AND city_name IN (
					SELECT
						city_name
					FROM
						olympics.city
					JOIN olympics.games_city ON
						city.id = games_city.city_id
					JOIN olympics.games ON
						games_city.games_id = games.id
					WHERE
						games.games_year IS NOT NULL
          )
        )
      )
    )
  )
GROUP BY
	s.sport_name
ORDER BY
	Total_Medallas DESC;
-- 5. Listar el número total de medallas de oro, plata y bronce ganadas por cada país
-- (país representado en la tabla `noc_region`), agruparlas los resultados por pais.
-- 6. Listar el país con más y menos medallas ganadas en la historia de las olimpiadas.
WITH MedalsCount AS (
SELECT
	nr.region_name AS Pais,
	COUNT(*) AS Total_Medallas
FROM
	olympics.competitor_event ce
JOIN
    olympics.games_competitor gc ON
	ce.competitor_id = gc.id
JOIN
    olympics.noc_region nr ON
	gc.games_id = nr.id
WHERE
	ce.medal_id IS NOT NULL
GROUP BY
	nr.region_name  
)

SELECT
	Pais,
	Total_Medallas
FROM
	MedalsCount
WHERE
	Total_Medallas = (
	SELECT
		MAX(Total_Medallas)
	FROM
		MedalsCount)
	OR Total_Medallas = (
	SELECT
		MIN(Total_Medallas)
	FROM
		MedalsCount);

/*
7. Crear dos triggers:
a. Un trigger llamado `increase_number_of_medals` que incrementará en 1 el
valor del campo `total_medals` de la tabla `person`.
b. Un trigger llamado `decrease_number_of_medals` que decrementará en 1
el valor del campo `totals_medals` de la tabla `person`.
El primer trigger se ejecutará luego de un `INSERT` en la tabla `competitor_event` y
deberá actualizar el valor en la tabla `person` de acuerdo al valor introducido (i.e.
sólo aumentará en 1 el valor de `total_medals` para la persona que ganó una
medalla). Análogamente, el segundo trigger se ejecutará luego de un `DELETE` en la
tabla `competitor_event` y sólo actualizará el valor en la persona correspondiente.
*/
-- a

CREATE TRIGGER increase_number_of_medals 
AFTER
INSERT
	ON
	medals
FOR EACH ROW
BEGIN
    UPDATE
	person
SET
	total_medals = total_medals + 1
WHERE
	person.id = NEW.person;
END;
-- B
CREATE TRIGGER decrease_number_of_medals 
BEFORE
DELETE
	ON
	medals
FOR EACH ROW
BEGIN
    UPDATE
	person
SET
	total_medals = total_medals - 1
WHERE
	person.id = OLD.person;
END;
DELIMITER ;
-- 8
DELIMITER $$
CREATE PROCEDURE add_new_medalists (IN event_id INT, IN g_id INT, IN s_id INT, IN b_id INT)
BEGIN
    INSERT
	INTO
	competitor_event (event_id,
	noc_region_id,
	medal)
VALUES (event_id,
g_id,
'Gold'),
(event_id,
s_id,
'Silver'),
(event_id,
b_id,
'Bronze');
END //
DELIMITER ;
-- 9

CREATE ROLE organizer;

GRANT
DELETE
	ON
	olympics.games TO organizer;

GRANT
UPDATE
	(games_name) ON
	olympics.games TO organizer;