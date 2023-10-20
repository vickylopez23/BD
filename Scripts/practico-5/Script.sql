
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

-- 5. Listar, ordenados por cantidad de películas (de mayor a menor), 
-- los distintos ratings de las películas existentes 
-- (Hint: rating se refiere en este caso a la clasificación según edad: G, PG, R, etc). 


SELECT f.rating, COUNT(DISTINCT f.film_id)
FROM film f
GROUP BY (f.rating)


-- SELECT rating, COUNT(*) AS amount 
-- FROM film
-- GROUP BY rating 
-- ORDER BY amount DESC;

-- 6. ¿Cuáles fueron la primera y última fecha donde hubo pagos?
-- primera
SELECT MIN(payment_date) AS opening, MAX(payment_date) AS closing 
FROM payment;

-- 7. Calcule, por cada mes, el promedio de pagos (Hint: vea la manera de extraer el nombre del mes de una fecha).
SELECT MONTHNAME(payment_date) AS month_of_payments, AVG(amount) 
FROM payment
GROUP BY month_of_payments;



-- 8. Listar los 10 distritos que tuvieron mayor cantidad de alquileres (con la cantidad total de alquileres). 

WITH rental_districts AS (
	SELECT rental_id, c.customer_id, district
	FROM rental r 
		INNER JOIN customer c ON (r.customer_id = c.customer_id)
		INNER JOIN address a ON (c.address_id = a.address_id)
)
SELECT district, COUNT(*) AS total_rentals
FROM rental_districts
GROUP BY district
ORDER BY total_rentals DESC
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


