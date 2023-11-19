USE `bicyclestores`;

/*. Crear la tabla `stocks` que almacena la información de inventario, es decir, la
cantidad de un producto en particular en una store específica, deberá constar
con los siguientes campos:
a. `quantity`: representa la cantidad de un producto*/

CREATE TABLE IF NOT EXISTS `stocks` (
	store_id int NOT NULL, 
	product_id int NOT NULL, 
	`quantity` int DEFAULT 0,
	FOREIGN KEY (store_id) REFERENCES stores(store_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id),
	PRIMARY KEY (store_id, product_id)
);


/*2. Listar los precios de lista máximos y mínimos en cada categoría retornando
solamente aquellas categorías que tiene el precio de lista máximo superior a
5000 o el precio de lista mínimo inferior a 400*/

SELECT  p.category_id,MAX(list_prince) AS max_prince,
MIN(list_prince) AS min_prince
FROM products p
WHERE list_price < 4000 OR list_price > 5000
GROUP BY p.category_id;

/*3 Crear un procedimiento `add_product_stock_to_store` que tomará un nombre de store, 
 * un nombre de producto y una cantidad entera donde
 *  actualizará la cantidad del producto en la store
 *  especificada (i.e., solo sumará el valor de entrada 
 * al valor corriente en la tabla `stocks`*/
DELIMITER //

CREATE PROCEDURE add_product_stock_to_store(
    IN store_name_param VARCHAR(255),
    IN product_name_param VARCHAR(255),
    IN quantity_param INT
)
BEGIN
    DECLARE store_id_param INT;
    DECLARE product_id_param INT;

    -- Obtener el ID de la tienda en base al nombre proporcionado
    SELECT store_id INTO store_id_param
    FROM stores
    WHERE store_name = store_name_param;

    -- Obtener el ID del producto en base al nombre proporcionado
    SELECT product_id INTO product_id_param
    FROM products
    WHERE product_name = product_name_param;

    -- Actualizar la cantidad en la tabla stocks
    UPDATE stocks
    SET quantity = quantity + quantity_param
    WHERE store_id = store_id_param AND product_id = product_id_param;
END;
//

DELIMITER ;


-- 4 Crear un trigger llamado `decrease_product_stock_on_store` que decrementará el valor del campo `quantity` de la tabla `stocks` con el valor del campo `quantity` de la tabla `order_items`.
-- El trigger se ejecutará luego de un `INSERT` en la tabla `order_items` y deberá actualizar el valor en la tabla `stocks` de acuerdo al valor correspondiente.

DELIMITER;

CREATE TRIGGER decrease_product_stock_on_store
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE product_store_id INT;
    
    -- Obtener el store_id de la tienda asociada al pedido
    SELECT store_id INTO product_store_id
    FROM order_items
    WHERE order_id = NEW.order_id;
    
    -- Actualizar la cantidad en la tabla stocks
    UPDATE stocks
    SET quantity = quantity - NEW.quantity
    WHERE product_id = NEW.product_id AND store_id = product_store_id;
END;
//

DELIMITER ;

-- 5 Devuelva el precio de lista promedio por brand para todos
-- los productos con modelo de año (`model_year`) entre 2016 y 2018.


SELECT p.brand_id, avg(p.list_price)
FROM products p 
WHERE model_year > 2016 AND model_year < 2018
GROUP BY p.brand_id;


-- 6 Liste el número de productos y ventas para cada
-- categoría de producto. Tener en cuenta que una venta (`orders` table) es completada cuando la columna `order_status` = 4.

SELECT p.category, 
       COUNT(DISTINCT p.product_name) AS num_products, 
       COUNT(DISTINCT o.order_id) AS num_sales
FROM products p
LEFT JOIN order_items oi ON p.product_name = oi.product_name
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.order_status = 4
GROUP BY p.category;

SELECT 
	p.category_id AS "categoria", 
	count(oi.product_id) AS "numero de productos", 
	count(DISTINCT oi.order_id) AS "cantidad de ordenes"
FROM orders o 
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON p.product_id = oi.product_id 
WHERE o.order_status = 4
GROUP BY p.category_id;

-- 7 Crear el rol `human_care_dept` y 
--asignarle permisos de creación sobre la tabla `staffs` y permiso de actualización sobre la columna `active` de la tabla `staffs`.

CREATE ROLE `human_care_dept`;
GRANT CREATE, UPDATE ON staffs.active TO `human_care_dept`;





