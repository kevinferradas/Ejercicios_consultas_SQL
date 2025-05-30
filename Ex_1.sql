CREATE DATABASE empleados;
USE empleados;

create table empleados (
DNI varchar(9) NOT NULL PRIMARY KEY,
nombre varchar (100) NOT NULL,
apellidos varchar(255) NOT NULL,
id_departamento INT NOT NULL
);

create table departamentos (
id_departamento INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre varchar(100) NOT NULL,
presupuesto decimal(9,2) NOT NULL
);

INSERT INTO empleados (DNI, nombre, apellidos, id_departamento) VALUES
(123,Kevin, Ferradas,1),
(456,Renato, Lopez,2),
(789,Martin, Perez,2)
 ;

-- Obtener los apellidos de los empleados
SELECT apellidos from empleados;

-- Obtener los apellidos de los empleados sin repeticiones
SELECT DISTINCT apellidos from empleados;

-- Obtener todos los datos de los empleados que se apellidan ’LOPEZ’.
SELECT * from empleador WHERE apellidos = "Lopez";
SELECT * from empleador WHERE apellidos LIKE "Lopez";
SELECT * from empleador WHERE apellidos IN ("Lopez");

-- Obtener todos los datos de los empleados que se apellidan ’LOPEZ’ y los que se apellidan ’PEREZ’.

SELECT * from empleador WHERE apellidos = "Lopez" OR apellidos = "Perez";
SELECT * from empleador WHERE apellidos LIKE "Lopez" OR apellidos LIKE "Perez" ;
SELECT * from empleador WHERE apellidos IN ("Lopez","Perez");

--  Obtener todos los datos de los empleados que trabajan para el departamento 14.
SELECT * from empleador WHERE id_departamento = 14 ;

-- 7. Obtener todos los datos de los empleados cuyo apellido comience por ’P’.
SELECT * from empleados WHERE apellidos LIKE "P%";

-- 8. Obtener el presupuesto total de todos los departamentos.
SELECT SUM(presupuesto) FROM departamentos;

-- 9. Obtener el número de empleados en cada departamento.
SELECT id_departamento, COUNT(DNI) 
FROM empleados 
GROUP BY id_departamento;

-- 10. Obtener un listado completo de empleados, incluyendo por cada empleado los dato del empleado y de su departamento.

SELECT e.DNI, e.nombre, e.apellidos, d.nombre, d.presupuesto
FROM empleados e
JOIN departamentos d 
ON e.id_departamento = d.id_departamento;

SELECT e.DNI, e.nombre, e.apellidos, d.nombre, d.presupuesto
FROM empleados e
NATURAL JOIN departamentos d;

-- 11. Obtener los nombres de los departamentos que tienen más de dos empleados.

SELECT nombre
FROM departamentos 
WHERE id_departamento IN (
	SELECT id_departamento FROM empleados
    GROUP BY id_departamento HAVING COUNT(DNI)>2
    );
    
--  12. Añadir un nuevo departamento: ‘Calidad’, con presupuesto de 40.000 Bs. y código 11. 
-- Añadir un empleado vinculado al departamento recién creado: ESTHER VAZQUEZ, DNI: 89267109.

INSERT INTO departamentos (id_departamento, nombre,presupuesto) 
VALUES (11, "Calidad", 40000);

INSERT INTO empleados (DNI,nombre, apellidos, id_departamento) 
VALUES ("12345678E", "Esther", "Vázquez",11);

-- 13. Aplicar un recorte presupuestario del 10 % a todos los departamentos.
UPDATE departamentos SET presupuesto = presupuesto * 0.9;

INSERT INTO departamentos (id_departamento, nombre,presupuesto) 
VALUES (10, "Ventas", 100000);

INSERT INTO empleados (DNI,nombre, apellidos, id_departamento) 
VALUES ("12345678A", "Michael", "Corleone",10),
("12345678B", "Caperucita", "Roja",10)
;
-- 14. Reasignar a los empleados del departamento 11 ald dept 10-
UPDATE empleados set id_departamento = 10 WHERE id_departamento = 11;


UPDATE empleados set id_departamento = 11 WHERE nombre = "Esther";

-- 15. Despedir a todos los empleados que trabajan para el departamento 11
DELETE FROM empleados WHERE id_departamento = 11;

INSERT INTO empleados (DNI,nombre, apellidos, id_departamento) 
VALUES ("12345678E", "Esther", "Vázquez",11);

-- Despedir (= borrar de la tabla) a todos los empleados de departamentos
-- 16. Despedir a todos los empleados que trabajen para departamentos cuyo presupuesto sea superior a los 60.000 Bs.
DELETE FROM empleados WHERE id_departamento IN (
	SELECT id_departamento FROM departamentos WHERE presupuesto > 60000
);