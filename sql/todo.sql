
--PRACTICO 2
DROP DATABASE IF EXISTS world;

CREATE DATABASE world;

USE world;

CREATE TABLE Country (
  Code char(3) PRIMARY KEY,
  Name varchar(255) NOT NULL,
  Continent varchar(255),
  Region varchar(255),
  SurfaceArea float,
  IndepYear int,
  Population int,
  LifeExpect float(1),
  GNP float(2),
  GNPOld float(2),
  LocalName varchar(255),
  GovernmentForm varchar(255),
  HeadOfState varchar(255),
  Capital int,
  Code2 varchar(2)
  
);

CREATE TABLE IF NOT EXISTS City (
  ID int NOT NULL,
  Name varchar(255),
  CountryCode varchar(3),
  District varchar(255),
  Population int,
  PRIMARY KEY (ID),
  FOREIGN KEY (CountryCode) REFERENCES Country(Code)
);

CREATE TABLE IF NOT EXISTS CountryLanguage (
  CountryCode CHAR(3),
  Language varchar(255),
  IsOfficial boolean,
  Percentage float,
-- CHECK entre que porcentajes esta
FOREING KEY (CountryCode) REFERENCES Country(Code) 
);
-- DEFINO EL PAR 
ALTER TABLE CountryLanguage
ADD PRIMARY KEY(CountryCode,
Lenguage);
-- ejercicio 4

CREATE TABLE Continent(
  Name varchar(255) PRIMARY KEY,
  Area float,
  Porcentaje float,
  Ciudad_pob float,

);
-- ejercicio 5
INSERT
	INTO
	Continent(Name,
	Area,
	Porcentaje,
	Ciudad_pob)
VALUES ('Africa',
30370000,
20.4,
'Cairo, Egypt'),
	('Antarctica',
14000000,
'9.2',
'McCurdo Station'),
	('Asia',
44579000,
'29.5',
'Mumbay, India'),
	('Europe',
10180000,
'6.8',
'Instanbul, Turquia'),
	('North America',
24709000,
'16.5',
'Ciudad de Mexico, Mexico'),
	('Oceania',
8600000,
'5.9',
'Sydney, Australia'),
	('South America',
17840000,
'12.0',
'São Pablo, Brazil');


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

--PRACTICO 3

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


-- PRACTICO 4
USE world;
-- 1. Listar el nombre de la ciudad y el nombre del país de todas las ciudades que pertenezcan a países con una población menor a 10000 habitantes.
SELECT ci.Name, co.Name
FROM city ci
INNER JOIN country co ON
	ci.CountryCode = co.Code
WHERE(
	SELECT SUM(ci2.Population)
FROM city ci2
WHERE ci2.CountryCode = co.Code
	) < 10000;
-- 2. Listar todas aquellas ciudades cuya población sea mayor que la población promedio entre todas las ciudades.
SELECT ci1.Name, COUNT(*) OVER()
FROM city ci1
WHERE ci1.Population > (
	SELECT AVG(ALL ci2.Population)
FROM city ci2);
-- 3. Listar todas aquellas ciudades no asiáticas cuya población sea igual o mayor a la población total de algún país de Asia.
SELECT ci1.Name, COUNT(*) OVER() AS total
FROM(
	SELECT ci2.*
FROM city ci2
INNER JOIN country co ON
		ci2.CountryCode = co.Code
WHERE co.Continent NOT LIKE "Asia" ) AS ci1
WHERE ci1.Population >= SOME (
	SELECT co1.Population
FROM country co1
WHERE co1.Continent LIKE "Asia");
-- 4. Listar aquellos países junto a sus idiomas no oficiales, que superen en porcentaje de hablantes a cada uno de los idiomas oficiales del país.
SELECT co.Name, cl.`Language`, cl.Percentage, COUNT(*) OVER() AS total
FROM country co
INNER JOIN countrylanguage cl ON 
	co.Code = cl.CountryCode
WHERE cl.IsOfficial LIKE "F"
AND 
	cl.Percentage > ALL(
	SELECT cl2.Percentage
FROM countrylanguage cl2
WHERE cl2.CountryCode = co.Code
AND 
			cl2.IsOfficial LIKE "T");
		
-- 5. Listar (sin duplicados) aquellas regiones que tengan países con una superficie menor a 1000 km2 y exista (en el país) al menos una ciudad con más de 100000 habitantes. (Hint: Esto puede resolverse con o sin una subquery, intenten encontrar ambas respuestas).
-- FORMA 1
SELECT DISTINCT 
	co.Region
FROM country co
INNER JOIN city ci ON
	co.Code = ci.CountryCode
WHERE
	co.SurfaceArea < 1000
AND
	ci.Population > 100000;
	
	
-- FORMA 2
SELECT DISTINCT co.Region
FROM country co
WHERE co.SurfaceArea < 1000
AND 
	100000 < SOME (
		SELECT ci.Population
		FROM city ci
		WHERE ci.CountryCode = co.Code 
	);


-- FORMA 3
SELECT DISTINCT co.Region
FROM country co
WHERE co.SurfaceArea < 1000
AND 
	100000 < (
	SELECT MAX(ci.Population)
FROM city ci
WHERE ci.CountryCode = co.Code
GROUP BY
		ci.CountryCode 
	);
-- 6. Listar el nombre de cada país con la cantidad de habitantes de su ciudad más poblada. (Hint: Hay dos maneras de llegar al mismo resultado. Usando consultas escalares o usando agrupaciones, encontrar ambas).
SELECT co.Name, MAX(ci.Population)
FROM country co
INNER JOIN 
	city ci ON
ci.CountryCode = co.Code
GROUP BY 
	ci.CountryCode;

-- 7. Listar aquellos países y sus lenguajes no oficiales cuyo porcentaje de hablantes sea mayor al promedio de hablantes de los lenguajes oficiales.
SELECT co.Name, cl.`Language`, COUNT(*) OVER() AS total
FROM country co
INNER JOIN countrylanguage cl ON 
	co.Code = cl.CountryCode
WHERE cl.IsOfficial LIKE "F"
AND 
	cl.Percentage > (SELECT AVG(cl2.Percentage)
		FROM countrylanguage cl2
		WHERE co.Code = cl2.CountryCode 
			AND cl2.IsOfficial LIKE "T"
	);

-- 8. Listar la cantidad de habitantes por continente ordenado en forma descendente.
SELECT Continent, SUM(Population) AS Poblacion
FROM country
GROUP BY 
	Continent 
ORDER BY Poblacion DESC;
	
-- 9. Listar el promedio de esperanza de vida (LifeExpectancy) por continente con una esperanza de vida entre 40 y 70 años.
SELECT Continent, AVG(LifeExpectancy) AS esperanza
FROM country
GROUP BY 
	Continent 
HAVING 
	esperanza > 40 
	AND
	esperanza < 70;

-- 10. Listar la cantidad máxima, mínima, promedio y suma de habitantes por continente.
SELECT 
	Continent, 
	MAX(Population) AS max_poblacion,
	MIN(Population) AS min_poblacion,
	AVG(Population) AS avg_poblacion,
	SUM(Population) AS sum_poblacion
FROM country
GROUP BY 
	Continent 
ORDER BY max_poblacion DESC;

-- PRACTICO 5

USE sakila;

-- 1. Cree una tabla de `directors` con las columnas: Nombre, Apellido, Número de Películas.
CREATE TABLE `directors` (
	name VARCHAR(200),
	surname VARCHAR(200),
	numberOfMovies INT
);
	
