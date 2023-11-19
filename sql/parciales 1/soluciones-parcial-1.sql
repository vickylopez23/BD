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
