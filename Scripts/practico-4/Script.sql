USE world;

-- Listar el nombre de la ciudad y el nombre del país de todas las ciudades que pertenezcan a países con una población menor a 10000 habitantes.

SELECT  city.Name AS CityName,country.Name AS CountyName
FROM country
JOIN country ON city.CountryCode = country.Code
WHERE country.Population < 1000;