-- 2. El top 5 de actrices y actores de la tabla `actors` que tienen la mayor experiencia (i.e. el mayor número de películas filmadas) son también directores de las películas en las que participaron. Basados en esta información, inserten, utilizando una subquery los valores correspondientes en la tabla `directors`.
INSERT INTO `directors` (name, surname, numberOfMovies)
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS total
FROM actor a
INNER JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY fa.actor_id
ORDER BY total DESC 
LIMIT 5;

-- 3. Agregue una columna `premium_customer` que tendrá un valor 'T' o 'F' de acuerdo a si el cliente es "premium" o no. Por defecto ningún cliente será premium.
ALTER TABLE `customer`
ADD `premium_customer` enum('T','F') NOT NULL DEFAULT 'F';

-- 4. Modifique la tabla customer. Marque con 'T' en la columna `premium_customer` delos 10 clientes con mayor dinero gastado en la plataforma.
UPDATE customer c
SET c.premium_customer = 'T'
WHERE c.customer_id IN (
	SELECT top10.customer_id
	FROM (
		SELECT p.customer_id, sum(p.amount) AS `total`
		FROM payment p 
		GROUP BY p.customer_id 
		ORDER BY `total` DESC 
		LIMIT 10
	) top10
);

-- 5. Listar, ordenados por cantidad de películas (de mayor a menor), los distintos ratings de las películas existentes (Hint: rating se refiere en este caso a la clasificación según edad: G, PG, R, etc). 
SELECT f.rating, COUNT(DISTINCT f.film_id)
FROM film f 
GROUP BY (f.rating)

-- 6. ¿Cuáles fueron la primera y última fecha donde hubo pagos?
-- primera
SELECT p.payment_id, p.payment_date 
FROM payment p 
WHERE p.payment_date <= ALL (
	SELECT p.payment_date 
	FROM payment p 
) 
-- ultimas
SELECT p.payment_id, p.payment_date 
FROM payment p 
WHERE p.payment_date >= ALL (
	SELECT p.payment_date 
	FROM payment p 
);

-- 7. Calcule, por cada mes, el promedio de pagos (Hint: vea la manera de extraer el nombre del mes de una fecha).
SELECT MONTHNAME(payment_date), avg(amount)
FROM payment p
GROUP BY MONTHNAME(payment_date);

-- 8. Listar los 10 distritos que tuvieron mayor cantidad de alquileres (con la cantidad total de alquileres). 
SELECT a.district, count(r.rental_id) AS total_alquileres 
FROM rental r 
INNER JOIN customer c ON 
	r.customer_id = c.customer_id 
INNER JOIN address a ON
	a.address_id = c.address_id
GROUP BY a.district
ORDER BY total_alquileres DESC
LIMIT 10;

-- 9. Modifique la table `inventory_id` agregando una columna `stock` que sea un número entero y representa la cantidad de copias de una misma película que tiene determinada tienda. El número por defecto debería ser 5 copias.
ALTER TABLE inventory 
ADD `stock` INT DEFAULT 5;

-- 10. Cree un trigger `update_stock` que, cada vez que se agregue un nuevo registro a la tabla rental, haga un update en la tabla `inventory` restando una copia al stock de la película rentada (Hint: revisar que el rental no tiene información directa sobre la tienda, sino sobre el cliente, que está asociado a una tienda en particular).

CREATE TRIGGER `update_stock` 	-- creamos el TRIGGER y le ponemos nombre
AFTER INSERT ON rental 			-- se ejecuta despues de insertar en la tabla rental
FOR EACH ROW 					-- se ejecuta por cada ROW nueva insertada
BEGIN 							-- se ejecuta todo lo que esta aca abajo
	
	UPDATE inventory 
	SET stock = stock - 1
	WHERE (inventory_id = NEW.inventory_id)
		
END

-- 11. Cree una tabla `fines` que tenga dos campos: `rental_id` y `amount`. El primero es una clave foránea a la tabla rental y el segundo es un valor numérico con dos decimales.
CREATE TABLE `fines` (
	rental_id INT,
	amount DECIMAL(10, 2),
	FOREIGN KEY (rental_id) REFERENCES rental (rental_id )
);

-- 12. Cree un procedimiento `check_date_and_fine` que revise la tabla `rental` y cree un registro en la tabla `fines` por cada `rental` cuya devolución (return_date) haya tardado más de 3 días (comparación con rental_date). El valor de la multa será el número de días de retraso multiplicado por 1.5.
delimiter %%
CREATE PROCEDURE check_date_and_fine()
BEGIN 

	INSERT INTO fines (rental_id, amount)
	SELECT rental_id, DATEDIFF(rental_date, return_date)*1.5
	FROM rental 
	WHERE DATEDIFF(rental_date, return_date) >= 3;
END
delimiter ;

-- CALL check_date_and_fine();
-- 
-- SELECT rental_id 
-- FROM rental 
-- WHERE DATEDIFF(rental_date, return_date) >= 3;

-- 13. Crear un rol `employee` que tenga acceso de inserción, eliminación y actualización a la tabla `rental`.
CREATE ROLE `employee`;
GRANT INSERT, DELETE, UPDATE ON `rental` TO `employee`;

-- 14. Revocar el acceso de eliminación a `employee` y crear un rol `administrator` que tenga todos los privilegios sobre la BD `sakila`.
REVOKE DELETE ON rental from employee;
CREATE ROLE administrator;
GRANT ALL PRIVILEGES ON sakila.* TO administrator;

-- 15. Crear dos roles de empleado. A uno asignarle los permisos de `employee` y al otro de `administrator`.

CREATE ROLE Lautaro;
GRANT employee TO Lautaro;
CREATE ROLE Julieta;
GRANT administrator TO Julieta;

-- PRACTICO 6

USE classicmodels;

-- Ejercicio 1: Devuelva la oficina con mayor número de empleados.

-- Limitado
WITH employeesPerOffice AS (
	SELECT e.officeCode, COUNT(*) AS noOfEmployees 
	FROM employees e
	GROUP BY e.officeCode
	ORDER BY noOfEmployees DESC 
	LIMIT 1
)
SELECT *
FROM offices o
WHERE o.officeCode = (SELECT e.officeCode FROM employeesPerOffice AS e);

-- Completo
WITH employeesPerOffice AS (
	SELECT e.officeCode AS officeCode, COUNT(*) AS noOfEmployees 
	FROM employees e
	GROUP BY e.officeCode
)
SELECT o.*
FROM offices o 
	INNER JOIN employeesPerOffice epo ON (o.officeCode = epo.officeCode)
WHERE epo.noOfEmployees >= ALL (
	SELECT noOfEmployees
	FROM employeesPerOffice
)

-- Ejercicio 2: ¿Cuál es el promedio de órdenes hechas por oficina?, ¿Qué oficina vendió la mayor cantidad de productos?

WITH ordersPerOffice AS (
	SELECT COUNT(o.orderNumber) AS totalOrders
	FROM orders o
		INNER JOIN customers c ON (o.customerNumber = c.customerNumber)
		INNER JOIN employees e ON (c.salesRepEmployeeNumber = e.employeeNumber)
	GROUP BY e.officeCode
)
SELECT AVG(totalOrders) as "Average Orders by Office"
FROM ordersPerOffice;


WITH productsPerOrder AS (
	SELECT orderNumber, SUM(quantityOrdered) AS totalProducts
	FROM orderdetails
	GROUP BY orderNumber
), productsPerOffice AS (
	SELECT e.officeCode as officeCode, SUM(ppo.totalProducts) AS totalProducts
	FROM productsPerOrder ppo
		INNER JOIN orders o ON (ppo.orderNumber = o.orderNumber)
		INNER JOIN customers c ON (o.customerNumber = c.customerNumber)
		INNER JOIN employees e ON (c.salesRepEmployeeNumber = e.employeeNumber)
	GROUP BY e.officeCode
)
SELECT o.*, ppo.totalProducts
FROM offices o 
	INNER JOIN productsPerOffice ppo ON (o.officeCode = ppo.officeCode)
