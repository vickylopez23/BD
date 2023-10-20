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
