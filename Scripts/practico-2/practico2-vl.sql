CREATE TABLE Country (
  Code char(3) PRIMARY KEY,
  Name varchar(255) NOT NULL,
  Continent varchar(255),
  Region varchar(255),
  SurfaceArea float,
  IndepYear int,
  Population int,
  LifeExpectancy float(1),
  GNP float(2),
  GNPOld float(2),
  LocalName varchar(255),
  GovernmentForm varchar(255),
  HeadOfState varchar(255),
  Capital int,
  Code2 varchar(2),
  
);


CREATE TABLE City (
  ID int NOT NULL,
  Name varchar(255),
  CountryCode varchar(3),
  District varchar(255),
  Population int,
  PRIMARY KEY (ID),
  FOREIGN KEY (CountryCode) REFERENCES Country(Code)
);


CREATE TABLE CountryLanguage (
  CountryCode CHAR(3),
  Language varchar(255),
  IsOfficial boolean,
  Percentage float, -- CHECK entre que porcentajes esta
  FOREING KEY (CountryCode) REFERENCES Country(Code) 
);

-- DEFINO EL PAR 
ALTER TABLE CountryLanguage
ADD PRIMARY KEY(CountryCode,Lenguage);

-- ejercicio 4

CREATE TABLE Continent(
  Name varchar(255) PRIMARY KEY,
  Area float,
  Porcentaje float,
  Ciudad_pob float,

);
-- ejercicio 5
INSERT INTO Continent(Name,Area,Porcentaje,Ciudad_pob)
VALUES ('Africa', 30370000, 20.4, 'Cairo, Egypt'),
	('Antarctica', 14000000, '9.2', 'McCurdo Station'),
	('Asia', 44579000, '29.5', 'Mumbay, India'),
	('Europe', 10180000, '6.8', 'Instanbul, Turquia'),
	('North America', 24709000, '16.5', 'Ciudad de Mexico, Mexico'),
	('Oceania', 8600000, '5.9', 'Sydney, Australia'),
	('South America', 17840000, '12.0', 'São Pablo, Brazil');


-- EJERCICIO 6

ALTER TABLE `country`
MODIFY COLUMN `Continent` char(52);--MODIFICO LA COLUMNA Continent en la tabla country cambiando su tipo a char
ALTER TABLE `country`
ADD CONSTRAINT `continent_of_country` FOREIGN KEY (`Continent`) REFERENCES `continent` (`Name`);

-- Parte 2

-- 1-Devuelva una lista de los nombres y las regiones a las que pertenece cada país ordenada alfabéticamente.

SELECT Name, Region
FROM Country
ORDER BY CountryName, Region;

-- 2-Liste el nombre y la población de las 10 ciudades más pobladas del mundo.
SELECT Name,Population
FROM Country
ORDER BY Population DESC
LIMIT 10;

-- 3-Liste el nombre, región, superficie y forma de gobierno de los 10 países con menor superficie.
SELECT Name,Region,SurfaceArea,GovernmentForm
FROM Country
ORDER BY SurfaceArea
LIMIT 10;

-- 4-Liste todos los países que no tienen independencia (hint: ver que define la independencia de un país en la BD).
SELECT Name,GovernmentForm
FROM Country
WHERE IndepYear IS NULL;

-- 5-Liste el nombre y el porcentaje de hablantes que tienen 
-- todos los idiomas declarados oficiales.
SELECT Percentage
FROM CountryLanguage
WHERE (CountryLanguage.IsOfficial='T')

-- ADICIONALES 
-- 6-Actualizar el valor de porcentaje del idioma inglés en el país con código 'AIA' a 100.0
UPDATE CountryLanguage
SET Percentage = 100.0
WHERE CountryCode = 'AIA' AND Language = 'English';

-- Listar las ciudades que pertenecen a Córdoba (District) dentro de Argentina.
SELECT Name
FROM City
WHERE District = 'Córdoba' AND CountryCode = 'ARG';--ver el tema de la tilde

-- Eliminar todas las ciudades que pertenezcan a Córdoba fuera de Argentina.
DELETE FROM City
WHERE District LIKE '%rdoba' AND CountryCode = 'ARG';


DELETE FROM City
WHERE District LIKE '%rdoba' AND CountryCode != 'ARG';

-- Listar los países cuyo Jefe de Estado se llame John.
SELECT CountryName,HeadOfState
FROM Country
WHERE HeadOfState LIKE '%John%';
-- VER EL TEMA DE JOHN

-- Listar los países cuya población esté entre 35 M y 45 M ordenados por población de forma descendente.
SELECT CountryName,Population
FROM Country
WHERE Population BETWEEN 35000000 AND 45000000
ORDER BY Population DESC;

-- Identificar las redundancias en el esquema final.

USE world;



-- Lista el nombre de la ciudad, nombre del país, región y forma de gobierno de las 10 ciudades más pobladas del mundo.

SELECT
	city.Name AS CityName,
	country.Name AS CountryName,
	country.Region,
	country.GovernmentForm
FROM
	city
INNER JOIN country ON
	city.CountryCode = country.Code
ORDER BY
	city.Population DESC
LIMIT 10;