WHERE ppo.totalProducts >= ALL (
	SELECT totalProducts
	FROM productsPerOffice
);

-- Ejercicio 3: Devolver el valor promedio, máximo y mínimo de pagos que se hacen por mes.

SELECT MONTH(paymentDate) AS paymentMonth, AVG(amount) AS averagePaymentAmount, 
	MAX(amount) AS averagePaymentAmount, MIN(amount) AS minimumPaymentAmount
FROM payments
GROUP BY paymentMonth;

-- Ejercicio 4: Crear un procedimiento "Update Credit" en donde se modifique el límite de crédito de un cliente con un valor pasado por parámetro.

DELIMITER $$

CREATE PROCEDURE update_credit(
	IN cNo INT(11),
	IN amount DECIMAL(10, 2)
)
BEGIN
	UPDATE customers c
	SET c.creditLimit = c.creditLimit + amount
	WHERE c.customerNumber = cNo;
END;
$$

DELIMITER ;

CALL update_credit(103, 21000);

SELECT c.customerNumber, c.creditLimit
FROM customers c
WHERE c.customerNumber = 103;

-- Ejercicio 5: Cree una vista "Premium Customers" que devuelva el top 10 de clientes que más dinero han gastado en la plataforma. 
-- La vista deberá devolver el nombre del cliente, la ciudad y el total gastado por ese cliente en la plataforma.

CREATE VIEW PremiumCustomers AS
	WITH customerSpending AS (
		SELECT p.customerNumber, SUM(amount) AS customerTotalSpent
		FROM payments p
		GROUP BY p.customerNumber
	)
	SELECT c.customerName, c.city, cp.customerTotalSpent
	FROM customers c
		INNER JOIN customerSpending cp ON (c.customerNumber = cp.customerNumber)
	ORDER BY customerTotalSpent DESC
	LIMIT 10;

SELECT * FROM PremiumCustomers;

-- Ejercicio 6: Cree una función "employee of the month" que tome un mes y un año y devuelve el empleado (nombre y apellido) cuyos 
-- clientes hayan efectuado la mayor cantidad de órdenes.

DELIMITER $$

CREATE OR REPLACE PROCEDURE employees_of_the_month(
	IN imonth INT,
	IN iyear INT
)
BEGIN
	WITH ordersByCustomer AS (
		SELECT customerNumber, COUNT(orderNumber) AS amountOfOrders
		FROM orders
		WHERE MONTH(orderDate) = imonth AND YEAR(orderDate) = iyear
		GROUP BY customerNumber
	), ordersByEmployee AS (
		SELECT c.salesRepEmployeeNumber, SUM(amountOfOrders) AS amountOfOrders
		FROM customers c
			INNER JOIN ordersByCustomer obc ON (c.customerNumber = obc.customerNumber)
		GROUP BY c.salesRepEmployeeNumber
	)
	SELECT CONCAT(e.firstName, " ", e.lastName)
	FROM employees e
		INNER JOIN ordersByEmployee obe ON (e.employeeNumber = obe.salesRepEmployeeNumber)
	WHERE
		AND obe.amountOfOrders = (
			SELECT MAX(amountOfOrders) 
			FROM ordersByEmployee obe
			WHERE obe.monthOfOrder = imonth
				AND obe.yearOfOrder = iyear
		);
END;
$$

DELIMITER ;

CALL employees_of_the_month(4, 2004);

-- Ejercicio 7: Crear una nueva tabla "Product Refillment". Deberá tener una relación varios a uno con "products" y 
-- los campos: `refillmentID`, `productCode`, `orderDate`, `quantity`.

