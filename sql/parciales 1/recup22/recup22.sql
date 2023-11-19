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


