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
	IN amount DECIMAL(10, 2) -- nuevo limite para el cliente
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


CREATE VIEW  PremiumCustomers AS
	WITH customerSpendig AS (
	
	)
SELECT