CREATE TABLE `productRefillment` (
  `refillmentID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `productCode` VARCHAR(15) NOT NULL,
  `orderDate` DATE NOT NULL,
  `quantity` INT(11) DEFAULT NULL,
  PRIMARY KEY (`refillmentID`),
  KEY `productCode` (`productCode`),
  CONSTRAINT `product_refillment_fk` FOREIGN KEY (`productCode`) REFERENCES `products` (`productCode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Ejercicio 8: Definir un trigger "Restock Product" que esté pendiente de los cambios efectuados 
-- en `orderdetails` y cada vez que se agregue una nueva orden revise la cantidad de productos 
-- pedidos (`quantityOrdered`) y compare con la cantidad en stock (`quantityInStock`) y si es 
-- menor a 10 genere un pedido en la tabla "Product Refillment" por 10 nuevos productos.

DELIMITER $$

CREATE OR REPLACE TRIGGER restock_product
	AFTER INSERT ON `orderdetails`
FOR EACH ROW
BEGIN
	DECLARE qtyStock INT;
	
	SELECT p.quantityOnStock INTO qtyStock
	FROM products p
	WHERE p.productCode = NEW.productCode;

	IF ((qtyStock - NEW.quantityOrdered) < 10)
	THEN 
		INSERT INTO productRefillment (productCode, orderDate, quantity)
			VALUES (NEW.productCode, CURDATE(), 10);
	END IF;
END;
$$

DELIMITER ;

-- Ejercicio 9: Crear un rol "Empleado" en la BD que establezca accesos de lectura a 
-- todas las tablas y accesos de creación de vistas.

CREATE ROLE empleado;
GRANT SELECT, CREATE VIEW ON classicmodels.* TO empleado;


-- PARCIAL RANDOM
/* Ejercicio 1
* Crear la tabla `credit_card`, deberá constar con los siguientes campos: 
* `number`: Número identificador de la tarjeta.
* `provider`: Nombre de la compañía proveedora.
* `expiration`: Fecha de expiración.
* `cvc`: Código de seguridad de 3 dígitos.
* Tener en cuenta a la hora de elegir los tipos de datos que sean lo más
* eficientes posibles.  Además, deberán coordinar con los valores que se
* definen en el archivo `credit_cards.sql`, que deberán cargar mediante el
* siguiente comando:
*     mysql -h <host> -u <user> -p<password> < credit_cards.sql
*/
CREATE TABLE `credit_card` (
    `number` CHAR(20) NOT NULL,
    `provider` VARCHAR(30) NOT NULL,
    `expiration` DATE NOT NULL,
    `cvc` CHAR(3) NOT NULL,
    CONSTRAINT creditCardPK PRIMARY KEY (`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* Ejercicio 2
* Modificar la tabla `user` para que se vea reflejada la relación entre `user`
* y `credit_card` que se muestra en el diagrama, creando la referencia
* correspondiente entre `user.credit_card` y `credit_card.number`.
*/

ALTER TABLE `user`
    ADD CONSTRAINT `creditCardFK` FOREIGN KEY (`credit_card`) REFERENCES `credit_card` (`number`);

/* Ejercicio 3
* Agregar la columna `purchase_credit` a la tabla `user`. Esta deberá ser un
* entero no nulo, que tome por defecto el valor 0.
*/

ALTER TABLE `user`
    ADD COLUMN `purchase_credit` INT NOT NULL DEFAULT 0;

/* Ejercicio 4
* Crear un procedimiento `set_purchase_credit` que tome como parámetro de
* entrada el nombre de un usuario y actualice el valor de `purchase_credit` de
* dicho usuario igual al valor sumado de los precios de los juegos que compró,
* multiplicado por 100.
*/

DELIMITER $$

CREATE OR REPLACE PROCEDURE set_purchase_credit(
    IN username VARCHAR(100)
)
BEGIN
    UPDATE `user` u
    SET u.purchase_credit = (
        SELECT SUM(g.price * 100) as total_credit
        FROM purchase p
            INNER JOIN game g ON (p.game = g.id)
            INNER JOIN `user` u ON (p.`user` = u.id)
        WHERE u.username = username
    )
    WHERE u.username = username;
END;
$$

DELIMITER ;

/* Ejercicio 5
* Crear una columna `purchased_with_credit` en la tabla `purchase` que tome un
* valor booleano no nulo falso por defecto.
*/

ALTER TABLE `purchase`
    ADD COLUMN `purchased_with_credit` BOOL NOT NULL DEFAULT False;

/* Ejercicio 6
* Crear un trigger `update_purchase_credit` que cada vez que se inserte un
* nuevo valor en la tabla `purchase` actualice el valor de `purchase_credit`
* del usuario: 
*     - Si la compra fue hecha con créditos de la plataforma (i.e. el valor de
*       `purchased_with_credit` es verdadero), se reste de `purchase_credit`
*       una cantidad de créditos igual al precio del juego multiplicado por
*       100. 
*     - En caso contrario, se sume a `purchase_credit` una cantidad de créditos
*       igual al precio del juego multiplicado por 100.
*/

DELIMITER $$

CREATE TRIGGER update_purchase_credit
    AFTER INSERT ON purchase 
    FOR EACH ROW
BEGIN
    IF NEW.purchased_with_credit > 0
    THEN 
        UPDATE `user` u
        SET u.purchase_credit = u.purchase_credit - (SELECT g.price FROM game g WHERE g.id = NEW.game) * 100
        WHERE u.id = NEW.`user`;
    ELSE
        UPDATE `user` u
        SET u.purchase_credit = u.purchase_credit + (SELECT g.price FROM game g WHERE g.id = NEW.game) * 100
        WHERE u.id = NEW.`user`;
    END IF;
END;
$$

DELIMITER ;


/* Ejercicio 7
* Listar el proveedor de tarjeta de crédito junto a los precios promedio,
* máximo y mínimo de los juegos comprados, por proveedor de tarjeta de crédito,
* de aquellos proveedores que tengan más de 225 clientes.
*/

WITH providers_users AS (
    SELECT cc.provider, COUNT(*) AS providers_users
    FROM credit_card cc
    GROUP BY cc.provider
    HAVING providers_users > 225
)
SELECT cc.provider, AVG(g.price), MAX(g.price), MIN(g.price)
FROM `user` u
    INNER JOIN credit_card cc ON (u.credit_card = cc.`number`)
    INNER JOIN purchase p ON (p.`user` = u.id)
    INNER JOIN game g ON (g.id = p.game)
WHERE cc.provider IN (SELECT provider FROM providers_users)
GROUP BY cc.provider;


/* Ejercicio 8
* Devolver los 5 géneros más populares de acuerdo al total de horas jugadas
* junto con las horas jugadas totales de dicho género.
*/

SELECT g.name, SUM(p.hours_played) AS total_hours_played
FROM genre g
    INNER JOIN game_genres gg ON (gg.genre = g.id)
    INNER JOIN purchase p ON (p.game = gg.game)
GROUP BY g.name
ORDER BY total_hours_played DESC 
LIMIT 5;

/* Ejercicio 9
* Crear la vista `top_selling_companies`. Esta listará las compañías que sean
* desarrolladoras (developers) o distribuidoras (publishers) de alguno de los
* 100 juegos más vendidos. Devolver la compañía y el total de ventas de juegos
* en los que dicha compañía participó (ya sea como desarrolladora o como
* distribuidora) ordenado de manera descendente de acuerdo a la cantidad de
* ventas.
*/

CREATE VIEW top_selling_companies AS
    WITH top_games AS (
        SELECT p.game, COUNT(*) AS total_game_sold
        FROM purchase p
        GROUP BY p.game
        ORDER BY total_game_sold DESC 
        LIMIT 100
    ), top_companies AS (
        SELECT c.name, tg.total_game_sold
        FROM company c
            INNER JOIN publishers p ON (c.id = p.publisher)
            INNER JOIN top_games tg ON (p.game = tg.game)
        UNION ALL
        SELECT c.name, tg.total_game_sold
        FROM company c
            INNER JOIN developers d ON (c.id = d.developer)
            INNER JOIN top_games tg ON (d.game = tg.game)
    )
    SELECT name, SUM(total_game_sold) AS total_company_sold_games
    FROM top_companies
    GROUP BY name
    ORDER BY total_company_sold_games DESC;

/* Ejercicio 10
* Crear el rol `game_seller` y asignarle permisos de lectura e inserción sobre
* la tabla `purchase` y permiso de actualización sobre la columna
* `purchased_with_credit` de la tabla `purchase`.
*/

CREATE ROLE game_seller;
GRANT SELECT, INSERT, UPDATE (purchased_with_credit) ON purchase TO game_seller;

-- PARCIAL 2022 
/* Ejercicio 1
* Crear la tabla `reviews` que tendrá los reviews hechos por los usuarios de
* distintos juegos, deberá constar con los siguientes campos:
* `user`: Usuario que hizo la review. Debe estar asociado a un usuario existente.
* `game`: Juego al que corresponde la review. Debe estar asociado a un juego existente.
* `rating`: Rating asignado. Es un valor de punto fijo asignado al rating de la review.
* El valor puede estar entre 0 y 5 y puede tener 1 valor decimal. No debe ser nulo.
* `comment`: Es un texto, que puede ser nulo, de un máximo de 250 caracteres.
*
* Un usuario sólo puede hacer 1 review por juego, por lo que deberán asegurar unicidad.
*
* Tener en cuenta a la hora de elegir los tipos de datos que sean lo más
* eficientes posibles.  Además, deberán coordinar con los valores que se
* definen en el archivo `reviews.sql`, que deberán cargar mediante el
* siguiente comando:
*     mysql -h <host> -u <user> -p<password> < reviews.sql
*/

DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user` INT NOT NULL,
    `game` INT NOT NULL,
    `rating` DECIMAL(2,1) NOT NULL,
    `comment` VARCHAR(250),
    CONSTRAINT reviewPK PRIMARY KEY (`id`),
    CONSTRAINT userFK FOREIGN KEY (`user`) REFERENCES `user` (`id`),
    CONSTRAINT gameFK FOREIGN KEY (`game`) REFERENCES `game` (`id`),
    CONSTRAINT uniqueUserGame UNIQUE (`user`, `game`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* Ejercicio 2
* Eliminar de la tabla `reviews` todas aquellas filas cuyo campo `comment` sea nulo
* y modificar la tabla `reviews` de manera que no acepte valores nulos en el campo
* `comment`.
*/
DELETE FROM `reviews` WHERE `comment` IS NULL;
ALTER TABLE `reviews` MODIFY `comment` VARCHAR(250) NOT NULL;

/* Ejercicio 3
* Devolver el nombre y el rating promedio del género con mayor rating promedio y
* del género con menor rating promedio. Deberán realizar una sóla consulta para
* dicha tarea.
*/
WITH genres_ratings AS (
    SELECT gg.genre, AVG(rvw.rating) AS avg_rating
    FROM game_genres gg
        INNER JOIN game g ON (gg.game = g.id)
        INNER JOIN reviews rvw ON (g.id = rvw.game)
    GROUP BY gg.genre
), max_min_rating AS (
    SELECT MAX(gr.avg_rating) AS max_rating, MIN(gr.avg_rating) AS min_rating
    FROM genres_ratings gr
), max_genre_rating AS (
    SELECT gr.genre, gr.avg_rating
    FROM genres_ratings gr, max_min_rating mmr
    WHERE gr.avg_rating = mmr.max_rating
), min_genre_rating AS (
    SELECT gr.genre, gr.avg_rating
    FROM genres_ratings gr, max_min_rating mmr
    WHERE gr.avg_rating = mmr.min_rating
)
SELECT gnr.name, mgr.avg_rating
FROM genre gnr
 INNER JOIN max_genre_rating mgr ON (gnr.id = mgr.genre)
UNION
SELECT gnr.name, mgr.avg_rating
FROM genre gnr
 INNER JOIN min_genre_rating mgr ON (gnr.id = mgr.genre);

/* Ejercicio 4
* Agregar una columna a la tabla `user` llamada `number_of_reviews` que deberá
* ser un entero. La columna deberá tener por defecto el valor 0 y no podrá ser
* nula.
*/
ALTER TABLE `user`
    ADD COLUMN `number_of_reviews` INT NOT NULL DEFAULT 0;

/* Ejercicio 5
* Crear un procedimiento `set_user_number_of_reviews` que tomará un nombre de
* usuario y actualizará el valor `number_of_reviews` de acuerdo a la cantidad de
* review hechos por dicho usuario.
*/
DELIMITER $$

CREATE OR REPLACE PROCEDURE set_user_number_of_reviews(
    IN username VARCHAR(100)
)
BEGIN
    UPDATE `user` u
    SET u.number_of_reviews = (
        SELECT COUNT(*)
        FROM reviews r
            INNER JOIN `user` u ON (r.`user` = u.id)
        WHERE u.username = username
    )
    WHERE u.username = username;
END;
$$

DELIMITER ;

/* Ejercicio 6
* Crear dos triggers:
*     a. Un trigger llamado `increase_number_of_reviews` que incrementará en 1 el
*     valor del campo `number_of_reviews` de la tabla `user`.
*     b. Un trigger llamado `decrease_number_of_reviews` que decrementará en 1 el
*     valor del campo `number_of_reviews` de la tabla `user`.
* El primer trigger se ejecutará luego de un `INSERT` en la tabla `reviews` y
* deberá actualizar el valor en la tabla `user` de acuerdo al valor introducido
* (i.e. sólo aumentará en 1 el valor de `number_of_reviews` para el usuario que
* hizo la review). Análogamente, el segundo trigger se ejecutará luego de un
* `DELETE` en la tabla `reviews` y sólo actualizará el valor en `user`
* correspondiente.
*/
DELIMITER $$

CREATE TRIGGER `increase_number_of_reviews`
    AFTER INSERT ON `reviews`
    FOR EACH ROW
BEGIN
    UPDATE `user` u
    SET u.number_of_reviews = u.number_of_reviews + 1
    WHERE u.id = NEW.`user`;
END;
$$

CREATE TRIGGER `decrease_number_of_reviews`
    BEFORE DELETE ON `reviews`
    FOR EACH ROW
BEGIN
    UPDATE `user` u
    SET u.number_of_reviews = u.number_of_reviews - 1
    WHERE u.id = NEW.`user`;
END;
$$

DELIMITER ;

/* Ejercicio 7
* Devolver el nombre y el rating promedio de las 5 compañías desarrolladoras
* (i.e. pertenecientes a la tabla `developers`) con mayor rating promedio, entre
* aquellas compañías que hayan desarrollado un mínimo de 50 juegos.
*/
WITH more_than_50_developed_games AS (
    SELECT d.developer, COUNT(*) AS developed_games
    FROM developers d
    GROUP BY d.developer
    HAVING developed_games >= 50
), developer_rating AS (
    SELECT d.developer, AVG(r.rating) rating
    FROM developers d
        INNER JOIN reviews r ON (r.game = d.game)
    GROUP BY d.developer
)
SELECT c.name, dr.rating
FROM company c
    INNER JOIN developer_rating dr ON (dr.developer = c.id)
    INNER JOIN more_than_50_developed_games mdg ON (mdg.developer = c.id)
ORDER BY rating DESC
LIMIT 5;

/* Ejercicio 8
* Crear el rol `moderator` y asignarle permisos de eliminación sobre la tabla
* `reviews` y permiso de actualización sobre la columna `comment` de la tabla
* `reviews`.
*/
CREATE ROLE moderator;
GRANT DELETE, UPDATE (comment) ON reviews TO moderator;


/* Ejercicio 9
* Actualizar la tabla `user` de manera que `user.number_of_reviews` refleje
* correctamente la cantidad de reviews hechas por el usuario. Hint: Este
* ejercicio se resuelve haciendo uso de `INSERT INTO … ON DUPLICATE KEY UPDATE`.
* Punto Extra: Este ejercicio suma hasta 1 punto, pero no resta.
*/

INSERT INTO `user` (`id`, `username`, `number_of_reviews`)
SELECT * FROM (
    SELECT r.`user`, u.`username`, COUNT(*) AS number_of_reviews
    FROM reviews r INNER JOIN `user` u ON (u.id = r.`user`)
    GROUP BY 1, 2
) AS nr
ON DUPLICATE KEY UPDATE `user`.number_of_reviews = nr.number_of_reviews;

-- PARCIAL 2020
/* Ejercicio 1
* Crear la tabla `credit_card`, deberá constar con los siguientes campos: 
* `number`: Número identificador de la tarjeta.
* `provider`: Nombre de la compañía proveedora.
* `expiration`: Fecha de expiración.
* `cvc`: Código de seguridad de 3 dígitos.
* Tener en cuenta a la hora de elegir los tipos de datos que sean lo más
* eficientes posibles.  Además, deberán coordinar con los valores que se
* definen en el archivo `credit_cards.sql`, que deberán cargar mediante el
* siguiente comando:
*     mysql -h <host> -u <user> -p<password> < credit_cards.sql
*/
CREATE TABLE `credit_card` (
    `number` CHAR(20) NOT NULL,
    `provider` VARCHAR(30) NOT NULL,
    `expiration` DATE NOT NULL,
    `cvc` CHAR(3) NOT NULL,
    CONSTRAINT creditCardPK PRIMARY KEY (`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* Ejercicio 2
* Modificar la tabla `user` para que se vea reflejada la relación entre `user`
* y `credit_card` que se muestra en el diagrama, creando la referencia
* correspondiente entre `user.credit_card` y `credit_card.number`.
*/

ALTER TABLE `user`
    ADD CONSTRAINT `creditCardFK` FOREIGN KEY (`credit_card`) REFERENCES `credit_card` (`number`);

/* Ejercicio 3
* Agregar la columna `purchase_credit` a la tabla `user`. Esta deberá ser un
* entero no nulo, que tome por defecto el valor 0.
*/

ALTER TABLE `user`
    ADD COLUMN `purchase_credit` INT NOT NULL DEFAULT 0;

/* Ejercicio 4
* Crear un procedimiento `set_purchase_credit` que tome como parámetro de
* entrada el nombre de un usuario y actualice el valor de `purchase_credit` de
* dicho usuario igual al valor sumado de los precios de los juegos que compró,
* multiplicado por 100.
*/

DELIMITER $$

CREATE OR REPLACE PROCEDURE set_purchase_credit(
    IN username VARCHAR(100)
)
BEGIN
    UPDATE `user` u
    SET u.purchase_credit = (
        SELECT SUM(g.price * 100) as total_credit
        FROM purchase p
            INNER JOIN game g ON (p.game = g.id)
            INNER JOIN `user` u ON (p.`user` = u.id)
        WHERE u.username = username
    )
    WHERE u.username = username;
END;
$$

DELIMITER ;

/* Ejercicio 5
* Crear una columna `purchased_with_credit` en la tabla `purchase` que tome un
* valor booleano no nulo falso por defecto.
*/

ALTER TABLE `purchase`
    ADD COLUMN `purchased_with_credit` BOOL NOT NULL DEFAULT False;

/* Ejercicio 6
* Crear un trigger `update_purchase_credit` que cada vez que se inserte un
* nuevo valor en la tabla `purchase` actualice el valor de `purchase_credit`
* del usuario: 
*     - Si la compra fue hecha con créditos de la plataforma (i.e. el valor de
*       `purchased_with_credit` es verdadero), se reste de `purchase_credit`
*       una cantidad de créditos igual al precio del juego multiplicado por
*       100. 
*     - En caso contrario, se sume a `purchase_credit` una cantidad de créditos
*       igual al precio del juego multiplicado por 100.
*/

DELIMITER $$

CREATE TRIGGER update_purchase_credit
    AFTER INSERT ON purchase 
    FOR EACH ROW
BEGIN
    IF NEW.purchased_with_credit > 0
    THEN 
        UPDATE `user` u
        SET u.purchase_credit = u.purchase_credit - (SELECT g.price FROM game g WHERE g.id = NEW.game) * 100
        WHERE u.id = NEW.`user`;
    ELSE
        UPDATE `user` u
        SET u.purchase_credit = u.purchase_credit + (SELECT g.price FROM game g WHERE g.id = NEW.game) * 100
        WHERE u.id = NEW.`user`;
    END IF;
END;
$$

DELIMITER ;


/* Ejercicio 7
* Listar el proveedor de tarjeta de crédito junto a los precios promedio,
* máximo y mínimo de los juegos comprados, por proveedor de tarjeta de crédito,
* de aquellos proveedores que tengan más de 225 clientes.
*/

WITH providers_users AS (
    SELECT cc.provider, COUNT(*) AS providers_users
    FROM credit_card cc
    GROUP BY cc.provider
    HAVING providers_users > 225
)
SELECT cc.provider, AVG(g.price), MAX(g.price), MIN(g.price)
FROM `user` u
    INNER JOIN credit_card cc ON (u.credit_card = cc.`number`)
    INNER JOIN purchase p ON (p.`user` = u.id)
    INNER JOIN game g ON (g.id = p.game)
WHERE cc.provider IN (SELECT provider FROM providers_users)
GROUP BY cc.provider;


/* Ejercicio 8
* Devolver los 5 géneros más populares de acuerdo al total de horas jugadas
* junto con las horas jugadas totales de dicho género.
*/

SELECT g.name, SUM(p.hours_played) AS total_hours_played
FROM genre g
    INNER JOIN game_genres gg ON (gg.genre = g.id)
    INNER JOIN purchase p ON (p.game = gg.game)
GROUP BY g.name
ORDER BY total_hours_played DESC 
LIMIT 5;

/* Ejercicio 9
* Crear la vista `top_selling_companies`. Esta listará las compañías que sean
* desarrolladoras (developers) o distribuidoras (publishers) de alguno de los
* 100 juegos más vendidos. Devolver la compañía y el total de ventas de juegos
* en los que dicha compañía participó (ya sea como desarrolladora o como
* distribuidora) ordenado de manera descendente de acuerdo a la cantidad de
* ventas.
*/

CREATE VIEW top_selling_companies AS
    WITH top_games AS (
        SELECT p.game, COUNT(*) AS total_game_sold
        FROM purchase p
        GROUP BY p.game
        ORDER BY total_game_sold DESC 
        LIMIT 100
    ), top_companies AS (
        SELECT c.name, tg.total_game_sold
        FROM company c
            INNER JOIN publishers p ON (c.id = p.publisher)
            INNER JOIN top_games tg ON (p.game = tg.game)
        UNION ALL
        SELECT c.name, tg.total_game_sold
        FROM company c
            INNER JOIN developers d ON (c.id = d.developer)
            INNER JOIN top_games tg ON (d.game = tg.game)
    )
    SELECT name, SUM(total_game_sold) AS total_company_sold_games
    FROM top_companies
    GROUP BY name
    ORDER BY total_company_sold_games DESC;

/* Ejercicio 10
* Crear el rol `game_seller` y asignarle permisos de lectura e inserción sobre
* la tabla `purchase` y permiso de actualización sobre la columna
* `purchased_with_credit` de la tabla `purchase`.
*/

CREATE ROLE game_seller;
GRANT SELECT, INSERT, UPDATE (purchased_with_credit) ON purchase TO game_seller;

-- PARCIAL 2019
USE bd17_g13_test;       
               

CREATE TABLE employee    
(
  fname CHAR(9) NOT NULL,
  minit CHAR(1),      
  lname CHAR(8) NOT NULL,
  ssn   CHAR(9) NOT NULL,
  bdate DATE, 
  address CHAR(25),   
  sex   CHAR(1),      
  salary DECIMAL(7,2),    
  superssn CHAR(9),   
  dno  INT DEFAULT 1 NOT NULL,
  CONSTRAINT employeePK PRIMARY KEY (ssn),
  CONSTRAINT empDeptFK FOREIGN KEY (dno) REFERENCES department(dnumber)
) ENGINE=InnoDB;
           
           
           
CREATE TABLE project 
(
  pname   CHAR(15)       NOT NULL,
  pnumber INT            NOT NULL,
  plocation CHAR(10), 
  dnum    INT            NOT NULL,
  CONSTRAINT projPK PRIMARY KEY (pnumber),
  CONSTRAINT projNameSK UNIQUE (pname),
  CONSTRAINT projDeptFK FOREIGN KEY (dnum) REFERENCES department(dnumber)
) ENGINE=InnoDB;
           
CREATE TABLE works_on    
(
  essn CHAR(9)           NOT NULL,
  pno  INT               NOT NULL,
  hours DECIMAL(5,1)     NOT NULL,
  CONSTRAINT workPK PRIMARY KEY (essn, pno),
  CONSTRAINT workEmpFK FOREIGN KEY (essn) REFERENCES employee(ssn),
  CONSTRAINT workProjFK FOREIGN KEY (pno) REFERENCES project(pnumber)
) ENGINE=InnoDB;                              
           
CREATE TABLE dependent   
(
  essn CHAR(9)           NOT NULL,
  name CHAR(10)          NOT NULL,
  sex  CHAR(1),       
  bdate DATE, 
  relationship CHAR(10),
  CONSTRAINT dependentPK PRIMARY KEY (essn, name),
  CONSTRAINT dependentEmpFK FOREIGN KEY (essn) REFERENCES employee(ssn)
) ENGINE=InnoDB;


--PARCIAL 2021
-- 1. Modifique la tabla `advisor` de manera que cada par sea único.


--DROP DATABASE IF EXISTS world;

--CREATE DATABASE world;

--USE world;
-- verifico que no haya duplicados
DELETE FROM advisor 
WHERE(s_id, i_id) IN (
	SELECT s_id, i_id
	FROM advisor
	GROUP BY s_id, i_id
	HAVING COUNT(*) > 1
);

-- AGREGO LA RENSTRICCION UNICA
ALTER TABLE advisor
ADD CONSTRAINT unico_advisor UNIQUE (s_id, i_id)

-- 2. Crear la tabla `thesis`, deberá constar con los siguientes campos:
--a. `student_id`: ID del estudiante de la tesis.
--b. `director_id`: ID del director de la tesis.
--c. `codirector_id`: ID del codirector de la tesis (opcional).
--d. `title`: Título único de la tesis (máximo de 100 caracteres).
--e. `pages`: Número de páginas de la tesis.
--La clave primaria está dada por la tupla (`student_id`, `title`).

CREATE TABLE thesis  (
	student_id INT NOT NULL,
	director_id INT NOT NULL,
	codirector_id INT,
	title varchar(255) NOT NULL,
	pages INT 
	PRIMARY KEY(student_id,title)
)

-- 3. Listar el top-10 de departamentos por número de tesistas.

SELECT department_name, COUNT(DISTINCT student_id) AS num_tesistas
FROM department
JOIN student ON department.director = student.student_id
JOIN thesis ON student.student_id = thesis.advisor_id OR student.student_id = thesis.co_advisor_id
GROUP BY department_name
ORDER BY num_tesistas DESC
LIMIT 10;


--4. Listar el nombre del estudiante, nombre del director
-- y título de la tesis de aquellos
--directores que tienen más de 45 estudiantes a cargo.
SELECT s.student_name, d.student_name AS director_name, t.title
FROM student s, thesis t, student d
WHERE s.student_id = t.student_id
AND t.director_id = d.student_id
AND d.student_id IN (
    SELECT director
    FROM department
    JOIN student ON department.director = student.student_id
    JOIN thesis ON student.student_id = thesis.advisor_id OR student.student_id = thesis.co_advisor_id
    GROUP BY director
    HAVING COUNT(DISTINCT student_id) > 45
)
ORDER BY d.student_name;


/*5. Crear 2 triggers, `add_advisor` y `remove_advisor`, estos se ejecutarán cuando se
cree o elimine un registro en la tabla `thesis` y deberán crear o eliminar un registro
en la tabla `advisor` que refleje al estudiante y a sus directores (i.e. si el codirector
no es nulo, deberá crear/eliminar 2 entradas, una del estudiante y el director y otra
del estudiante y el codirector).*/

DELIMITER ;
CREATE TRIGGER add_advisor AFTER INSERT ON thesis
FOR EACH ROW
BEGIN
    INSERT INTO advisor (student_id, advisor_id)
    VALUES (NEW.student_id, NEW.director_id);
    IF NEW.codirector_id IS NOT NULL THEN
        INSERT INTO advisor (student_id, advisor_id)
        VALUES (NEW.student_id, NEW.codirector_id);
    END IF;
END;

DELIMITER ;

DELIMITER //

CREATE TRIGGER remove_advisor AFTER DELETE ON thesis
FOR EACH ROW
BEGIN
    DELETE FROM advisor
    WHERE student_id = OLD.student_id AND advisor_id = OLD.director_id;
    
    IF OLD.codirector_id IS NOT NULL THEN
        DELETE FROM advisor
        WHERE student_id = OLD.student_id AND advisor_id = OLD.codirector_id;
    END IF;
END;
//

DELIMITER ;


/*6. Eliminar aquellas tesis de los departamentos que en total tengan menos de 50 tesis
(el departamento está dado por el director).
a. Hint: Esto se resuelve con consultas anidadas y sin utilizar CTE (no hay
soporte para CTE en un DELETE en MySQL).
b. Hint: Tengan en cuenta que a la hora de eliminar elementos de una tabla,
cuando se hace necesario utilizar joins, hay que declarar de qué tabla se está
eliminando (en esta caso, sólo eliminar de la tabla `thesis`).
*/
DELETE FROM thesis
WHERE director_id IN (
    SELECT director_id
    FROM (
        SELECT director_id, COUNT(*) AS total_tesis
        FROM thesis
        GROUP BY director_id
    ) AS director_tesis
    WHERE total_tesis < 50
);


/*7. Crear un procedimiento `update_student_dept_name` que tome el nombre de un
estudiante como dato de entrada, verifique si el nombre del departamento al que
pertenece dicho estudiante es el mismo que el de su director de tesis, y sólo en caso
de que no lo sea, lo actualice poniendo el nombre del departamento de su director
de tesis.
a. Hint: Pueden ver de llamar el procedimiento sólo sobre nombres que sean
únicos, aquí una lista: 'Abraham', 'Achilles', 'Adam', 'Adda', 'Baroni', 'Cole',
'Colin'.*/

DELIMITER //

CREATE PROCEDURE update_student_dept_name(IN student_name VARCHAR(50))
BEGIN
    DECLARE director_dept_name VARCHAR(50);

    -- Obtener el nombre del departamento del director de tesis del estudiante
    SELECT d.dept_name INTO director_dept_name
    FROM student s
    JOIN thesis t ON s.student_id = t.director_id
    JOIN student d ON t.director_id = d.student_id
    WHERE s.student_name = student_name;

    -- Actualizar el departamento del estudiante si es diferente al del director de tesis
    UPDATE student
    SET dept_name = director_dept_name
    WHERE student_name = student_name
    AND dept_name <> director_dept_name;
END;
//

DELIMITER ;

 --8. Crear un rol `administrative` que tenga permisos de lectura y eliminación sobre la
--tabla `instructor` y permisos de actualización sobre la columna `salary` de la tabla
--`instructor`
-- Crear el rol 'administrative'
CREATE ROLE administrative;

-- Otorgar permisos de lectura y eliminación sobre la tabla 'instructor'
GRANT SELECT, DELETE ON university.instructor TO administrative;

-- Otorgar permisos de actualización sobre la columna 'salary' de la tabla 'instructor'
GRANT UPDATE (salary) ON university.instructor TO administrative;

-- RECUP 2022
USE `bicyclestores`;



CREATE TABLE `stocks` (
	store_id int NOT NULL, 
	product_id int NOT NULL, 
	`quantity` int DEFAULT 0,
	FOREIGN KEY (store_id) REFERENCES stores(store_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id),
	PRIMARY KEY (store_id, product_id)
);

-- 2 Listar los precios de lista máximos y mínimos en cada categoría retornando solamente aquellas categorías que tiene el  precio de lista máximo superior a 5000 o el precio de lista mínimo inferior a 400.
SELECT p.category_id, MAX(list_price) AS max_price, MIN(p.list_price) AS min_price
FROM products p
WHERE list_price < 4000 OR list_price > 5000
GROUP BY p.category_id;

-- 3 Crear un procedimiento `add_product_stock_to_store` que tomará un nombre de store, un nombre de producto y una cantidad entera donde actualizará la cantidad del producto en la store especificada (i.e., solo sumará el valor de entrada al valor corriente en la tabla `stocks`).

delimiter // 

CREATE PROCEDURE `add_product_stock_to_store` (
	IN storeName varchar(255), 
	IN productName varchar(255),
	IN newQTY int
)
BEGIN 
	DECLARE storeID int;
	DECLARE productID int;
	
	SELECT p.product_id 
	INTO productID
	FROM products p 
	WHERE p.product_name = productName;

	SELECT s.store_id 
	INTO storeID
	FROM stores s
	WHERE s.store_name = storeName;

	UPDATE stocks
	SET quantity = quantity + newQTY
	WHERE 
		store_id = storeID 
		AND 
		product_id = productID;
END;
//
delimiter ;


-- 4 Crear un trigger llamado `decrease_product_stock_on_store` que decrementará el valor del campo `quantity` de la tabla `stocks` con el valor del campo `quantity` de la tabla `order_items`.
-- El trigger se ejecutará luego de un `INSERT` en la tabla `order_items` y deberá actualizar el valor en la tabla `stocks` de acuerdo al valor correspondiente.

delimiter //
CREATE TRIGGER `decrease_product_stock_on_store`
AFTER INSERT ON `order_items`
FOR EACH ROW 
BEGIN 
	-- tengo la cantidad en NEW.quantity
	-- tengo el producto en NEW.product_id
	
	-- me falta saber que store fue, la cual esta en orders
	DECLARE storeID int;

	SELECT store_id 
	INTO storeID
	FROM orders o 
	WHERE o.order_id = NEW.order_id;
	
	UPDATE stocks 
	SET quantity = (quantity - NEW.quantity)
	WHERE 
		store_id = storeID  
		AND 
		product_id = NEW.product_id;
END;
//
delimiter ;

-- 5 Devuelva el precio de lista promedio por brand para todos los productos con modelo de año (`model_year`) entre 2016 y 2018.
SELECT p.brand_id, avg(p.list_price)
FROM products p 
WHERE model_year > 2016 AND model_year < 2018
GROUP BY p.brand_id;

-- 6 Liste el número de productos y ventas para cada categoría de producto. Tener en cuenta que una venta (`orders` table) es completada cuando la columna `order_status` = 4.
SELECT 
	p.category_id AS "categoria", 
	count(oi.product_id) AS "numero de productos", 
	count(DISTINCT oi.order_id) AS "cantidad de ordenes"
FROM orders o 
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON p.product_id = oi.product_id 
WHERE o.order_status = 4
GROUP BY p.category_id;

-- 7 Crear el rol `human_care_dept` y asignarle permisos de creación sobre la tabla `staffs` y permiso de actualización sobre la columna `active` de la tabla `staffs`.

CREATE ROLE `human_care_dept`;
GRANT CREATE, UPDATE ON staffs.active TO `human_care_dept`;



.-- PARCIAL 2021
USE `university`;

DROP TABLE thesis;

#Ej 1
#Modifique la tabla `advisor` de manera que cada par sea único.
ALTER TABLE `advisor` ADD UNIQUE (s_ID);
ALTER TABLE `advisor` ADD UNIQUE (i_ID);

#Ej 2
CREATE TABLE `thesis`(
    `student_id` varchar(5) NOT NULL,
    `director_id` varchar(5) NOT NULL,
    `codirector_id` varchar(5),
    `title` varchar(100) NOT NULL,
    `pages` int NOT NULL,
    PRIMARY KEY (`student_id`,`title`),
    FOREIGN KEY (student_id) REFERENCES student (ID),
    FOREIGN KEY (director_id) REFERENCES instructor (ID),
    FOREIGN KEY (codirector_id) REFERENCES instructor (ID)
);

#Ej 3
#Listar el top-10 de departamentos por número de tesistas.

WITH `thesists` AS (
    SELECT s.id , t.director_id, i.dept_name FROM `student` s
    INNER JOIN `thesis` t ON s.ID = t.student_id
    INNER JOIN `instructor` i ON t.director_id = i.ID
)

SELECT `dept_name`,COUNT(*) AS n_thesists FROM `thesists`
GROUP BY `dept_name` ORDER BY n_thesists DESC  LIMIT 10 ;

#Ej 4
/*4. Listar el nombre del estudiante, nombre del director y título de la tesis de aquellos
directores que tienen más de 45 estudiantes a cargo.*/

WITH `popular_instructors` AS (
    SELECT `director_id` FROM (
        SELECT `director_id`,COUNT(*) AS n_students FROM `thesis` t
        GROUP BY `director_id` 
    ) AS `directors_student_count`
    WHERE n_students > 45
)

SELECT s.name , d.name , t.title FROM `student` s 
INNER JOIN thesis t ON s.ID = t.student_id 
INNER JOIN `instructor` d ON t.director_id = d.ID
WHERE d.name IN (
    SELECT `name` FROM `instructor` i 
    WHERE ID IN (SELECT director_id FROM popular_instructors)
);


/*5. Crear 2 triggers, `add_advisor` y `remove_advisor`, estos se ejecutarán cuando se
cree o elimine un registro en la tabla `thesis` y deberán crear o eliminar un registro
en la tabla `advisor` que refleje al estudiante y a sus directores (i.e. si el codirector
no es nulo, deberá crear/eliminar 2 entradas, una del estudiante y el director y otra
del estudiante y el codirector).*/

delimiter //
CREATE TRIGGER `add_advisor` AFTER INSERT ON `thesis`
FOR EACH ROW 
BEGIN 
    INSERT INTO `advisor`(a_ID,s_ID,i_ID) VALUES (NEW.student_id,NEW.director_id);
    IF NEW.codirector_id IS NOT NULL THEN
        INSERT INTO advisor VALUES (NEW.student_id,NEW.codirector_id);
    END IF;
END//
delimiter ;

delimiter //
CREATE TRIGGER `remove_advisor` AFTER DELETE ON `thesis`
FOR EACH ROW 
BEGIN 
    DELETE FROM `advisor` a
    WHERE a.s_ID = OLD.student_id
    AND 
    a.i_ID = OLD.director_id;
END//
delimiter ;


/*
6. Eliminar aquellas tesis de los departamentos que en total tengan menos de 50 tesis
(el departamento está dado por el director).
a. Hint: Esto se resuelve con consultas anidadas y sin utilizar CTE (no hay
soporte para CTE en un DELETE en MySQL).
b. Hint: Tengan en cuenta que a la hora de eliminar elementos de una tabla,
cuando se hace necesario utilizar joins, hay que declarar de qué tabla se está
eliminando (en esta caso, sólo eliminar de la tabla `thesis`).
*/

DELETE FROM `thesis`
WHERE `director_id` IN (
    SELECT `ID` FROM `instructor` i2
    WHERE i2.dept_name IN (
        SELECT `dept` FROM (
            SELECT i.dept_name AS dept, COUNT(*) AS cou FROM `thesis` t 
            INNER JOIN instructor i ON t.director_id = i.ID
            GROUP BY i.dept_name
        ) AS `depts_thesis` WHERE cou < 50
    )
);

/*
7. Crear un procedimiento `update_student_dept_name` que tome el nombre de un
estudiante como dato de entrada, verifique si el nombre del departamento al que
pertenece dicho estudiante es el mismo que el de su director de tesis, y sólo en caso
de que no lo sea, lo actualice poniendo el nombre del departamento de su director
de tesis.
a. Hint: Pueden ver de llamar el procedimiento sólo sobre nombres que sean
únicos, aquí una lista: 'Abraham', 'Achilles', 'Adam', 'Adda', 'Baroni', 'Cole',
'Colin'.
*/
 
delimiter //
CREATE PROCEDURE `update_student_dept_name` (IN student_name varchar(20)) BEGIN
    WITH rebel_students AS (
        SELECT s.name AS sname,i.dept_name AS dname FROM `thesis` t 
        INNER JOIN instructor i ON t.director_id = i.ID 
        INNER JOIN student s ON t.student_id = s.ID 
        WHERE i.dept_name <> s.dept_name
    )
    
    UPDATE `student` s
    SET dept_name = (SELECT dname FROM rebel_students rs WHERE rs.sname = student_name)
    WHERE s.name IN (SELECT sname FROM rebel_students);
END //
delimiter ; 

/*
8. Crear un rol `administrative` que tenga permisos de lectura y eliminación sobre la
tabla `instructor` y permisos de actualización sobre la columna `salary` de la tabla
`instructor`
*/

CREATE ROLE administrative;

GRANT SELECT , DELETE 
ON instructor
TO administrative;

GRANT UPDATE 
ON instructor.salary 
TO administrative;








































