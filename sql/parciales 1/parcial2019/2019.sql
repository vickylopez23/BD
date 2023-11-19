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

