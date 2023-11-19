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

