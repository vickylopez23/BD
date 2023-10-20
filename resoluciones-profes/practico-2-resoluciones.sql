USE `world`;

-- ******* 
-- Parte I
-- *******

-- Ejercicio 3: Crear una tabla `continent`
DROP TABLE IF EXISTS `continent`;
CREATE TABLE `continent` (
  `Name` char(52) NOT NULL,
  `Area` int NOT NULL,
  `PercentTotalMass` decimal(5,2) NOT NULL,
  `MostPopulousCity` char(52) NOT NULL,
  PRIMARY KEY (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Ejercicio 4: Agregar valores a `continent`
INSERT INTO `continent` VALUES 
	('Africa', 30370000, 20.4, 'Cairo, Egypt'),
	('Antarctica', 14000000, '9.2', 'McCurdo Station'),
	('Asia', 44579000, '29.5', 'Mumbay, India'),
	('Europe', 10180000, '6.8', 'Instanbul, Turquia'),
	('North America', 24709000, '16.5', 'Ciudad de Mexico, Mexico'),
	('Oceania', 8600000, '5.9', 'Sydney, Australia'),
	('South America', 17840000, '12.0', 'São Pablo, Brazil');

-- Ejercicio 5 (estrella): Generar la referencia entre las tablas continent y country
ALTER TABLE `country`
	MODIFY COLUMN `Continent` char(52);
ALTER TABLE `country`
	ADD CONSTRAINT `continent_of_country` FOREIGN KEY (`Continent`) REFERENCES `continent` (`Name`);