-- Listar los 10 países con menor población del mundo, junto a sus ciudades capitales
-- (Hint: puede que uno de estos países no tenga ciudad capital asignada, en este caso deberá mostrar "NULL").

SELECT
	country.Population AS CountryName,
	city.Name AS CapitalCity
FROM
	country
LEFT JOIN city ON
	country.Capital = city.ID
ORDER BY
	country.Population DESC
LIMIT 10;

-- Lista el nombre de la ciudad, nombre del país, región y forma de gobierno de las 10 ciudades más pobladas del mundo.

SELECT 	city.Name AS CityName,country.Name AS CountryName,country.Region,country.GovernmentForm 
FROM city 
INNER JOIN country ON city.CountryCode = country.Code 
ORDER BY city.Population  DESC
LIMIT 10;


-- Listar los 10 países con menor población del mundo, junto a sus ciudades capitales
-- (Hint: puede que uno de estos países no tenga ciudad capital asignada, en este caso deberá mostrar "NULL").

SELECT country.Population AS CountryName, city.Name  AS CapitalCity 
FROM country 
LEFT JOIN city ON country.Capital = city.ID 
ORDER BY country.Population  DESC 
LIMIT 10;

-- Listar el nombre, continente y todos los lenguajes oficiales de cada país. (Hint: habrá más de una fila por país si tiene varios idiomas oficiales).
SELECT  country.Name AS CountryName ,country.Continent ,countrylanguage.`Language`  AS OfficialLanguaje
FROM country 
INNER JOIN
    countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE
    countrylanguage.IsOfficial = 'T'
ORDER BY
    country.Name, countrylanguage.Language;
   
   
 -- Listar el nombre del país y nombre de capital, de los 20 países con mayor superficie del mundo.
   
SELECT country.Name AS CountryName,city.Name AS CapitalName
FROM country 
LEFT JOIN city ON country.Capital = city.ID
ORDER BY country.SurfaceArea  DESC 
LIMIT 20;

-- Listar las ciudades junto a sus idiomas oficiales (ordenado por la población de la ciudad) y el porcentaje de hablantes del idioma.

SELECT
    city.Name AS CityName,
    countrylanguage.Language AS OfficialLanguage,
    countrylanguage.Percentage AS LanguagePercentage
FROM
    city
INNER JOIN
    country ON city.CountryCode = country.Code
INNER JOIN
    countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE
    countrylanguage.IsOfficial = 'T'
ORDER BY
    city.Population DESC;
   
 -- Listar los 10 países con mayor población y los 10 países con menor población (que tengan al menos 100 habitantes) en la misma consulta
   
SELECT  country.Name AS CountryName,
country.Population 
FROM country
INNER JOIN country.Population >= 100 DESC
LIMIT 10
UNION 
SELECT
    country.Name AS CountryName,
    country.Population
FROM
    country
WHERE
    country.Population >= 100
ORDER BY
    country.Population ASC
LIMIT 10;

-- Listar aquellos países cuyos lenguajes oficiales son el Inglés y el Francés (hint: no debería haber filas duplicadas).
(
    SELECT country.Name FROM
        country INNER JOIN countrylanguage ON
            country.Code = countrylanguage.CountryCode
                AND countrylanguage.IsOfficial = 'T'
                AND countrylanguage.Language = 'English'
) INTERSECT (
    SELECT country.Name FROM
        country INNER JOIN countrylanguage ON
            country.Code = countrylanguage.CountryCode
                AND countrylanguage.IsOfficial = 'T'
                AND countrylanguage.Language = 'French'
);

-- Listar aquellos países que tengan hablantes del Inglés pero no del Español en su población.
(
    SELECT country.Name FROM
        country INNER JOIN countrylanguage ON
            country.Code = countrylanguage.CountryCode
                AND countrylanguage.Language = 'English'
) EXCEPT (
    SELECT country.Name FROM
        country INNER JOIN countrylanguage ON
            country.Code = countrylanguage.CountryCode
                AND countrylanguage.Language = 'Spanish'
);


-- Parte 2
/* 
SELECT city.Name, country.Name
FROM city
LEFT JOIN country ON city.CountryCode = country.Code AND country.Name = 'Argentina';


SELECT city.Name, country.Name
FROM city
LEFT JOIN country ON city.CountryCode = country.Code
WHERE country.Name = 'Argentina';
 */

/*
1. Si devuleven lo mismo

2. No, con LEFT JOIN devuelven cosas distintas.
En particular, en el primero se devuelven todas las cuidades con el pais en
NULL cuando no es argntina, mientras que en el segundo se devuelven solo las
cuidades de Argentina

*/


-- Listar el nombre de la ciudad y el nombre del país de todas las ciudades que pertenezcan a países con una población menor a 10000 habitantes.

SELECT  city.Name AS CityName,country.Name AS CountyName
FROM country
JOIN country ON city.CountryCode = country.Code
WHERE country.Population < 1000;

USE world;

-- Listar el nombre de la ciudad y el nombre del país de todas las ciudades que pertenezcan a países con una población menor a 10000 habitantes.

SELECT  city.Name AS CityName,country.Name AS CountyName
FROM country
JOIN country ON city.CountryCode = country.Code
WHERE country.Population < 1000;


